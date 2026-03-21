import type { NextRequest } from "next/server";

// Server-side env var (no NEXT_PUBLIC_ prefix) takes priority to avoid leaking internal URL
const UPSTREAM_API_BASE = (
  process.env.API_BASE_URL ?? process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://127.0.0.1:8000/v1"
).replace(/\/v1\/?$/, ""); // strip trailing /v1 — we'll add it back below

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

/** Handle CORS pre-flight */
export function OPTIONS() {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

function buildUpstreamUrl(pathSegments: string[], request: NextRequest): URL {
  const upstreamPath = pathSegments.join("/");
  const url = new URL(`${UPSTREAM_API_BASE}/v1/${upstreamPath}`);
  url.search = request.nextUrl.search;
  return url;
}

async function proxyPublicRequest(
  request: NextRequest,
  context: { params: Promise<{ path: string[] }> }
) {
  const { path } = await context.params;
  const upstreamUrl = buildUpstreamUrl(path, request);

  const requestHeaders = new Headers();
  // Forward safe headers only — strip hop-by-hop and host headers
  const forwardableHeaders = ["accept", "accept-encoding", "accept-language", "user-agent", "content-type"];
  for (const name of forwardableHeaders) {
    const value = request.headers.get(name);
    if (value) requestHeaders.set(name, value);
  }

  const isPost = request.method === "POST";
  const body = isPost ? await request.clone().arrayBuffer() : undefined;

  let upstreamResponse: Response;
  try {
    upstreamResponse = await fetch(upstreamUrl, {
      method: request.method,
      headers: requestHeaders,
      body: body,
      redirect: "follow",
      // Vercel edge: avoid caching errors for long
      next: { revalidate: 30 },
    });
  } catch (err) {
    console.error("[proxy/v1] upstream fetch failed", upstreamUrl.toString(), err);
    return new Response(
      JSON.stringify({ error: { code: "upstream_error", message: "Failed to reach API." } }),
      { status: 502, headers: { "Content-Type": "application/json", ...CORS_HEADERS } }
    );
  }

  const responseHeaders = new Headers(upstreamResponse.headers);
  // Overwrite CORS headers so callers (including Claude.ai web_fetch) can always read the response
  for (const [k, v] of Object.entries(CORS_HEADERS)) {
    responseHeaders.set(k, v);
  }
  // Remove hop-by-hop headers that don't apply to the proxied response
  responseHeaders.delete("connection");
  responseHeaders.delete("transfer-encoding");

  return new Response(upstreamResponse.body, {
    status: upstreamResponse.status,
    statusText: upstreamResponse.statusText,
    headers: responseHeaders,
  });
}

export async function GET(
  request: NextRequest,
  context: { params: Promise<{ path: string[] }> }
) {
  return proxyPublicRequest(request, context);
}

export async function POST(
  request: NextRequest,
  context: { params: Promise<{ path: string[] }> }
) {
  return proxyPublicRequest(request, context);
}

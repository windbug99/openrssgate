import type { NextRequest } from "next/server";

const UPSTREAM_API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://127.0.0.1:8000/v1";

function buildUpstreamUrl(pathSegments: string[], request: NextRequest): URL {
  const upstreamPath = pathSegments.join("/");
  const url = new URL(`${UPSTREAM_API_BASE_URL}/admin/${upstreamPath}`);
  url.search = request.nextUrl.search;
  return url;
}

async function proxyAdminRequest(request: NextRequest, context: { params: Promise<{ path: string[] }> }) {
  const { path } = await context.params;
  const upstreamUrl = buildUpstreamUrl(path, request);
  const requestHeaders = new Headers(request.headers);

  requestHeaders.delete("host");
  requestHeaders.delete("connection");
  requestHeaders.delete("content-length");

  const upstreamResponse = await fetch(upstreamUrl, {
    method: request.method,
    headers: requestHeaders,
    body: request.method === "GET" || request.method === "HEAD" ? undefined : await request.text(),
    redirect: "manual",
    cache: "no-store",
  });

  const responseHeaders = new Headers(upstreamResponse.headers);
  const setCookie = upstreamResponse.headers.get("set-cookie");
  if (setCookie) {
    responseHeaders.set("set-cookie", setCookie);
  }

  return new Response(upstreamResponse.body, {
    status: upstreamResponse.status,
    statusText: upstreamResponse.statusText,
    headers: responseHeaders,
  });
}

export async function GET(request: NextRequest, context: { params: Promise<{ path: string[] }> }) {
  return proxyAdminRequest(request, context);
}

export async function POST(request: NextRequest, context: { params: Promise<{ path: string[] }> }) {
  return proxyAdminRequest(request, context);
}

export async function DELETE(request: NextRequest, context: { params: Promise<{ path: string[] }> }) {
  return proxyAdminRequest(request, context);
}

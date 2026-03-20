import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  // API_BASE_URL is a server-side-only env var used by the /api/v1 proxy route.
  // It is NOT exposed to the browser (no NEXT_PUBLIC_ prefix).
  // Falls back to NEXT_PUBLIC_API_BASE_URL if not set.
  env: {
    API_BASE_URL: process.env.API_BASE_URL ?? "",
  },
};

export default nextConfig;

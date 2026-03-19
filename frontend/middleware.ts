import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const ADMIN_STATE_COOKIE = "openrssgate_admin_state";

function isProtectedAdminPath(pathname: string): boolean {
  return pathname.startsWith("/admin") && pathname !== "/admin/login" && pathname !== "/admin/setup-otp";
}

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const adminState = request.cookies.get(ADMIN_STATE_COOKIE)?.value;

  if (pathname === "/admin/login") {
    if (adminState === "verified") {
      return NextResponse.redirect(new URL("/admin/sources", request.url));
    }
    if (adminState === "pending") {
      return NextResponse.redirect(new URL("/admin/setup-otp", request.url));
    }
    return NextResponse.next();
  }

  if (pathname === "/admin/setup-otp") {
    if (adminState === "verified") {
      return NextResponse.redirect(new URL("/admin/sources", request.url));
    }
    if (adminState !== "pending") {
      return NextResponse.redirect(new URL("/admin/login", request.url));
    }
    return NextResponse.next();
  }

  if (isProtectedAdminPath(pathname) && adminState !== "verified") {
    return NextResponse.redirect(new URL(adminState === "pending" ? "/admin/setup-otp" : "/admin/login", request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/admin/:path*"],
};

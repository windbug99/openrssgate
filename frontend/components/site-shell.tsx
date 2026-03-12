"use client";

import Link from "next/link";
import type { ReactNode } from "react";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="shell">
      <header className="topbar">
        <div className="topbar-left">
          <Link href="/" className="brand">
            OpenRSSGate
          </Link>
        </div>
        <nav className="nav">
          <Link href="/" className="nav-link">
            Home
          </Link>
          <Link href="/sources" className="nav-link">
            Sources
          </Link>
          <Link href="/feeds" className="nav-link">
            Feeds
          </Link>
          <Link href="/docs" className="nav-link">
            Docs
          </Link>
        </nav>
      </header>
      {children}
    </div>
  );
}

"use client";

import Link from "next/link";
import type { ReactNode } from "react";
import { Button } from "@heroui/react";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="shell">
      <header className="topbar">
        <Link href="/" className="brand">
          OpenRSSGate
        </Link>
        <nav className="nav heroui-nav">
          <Link href="/">
            <Button variant="ghost" size="sm">
              Home
            </Button>
          </Link>
          <Link href="/explore">
            <Button variant="ghost" size="sm">
              Explore
            </Button>
          </Link>
          <Link href="/docs">
            <Button variant="ghost" size="sm">
              Docs
            </Button>
          </Link>
        </nav>
      </header>
      {children}
    </div>
  );
}

"use client";

import Link from "next/link";
import type { ReactNode } from "react";
import { Button } from "@heroui/react";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="shell">
      <header className="topbar">
        <div className="topbar-left">
          <Link href="/" className="brand">
            OpenRSSGate
          </Link>
          <nav className="nav">
            <Link href="/">
              <Button variant="tertiary" size="sm">
                Home
              </Button>
            </Link>
            <Link href="/sources">
              <Button variant="tertiary" size="sm">
                Sources
              </Button>
            </Link>
            <Link href="/feeds">
              <Button variant="tertiary" size="sm">
                Feeds
              </Button>
            </Link>
            <Link href="/docs">
              <Button variant="tertiary" size="sm">
                Docs
              </Button>
            </Link>
          </nav>
        </div>
      </header>
      {children}
    </div>
  );
}

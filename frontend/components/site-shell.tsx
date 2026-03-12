import Link from "next/link";
import type { ReactNode } from "react";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="shell">
      <header className="topbar">
        <Link href="/" className="brand">
          RSS Gateway
        </Link>
        <nav className="nav">
          <Link href="/">Home</Link>
          <Link href="/explore">Explore</Link>
          <Link href="/docs">Docs</Link>
        </nav>
      </header>
      {children}
    </div>
  );
}

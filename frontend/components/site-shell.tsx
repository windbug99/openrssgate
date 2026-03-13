import Link from "next/link";
import type { ReactNode } from "react";

import { Button } from "@/components/ui/button";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-8 md:px-6 md:py-10">
      <header className="mb-10 flex flex-col gap-4 border-b pb-4 md:flex-row md:items-center md:justify-between">
        <Link href="/" className="text-xl font-semibold tracking-tight md:text-2xl">
          OpenRSSGate
        </Link>
        <nav className="flex items-center gap-2">
          <Button asChild variant="ghost" size="sm">
            <a href="#home">Home</a>
          </Button>
          <Button asChild variant="ghost" size="sm">
            <a href="#docs">Docs</a>
          </Button>
          <Button asChild variant="ghost" size="sm">
            <a href="#sources">Sources</a>
          </Button>
        </nav>
      </header>
      {children}
    </div>
  );
}

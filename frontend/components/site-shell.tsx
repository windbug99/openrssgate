import Link from "next/link";
import type { ReactNode } from "react";

import { Button } from "@/components/ui/button";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="mx-auto w-full max-w-[1040px] px-6 pt-3 pb-8 md:px-10 md:pt-4 md:pb-10">
      <header className="mb-10 flex min-h-[56px] flex-col gap-3 border-b pb-3 md:flex-row md:items-center md:justify-between">
        <Link href="/" className="text-[1.25rem] font-semibold tracking-[-0.04em] text-foreground">
          OpenRSSGate
        </Link>
        <nav className="flex items-center gap-3">
          <Button asChild variant="ghost" size="sm" className="h-9 px-3 text-[15px] font-normal text-muted-foreground">
            <a href="#home">Home</a>
          </Button>
          <Button asChild variant="ghost" size="sm" className="h-9 px-3 text-[15px] font-normal text-muted-foreground">
            <a href="#docs">Docs</a>
          </Button>
          <Button asChild variant="ghost" size="sm" className="h-9 px-3 text-[15px] font-normal text-muted-foreground">
            <a href="#sources">Sources</a>
          </Button>
        </nav>
      </header>
      {children}
    </div>
  );
}

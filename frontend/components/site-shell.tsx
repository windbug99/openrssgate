import Link from "next/link";
import type { ReactNode } from "react";
import { Github } from "lucide-react";

import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";

export function SiteShell({ children }: { children: ReactNode }) {
  return (
    <div className="w-full">
      <header className="w-full border-b border-border/80">
        <div className="mx-auto flex w-full max-w-[1040px] min-h-[56px] flex-col gap-3 px-6 py-3 md:flex-row md:items-center md:justify-between md:px-10 md:py-4">
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
            <span className="ml-1 h-8 w-px bg-border/80" aria-hidden="true" />
            <ThemeToggle />
          </nav>
        </div>
      </header>

      <div className="mx-auto w-full max-w-[1040px] border-x border-border/80 pb-8 md:pb-10">
        {children}
      </div>

      <footer className="w-full border-t border-border/80">
        <div className="mx-auto flex w-full max-w-[1040px] items-center justify-center px-6 py-8 md:px-10">
          <div className="flex flex-wrap items-center justify-center gap-2 text-[13px] text-muted-foreground">
            <a
              href="https://github.com/windbug99/openrssgate"
              target="_blank"
              rel="noreferrer"
              className="inline-flex items-center gap-1.5 transition-colors hover:text-foreground"
            >
              <Github className="h-4 w-4" />
              <span>github</span>
            </a>
            <span>·</span>
            <span>mit license</span>
            <span>·</span>
            <span>built by Promethium</span>
          </div>
        </div>
      </footer>
    </div>
  );
}

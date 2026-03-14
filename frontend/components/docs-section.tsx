"use client";

import { useEffect, useState } from "react";

import { BookMarked, Bot, Braces, Check, Copy, TerminalSquare } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { cn } from "@/lib/utils";

const apiCommands = [
  "GET /v1/sources",
  "GET /v1/sources/{source_id}",
  "GET /v1/feeds?since=7d",
  "POST /v1/sources",
];

const mcpInfo = [
  "SSE: https://openrssgate-production.up.railway.app/mcp/sse",
  "Manifest: https://openrssgate-production.up.railway.app/mcp/tools",
  "Tools: search_sources, get_source, get_recent_feeds, get_source_feeds",
];

const cliInfo = [
  "export OPENRSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1",
  "openrssgate list",
  "openrssgate feeds --since 7d",
];

type DocsSectionProps = {
  id?: string;
};

function InterfaceDialog({
  title,
  description,
  lines,
  trigger,
}: {
  title: string;
  description: string;
  lines: string[];
  trigger: React.ReactNode;
}) {
  const [copiedLine, setCopiedLine] = useState<string | null>(null);

  useEffect(() => {
    if (!copiedLine) return;

    const timeoutId = window.setTimeout(() => setCopiedLine(null), 1600);
    return () => window.clearTimeout(timeoutId);
  }, [copiedLine]);

  async function handleCopy(line: string) {
    await navigator.clipboard.writeText(line);
    setCopiedLine(line);
  }

  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>
        <div className="bg-muted/10 px-6 py-5">
          <DialogDescription className="mb-5">{description}</DialogDescription>
          <div className="border border-border/80 bg-background">
            {lines.map((line, index) => {
              const separatorIndex = line.indexOf(": ");
              const hasLabel = separatorIndex !== -1;
              const label = hasLabel ? line.slice(0, separatorIndex + 1) : null;
              const value = hasLabel ? line.slice(separatorIndex + 2) : line;

              return (
                <div
                  key={line}
                  className={cn(
                    "grid items-start gap-3 px-4 py-3 text-[0.92rem] leading-7",
                    index !== lines.length - 1 && "border-b border-border/80",
                    hasLabel ? "md:grid-cols-[110px_minmax(0,1fr)_36px]" : "grid-cols-[minmax(0,1fr)_36px]",
                  )}
                >
                  {label ? <div className="font-mono text-muted-foreground">{label}</div> : null}
                  <div className="font-mono break-all text-foreground/80">{value}</div>
                  <button
                    type="button"
                    onClick={() => handleCopy(line)}
                    className="inline-flex h-9 w-9 items-center justify-center border border-border/80 text-muted-foreground transition-colors hover:bg-muted/30 hover:text-foreground"
                    aria-label={`Copy ${title} line`}
                  >
                    {copiedLine === line ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
                  </button>
                </div>
              );
            })}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}

export function DocsSection({ id }: DocsSectionProps) {
  return (
    <section id={id} className="-mx-6 scroll-mt-24 space-y-6 md:-mx-10">
      <div className="border-t border-border/70 px-6 pt-8 md:px-10">
        <div className="mb-5 flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-muted-foreground">
          <BookMarked className="h-4 w-4" />
          <span>Docs</span>
        </div>
        <h2 className="text-[1.5rem] font-bold tracking-[-0.04em] text-foreground">One index. Your interface.</h2>
        <p className="mt-4 w-full text-[16px] leading-[1.9] text-muted-foreground">
          The source index is public and shared.
          <br />
          How you access it is up to you — discover feeds in the browser, integrate via REST, call it as an AI tool
          through MCP, or run it in the terminal with the CLI.
        </p>
        <p className="mt-4 w-full text-[16px] leading-[1.9] text-muted-foreground">Same data. Every workflow.</p>
      </div>

      <div className="px-6 md:px-10">
        <div className="grid w-full grid-cols-3 border border-border/80">
          <InterfaceDialog
            title="REST API"
            description="Public read endpoints plus anonymous source registration."
            lines={apiCommands}
            trigger={
              <Button variant="ghost" className="h-12 w-full rounded-none border-r border-border/80 px-5">
                <Braces className="mr-2 h-4 w-4" />
                API
              </Button>
            }
          />
          <InterfaceDialog
            title="Remote MCP"
            description="Remote MCP transport for assistants and agent runtimes."
            lines={mcpInfo}
            trigger={
              <Button variant="ghost" className="h-12 w-full rounded-none border-r border-border/80 px-5">
                <Bot className="mr-2 h-4 w-4" />
                MCP
              </Button>
            }
          />
          <InterfaceDialog
            title="CLI"
            description="Terminal access for listing sources and recent feeds."
            lines={cliInfo}
            trigger={
              <Button variant="ghost" className="h-12 w-full rounded-none px-5">
                <TerminalSquare className="mr-2 h-4 w-4" />
                CLI
              </Button>
            }
          />
        </div>
      </div>
    </section>
  );
}

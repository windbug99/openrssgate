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

type DocSection = {
  heading: string;
  lines: string[];
};

const apiCommands = [
  {
    heading: "Core",
    lines: [
      "List sources: GET /v1/sources",
      "Source detail: GET /v1/sources/{source_id}",
      "Source feeds: GET /v1/sources/{source_id}/feeds",
      "Feed detail: GET /v1/feeds/{feed_id}",
    ],
  },
  {
    heading: "Search",
    lines: [
      "Feeds: GET /v1/feeds?q=openai&since=7d",
      "Stats: GET /v1/stats",
      "Validate: POST /v1/sources/validate",
      "Status: GET /v1/sources/{source_id}/status",
    ],
  },
];

const mcpInfo = [
  {
    heading: "Status",
    lines: [
      "Remote HTTP MCP: https://openrssgate-production.up.railway.app/mcp",
      "Local stdio: available for Claude Desktop local setup",
    ],
  },
  {
    heading: "Debug",
    lines: [
      "SSE: https://openrssgate-production.up.railway.app/mcp/sse",
      "Manifest: https://openrssgate-production.up.railway.app/mcp/tools",
    ],
  },
  {
    heading: "Use",
    lines: [
      "Find sources: Find English AI blogs in OpenRSSGate",
      "Recent feeds: Show recent feeds about OpenAI from the last 7 days",
      "Source feeds: Get recent feeds from Platformer in OpenRSSGate",
      "Source detail: Get the source metadata for Platformer in OpenRSSGate",
    ],
  },
  {
    heading: "Tools",
    lines: [
      "Available: search_sources, get_source, get_source_status, get_stats",
      "Feeds: get_recent_feeds, list_feeds, get_feed, get_source_feeds, get_source_feed",
      "Source setup: validate_source, autofill_source, create_source",
    ],
  },
];

const cliInfo = [
  {
    heading: "Install",
    lines: [
      "Homebrew: brew tap windbug99/homebrew-tap && brew install openrssgate",
      "pipx: pipx install openrssgate",
    ],
  },
  {
    heading: "Find IDs",
    lines: [
      "Find source ID: openrssgate list --keyword platformer",
      "Use source feeds: openrssgate feeds <source_id>",
      "Use single feed: openrssgate feed <feed_id>",
    ],
  },
  {
    heading: "Run",
    lines: [
      "List sources: openrssgate list",
      "Recent feeds: openrssgate feeds --q openai --since 7d",
      "Quick stats: openrssgate stats",
    ],
  },
  {
    heading: "Common mistakes",
    lines: [
      "Source vs feed: `feeds <source_id>` lists a source's feeds",
      "Single feed: `feed <feed_id>` shows one feed item only",
      "Validation: use a direct RSS URL, not a website homepage",
    ],
  },
  {
    heading: "Custom API",
    lines: [
      "export OPENRSSGATE_API_BASE_URL=http://127.0.0.1:8000/v1",
    ],
  },
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
  lines: string[] | DocSection[];
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

  const isSectioned = typeof lines[0] !== "string";

  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>
        <div className="min-h-0 overflow-y-auto bg-muted/10 px-6 py-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
          <DialogDescription className="mb-5">{description}</DialogDescription>
          {isSectioned ? (
            <div className="space-y-4">
              {(lines as DocSection[]).map((section) => (
                <div key={section.heading} className="border border-border/80 bg-background">
                  <div className="border-b border-border/80 px-4 py-2 text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">
                    {section.heading}
                  </div>
                  {section.lines.map((line, index) => {
                    const separatorIndex = line.indexOf(": ");
                    const hasLabel = separatorIndex !== -1;
                    const label = hasLabel ? line.slice(0, separatorIndex + 1) : null;
                    const value = hasLabel ? line.slice(separatorIndex + 2) : line;

                    return (
                      <div
                        key={line}
                        className={cn(
                          "grid items-start gap-3 px-4 py-3 text-[0.92rem] leading-7",
                          index !== section.lines.length - 1 && "border-b border-border/80",
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
              ))}
            </div>
          ) : (
            <div className="border border-border/80 bg-background">
              {(lines as string[]).map((line, index) => {
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
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}

export function DocsSection({ id }: DocsSectionProps) {
  return (
    <section id={id} className="-mx-6 scroll-mt-24 space-y-6 md:-mx-10">
      <div className="border-t border-border/70 px-6 pt-8 md:px-10">
        <div className="mb-5 flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-[#E85D4A]">
          <BookMarked className="h-4 w-4 text-[#E85D4A]" />
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
            description="Public read endpoints plus source validation. Use REST directly if you want to query sources, feeds, stats, or source health from your own app."
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
            description="Connect MCP clients to the remote HTTP endpoint at `/mcp` for session-based JSON-RPC tool access. Legacy SSE and manifest routes remain available for debugging."
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
            description="Install once, then use the public OpenRSSGate API from your terminal. Homebrew needs `brew tap windbug99/homebrew-tap` first because `openrssgate` is published through a custom tap, not homebrew-core."
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

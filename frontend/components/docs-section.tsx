"use client";

import { Bot, Braces, TerminalSquare } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

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
  "export RSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1",
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
  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          <DialogDescription>{description}</DialogDescription>
        </DialogHeader>
        <div className="rounded-lg border bg-muted/40 p-4">
          <div className="space-y-2 font-mono text-sm text-muted-foreground">
            {lines.map((line) => (
              <div key={line}>{line}</div>
            ))}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}

export function DocsSection({ id }: DocsSectionProps) {
  return (
    <section id={id} className="scroll-mt-24 space-y-6">
      <div className="space-y-3">
        <p className="text-sm font-medium uppercase tracking-[0.18em] text-muted-foreground">Docs</p>
        <h2 className="text-3xl font-semibold tracking-tight md:text-4xl">One index, three ways to access it</h2>
        <p className="max-w-3xl text-base leading-7 text-muted-foreground md:text-lg">
          OpenRSSGate keeps the public source index available to browsers, scripts, and agents through a single shared
          dataset. Use the web UI for discovery, the API for app integration, MCP for tool use inside assistants, and
          CLI for terminal workflows.
        </p>
      </div>

      <div className="flex flex-wrap gap-3">
        <InterfaceDialog
          title="REST API"
          description="Public read endpoints plus anonymous source registration."
          lines={apiCommands}
          trigger={
            <Button variant="outline">
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
            <Button variant="outline">
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
            <Button variant="outline">
              <TerminalSquare className="mr-2 h-4 w-4" />
              CLI
            </Button>
          }
        />
      </div>
    </section>
  );
}

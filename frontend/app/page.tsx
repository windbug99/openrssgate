import { ArrowRight } from "lucide-react";

import { DocsSection } from "@/components/docs-section";
import { SiteShell } from "@/components/site-shell";
import { SourcesSection } from "@/components/sources-section";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { listSources } from "@/lib/api";

export default async function HomePage() {
  const sources = await listSources({ limit: "40" }).catch(() => ({ items: [], page: 1, limit: 40, total: 0 }));

  return (
    <SiteShell>
      <section
        id="home"
        className="scroll-mt-24 space-y-8 border-b border-border/70 pb-12 md:grid md:grid-cols-[minmax(0,1.2fr)_320px] md:gap-8 md:space-y-0"
      >
        <div className="space-y-8">
          <div className="space-y-4">
            <span className="inline-flex rounded-full border border-border bg-muted px-3 py-1 text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">
              open rss index
            </span>
            <div className="space-y-5">
              <h1 className="max-w-4xl text-4xl font-semibold tracking-tight md:text-6xl">
                OpenRSSGate makes public RSS infrastructure usable again.
              </h1>
              <p className="max-w-3xl text-lg leading-8 text-muted-foreground">
                OpenRSSGate is an open index for public RSS and Atom sources. It is designed for people who want a
                clean discovery surface and for agents that need a stable gateway for search, retrieval, and feed
                metadata access.
              </p>
              <p className="max-w-3xl text-base leading-7 text-muted-foreground">
                Instead of building another reader, the project focuses on a shared source layer: register feeds once,
                collect them continuously, and expose the same index through the web, REST API, MCP, and CLI.
              </p>
            </div>
          </div>

          <div className="flex flex-wrap gap-3">
            <Button asChild>
              <a href="#sources">
                Browse sources
                <ArrowRight className="h-4 w-4" />
              </a>
            </Button>
            <Button asChild variant="outline">
              <a href="#docs">Read interface docs</a>
            </Button>
          </div>
        </div>

        <Card className="border-border/70 bg-card/60">
          <CardContent className="space-y-5 p-6">
            <div className="space-y-1">
              <p className="text-sm font-medium uppercase tracking-[0.18em] text-muted-foreground">Current index</p>
              <h2 className="text-2xl font-semibold tracking-tight">{sources.total} public sources</h2>
            </div>
            <div className="space-y-3 text-sm leading-6 text-muted-foreground">
              <p>Anonymous web registration with automatic review rules.</p>
              <p>Read-only REST API, remote MCP surface, and terminal CLI access.</p>
              <p>Source quality checks for stale feeds, duplicate sites, sparse metadata, and spam-like titles.</p>
            </div>
          </CardContent>
        </Card>
      </section>

      <div className="mt-12 space-y-16">
        <DocsSection id="docs" />
        <SourcesSection id="sources" sources={sources.items} />
      </div>
    </SiteShell>
  );
}

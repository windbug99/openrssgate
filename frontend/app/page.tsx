import { ArrowRight, Rss } from "lucide-react";

import { DocsSection } from "@/components/docs-section";
import { SiteShell } from "@/components/site-shell";
import { SourcesSection } from "@/components/sources-section";
import { Button } from "@/components/ui/button";
import { getStats, listSources } from "@/lib/api";

function formatDateTime(value: string | null): string {
  if (!value) return "Not collected yet";
  const date = new Date(value);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");

  return `${year}.${month}.${day} ${hours}:${minutes}`;
}

export default async function HomePage() {
  const sources = await listSources({ limit: "100" }).catch(() => ({ items: [], page: 1, limit: 100, total: 0 }));
  const stats = await getStats().catch(() => ({
    total_sources: sources.total,
    active_sources: sources.total,
    total_feeds: 0,
    feeds_last_24h: 0,
  }));
  const latestFetchedAt = sources.items.reduce<string | null>((latest, source) => {
    if (!source.last_fetched_at) return latest;
    if (!latest) return source.last_fetched_at;
    return new Date(source.last_fetched_at).getTime() > new Date(latest).getTime() ? source.last_fetched_at : latest;
  }, null);

  return (
    <SiteShell>
      <section id="home" className="scroll-mt-24">
        <div className="bg-background px-6 py-14 text-center md:px-10 md:py-14">
          <div className="flex justify-center">
            <div className="home-status-badge">
              <Rss className="home-status-badge__icon h-3.5 w-3.5" />
              <span>
                Last fetched: {formatDateTime(latestFetchedAt)} · {stats.active_sources} active sources · {stats.feeds_last_24h} feeds in the last 24h
              </span>
            </div>
          </div>

          <div className="mx-auto mt-8 flex max-w-[900px] flex-col items-center space-y-5">
            <h2 className="max-w-[780px] text-[2.4rem] font-semibold leading-[1.08] tracking-[-0.04em] text-foreground">
              <span className="text-[#E85D4A]">RSS</span> isn't dead. It's just scattered.
            </h2>
            <p className="max-w-[860px] text-[16px] leading-[1.95] text-muted-foreground">
              Feeds are fragmented. Platforms decide what gets read.
              <br />
              The independent blogs, the honest opinions, the writing that matters —
              <br />
              buried under noise, invisible to algorithms.
            </p>
            <p className="max-w-[860px] text-[16px] leading-[1.95] text-muted-foreground">
              OpenRSSGate is a shared public index for RSS sources.
              <br />
              Register once. Collected continuously. Accessible to everyone —
              <br />
              browsers, apps, terminal workflows, and AI agents
              <br />
              through REST, MCP, and CLI.
            </p>
            <p className="max-w-[860px] text-[16px] leading-[1.95] text-muted-foreground">
              Write anywhere. Be found everywhere.
            </p>
          </div>

          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Button asChild size="lg">
              <a href="#sources">
                Browse sources
                <ArrowRight className="h-4 w-4" />
              </a>
            </Button>
            <Button asChild variant="outline" size="lg">
              <a href="#docs">Read interface docs</a>
            </Button>
          </div>
        </div>
      </section>

      <div className="space-y-20 px-6 md:px-10">
        <DocsSection id="docs" />
        <SourcesSection
          id="sources"
          sources={sources.items}
          stats={stats}
          initialPage={sources.page}
          pageSize={sources.limit}
          totalSources={sources.total}
        />
      </div>
    </SiteShell>
  );
}

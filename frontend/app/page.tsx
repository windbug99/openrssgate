import { ArrowRight, Rss } from "lucide-react";

import { DocsSection } from "@/components/docs-section";
import { SiteShell } from "@/components/site-shell";
import { Badge } from "@/components/ui/badge";
import { SourcesSection } from "@/components/sources-section";
import { Button } from "@/components/ui/button";
import { listSources } from "@/lib/api";

function formatDateTime(value: string | null): string {
  if (!value) return "Not collected yet";
  return new Intl.DateTimeFormat("ko-KR", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

export default async function HomePage() {
  const sources = await listSources({ limit: "40" }).catch(() => ({ items: [], page: 1, limit: 40, total: 0 }));
  const latestFetchedAt = sources.items.reduce<string | null>((latest, source) => {
    if (!source.last_fetched_at) return latest;
    if (!latest) return source.last_fetched_at;
    return new Date(source.last_fetched_at).getTime() > new Date(latest).getTime() ? source.last_fetched_at : latest;
  }, null);

  return (
    <SiteShell>
      <section id="home" className="scroll-mt-24 space-y-8 pt-2 text-center">
        <div className="flex justify-center">
          <Badge
            variant="outline"
            className="rounded-full px-4 py-2 text-[13px] font-medium tracking-normal"
          >
            <Rss className="mr-2 h-3.5 w-3.5" />
            Last fetched: {formatDateTime(latestFetchedAt)} · {sources.total} public sources
          </Badge>
        </div>

        <div className="mx-auto flex max-w-[900px] flex-col items-center space-y-5">
          <h2 className="max-w-[780px] text-[2.4rem] font-semibold leading-[1.08] tracking-[-0.04em] text-foreground">
            OpenRSSGate makes public RSS infrastructure usable again.
          </h2>
          <p className="max-w-[860px] text-[16px] leading-[1.95] text-muted-foreground">
            OpenRSSGate is a public source index for RSS and Atom feeds. It keeps source discovery, collection, and
            metadata access available through one shared gateway instead of scattering the same work across separate
            readers and custom scripts.
          </p>
          <p className="max-w-[860px] text-[16px] leading-[1.95] text-muted-foreground">
            Register feeds once, collect them continuously, and expose the same index to browsers, applications,
            terminal workflows, and agent runtimes through REST, MCP, and CLI interfaces.
          </p>
        </div>

        <div className="flex flex-wrap justify-center gap-3">
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
      </section>

      <div className="mt-20 space-y-20">
        <DocsSection id="docs" />
        <SourcesSection id="sources" sources={sources.items} />
      </div>
    </SiteShell>
  );
}

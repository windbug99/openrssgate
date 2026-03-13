import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { FeedList } from "@/components/feed-list";
import { SiteShell } from "@/components/site-shell";
import { SourceRegisterForm } from "@/components/source-register-form";
import { SourceCard } from "@/components/source-card";
import { listFeeds, listSources } from "@/lib/api";

export default async function HomePage() {
  const [sources, feeds] = await Promise.all([
    listSources({ limit: "4" }).catch(() => ({ items: [], page: 1, limit: 4, total: 0 })),
    listFeeds({ limit: "5", since: "7d" }).catch(() => ({ items: [], page: 1, limit: 5, total: 0 })),
  ]);

  return (
    <SiteShell>
      <section className="grid gap-6 lg:grid-cols-[1.2fr_0.8fr]">
        <Card>
          <CardContent className="space-y-8 p-8 md:p-10">
            <div className="space-y-4">
              <span className="inline-flex rounded-full bg-muted px-3 py-1 text-xs font-medium text-muted-foreground">
                RSS infrastructure for humans and AI
              </span>
              <div className="space-y-4">
                <h1 className="max-w-3xl text-4xl font-semibold tracking-tight md:text-6xl">
                  Register once. Query everywhere.
                </h1>
                <p className="max-w-2xl text-base leading-7 text-muted-foreground md:text-lg">
                  RSS Gateway centralizes public feeds into a searchable index. People use the web interface. Agents
                  use the same data through REST, MCP, and CLI.
                </p>
              </div>
            </div>
            <div className="grid gap-3 md:grid-cols-3">
              <Card>
                <CardContent className="space-y-1 p-5">
                  <strong className="block text-3xl font-semibold">{sources.total}</strong>
                  <span className="text-sm text-muted-foreground">Indexed sources</span>
                </CardContent>
              </Card>
              <Card>
                <CardContent className="space-y-1 p-5">
                  <strong className="block text-3xl font-semibold">{feeds.total}</strong>
                  <span className="text-sm text-muted-foreground">Recent feeds</span>
                </CardContent>
              </Card>
              <Card>
                <CardContent className="space-y-1 p-5">
                  <strong className="block text-3xl font-semibold">Open</strong>
                  <span className="text-sm text-muted-foreground">Anonymous web registration</span>
                </CardContent>
              </Card>
            </div>
          </CardContent>
        </Card>
        <SourceRegisterForm />
      </section>

      <section className="mt-8 space-y-5">
        <div className="flex items-end justify-between gap-4">
          <div>
            <h2 className="text-2xl font-semibold tracking-tight">Fresh Sources</h2>
            <p className="mt-2 text-sm text-muted-foreground">
              Newly indexed sources that passed validation and are available for search.
            </p>
          </div>
          <Button asChild variant="outline">
            <Link href="/explore">Explore all</Link>
          </Button>
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          {sources.items.map((source) => (
            <SourceCard key={source.id} source={source} />
          ))}
        </div>
      </section>

      <section className="mt-8 space-y-5">
        <div className="flex items-end justify-between gap-4">
          <div>
            <h2 className="text-2xl font-semibold tracking-tight">Recent Feed Activity</h2>
            <p className="mt-2 text-sm text-muted-foreground">
              Publicly available feed metadata collected from active sources.
            </p>
          </div>
        </div>
        <FeedList feeds={feeds.items} />
      </section>
    </SiteShell>
  );
}

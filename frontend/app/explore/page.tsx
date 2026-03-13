import { FeedList } from "@/components/feed-list";
import { SiteShell } from "@/components/site-shell";
import { SourceCard } from "@/components/source-card";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { listFeeds, listSources } from "@/lib/api";

type ExploreProps = {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
};

function getParam(value: string | string[] | undefined): string | undefined {
  if (Array.isArray(value)) return value[0];
  return value;
}

export default async function ExplorePage({ searchParams }: ExploreProps) {
  const params = await searchParams;
  const keyword = getParam(params.keyword);
  const language = getParam(params.language);
  const category = getParam(params.category);
  const tag = getParam(params.tag);
  const since = getParam(params.since) ?? "24h";

  const [sources, feeds] = await Promise.all([
    listSources({ keyword, language, category, tag, limit: "12" }).catch(() => ({ items: [], page: 1, limit: 12, total: 0 })),
    listFeeds({ language, since, limit: "12" }).catch(() => ({ items: [], page: 1, limit: 12, total: 0 })),
  ]);

  return (
    <SiteShell>
      <section>
        <Card>
          <CardHeader className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
              <CardTitle>Source Explore</CardTitle>
              <CardDescription>Filter the public source index by keyword, language, category, and tag.</CardDescription>
          </div>
            <span className="rounded-full bg-muted px-3 py-1 text-xs font-medium text-muted-foreground">
              Recent feeds window: {since}
            </span>
          </CardHeader>
          <CardContent>
            <form className="grid gap-3 md:grid-cols-2" action="/explore">
              <Input name="keyword" placeholder="keyword" defaultValue={keyword} />
              <Input name="language" placeholder="language" defaultValue={language} />
              <Input name="category" placeholder="category" defaultValue={category} />
              <Input name="tag" placeholder="tag" defaultValue={tag} />
              <Input name="since" placeholder="since: 24h / 7d" defaultValue={since} />
              <Button className="md:w-fit" type="submit">
                Apply filters
              </Button>
            </form>
          </CardContent>
        </Card>
      </section>

      <section className="mt-8 space-y-5">
        <div className="flex items-end justify-between gap-4">
          <div>
            <h2 className="text-2xl font-semibold tracking-tight">Sources</h2>
            <p className="mt-2 text-sm text-muted-foreground">{sources.total} active sources matched the current filters.</p>
          </div>
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
            <h2 className="text-2xl font-semibold tracking-tight">Recent Feeds</h2>
            <p className="mt-2 text-sm text-muted-foreground">
              {feeds.total} feed entries are available in the selected time window.
            </p>
          </div>
        </div>
        <FeedList feeds={feeds.items} />
      </section>
    </SiteShell>
  );
}

import { FeedList } from "@/components/feed-list";
import { SiteShell } from "@/components/site-shell";
import { SourceCard } from "@/components/source-card";
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
      <section className="card panel">
        <div className="page-head">
          <div>
            <h2>Source Explore</h2>
            <p className="muted">Filter the public source index by keyword, language, category, and tag.</p>
          </div>
          <span className="pill">Recent feeds window: {since}</span>
        </div>
        <form className="filters" action="/explore">
          <input name="keyword" placeholder="keyword" defaultValue={keyword} />
          <input name="language" placeholder="language" defaultValue={language} />
          <input name="category" placeholder="category" defaultValue={category} />
          <input name="tag" placeholder="tag" defaultValue={tag} />
          <input name="since" placeholder="since: 24h / 7d" defaultValue={since} />
          <button className="button" type="submit">
            Apply filters
          </button>
        </form>
      </section>

      <section className="section">
        <div className="page-head">
          <div>
            <h2>Sources</h2>
            <p className="muted">{sources.total} active sources matched the current filters.</p>
          </div>
        </div>
        <div className="source-grid">
          {sources.items.map((source) => (
            <SourceCard key={source.id} source={source} />
          ))}
        </div>
      </section>

      <section className="section">
        <div className="page-head">
          <div>
            <h2>Recent Feeds</h2>
            <p className="muted">{feeds.total} feed entries are available in the selected time window.</p>
          </div>
        </div>
        <FeedList feeds={feeds.items} />
      </section>
    </SiteShell>
  );
}

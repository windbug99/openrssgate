import { FeedList } from "@/components/feed-list";
import { SiteShell } from "@/components/site-shell";
import { listFeeds } from "@/lib/api";

export default async function FeedsPage() {
  const feeds = await listFeeds({ limit: "30", since: "30d" }).catch(() => ({ items: [], page: 1, limit: 30, total: 0 }));

  return (
    <SiteShell>
      <section className="section">
        <div className="page-head">
          <div>
            <h1 className="page-title">Feeds</h1>
            <p className="muted">Recently collected feed metadata from active sources.</p>
          </div>
        </div>
        {feeds.items.length ? (
          <FeedList feeds={feeds.items} />
        ) : (
          <div className="hero-card empty-state">
            <p className="muted">No feeds are available in the current window.</p>
          </div>
        )}
      </section>
    </SiteShell>
  );
}

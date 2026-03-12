import { FeedList } from "@/components/feed-list";
import { SiteShell } from "@/components/site-shell";
import { listFeeds } from "@/lib/api";

export default async function FeedsPage() {
  const feeds = await listFeeds({ limit: "30", since: "30d" }).catch(() => ({ items: [], page: 1, limit: 30, total: 0 }));

  return (
    <SiteShell>
      <section>
        <div className="page-head">
          <div>
            <h1 className="text-4xl font-semibold tracking-tight md:text-5xl">Feeds</h1>
            <p className="mt-3 text-lg text-default-500">Recently collected feed metadata from active sources.</p>
          </div>
        </div>
        {feeds.items.length ? (
          <FeedList feeds={feeds.items} />
        ) : (
          <div className="rounded-large border border-default-200 bg-content1 p-6 text-default-500 shadow-sm">
            No feeds are available in the current window.
          </div>
        )}
      </section>
    </SiteShell>
  );
}

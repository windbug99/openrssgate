import type { Feed } from "@/lib/api";

function formatDate(value: string | null): string {
  if (!value) return "Unknown publish time";
  return new Intl.DateTimeFormat("ko-KR", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

export function FeedList({ feeds }: { feeds: Feed[] }) {
  return (
    <div className="feed-list">
      {feeds.map((feed) => (
        <article className="card feed-item" key={feed.id}>
          <h3>{feed.title}</h3>
          <p>{formatDate(feed.published_at)}</p>
          <p>
            <a href={feed.feed_url} target="_blank" rel="noreferrer">
              {feed.feed_url}
            </a>
          </p>
        </article>
      ))}
    </div>
  );
}

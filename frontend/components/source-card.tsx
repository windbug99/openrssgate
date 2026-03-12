import type { Source } from "@/lib/api";

function formatDate(value: string | null): string {
  if (!value) return "Not collected yet";
  return new Intl.DateTimeFormat("ko-KR", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

export function SourceCard({ source }: { source: Source }) {
  return (
    <article className="card source-card">
      <header>
        <div>
          <h3>{source.title}</h3>
          <p className="muted">{source.description ?? "No description was provided by the feed."}</p>
        </div>
        <a className="button secondary" href={source.site_url} target="_blank" rel="noreferrer">
          Visit
        </a>
      </header>
      <div className="pill-row">
        {source.language ? <span className="pill">{source.language}</span> : null}
        {source.category ? <span className="pill">{source.category}</span> : null}
        {source.tags.map((tag) => (
          <span className="pill" key={tag}>
            {tag}
          </span>
        ))}
      </div>
      <div className="source-meta">
        <span>RSS: {source.rss_url}</span>
        <span>Last fetched: {formatDate(source.last_fetched_at)}</span>
        <span>Last published: {formatDate(source.last_published_at)}</span>
      </div>
    </article>
  );
}

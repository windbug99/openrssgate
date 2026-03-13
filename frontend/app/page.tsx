import Link from "next/link";

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
      <section className="hero">
        <div className="card hero-copy">
          <span className="eyebrow">RSS infrastructure for humans and AI</span>
          <h1>Register once. Query everywhere.</h1>
          <p>
            RSS Gateway centralizes public feeds into a searchable index. People use the web interface. Agents use the
            same data through REST, MCP, and CLI.
          </p>
          <div className="stats">
            <div className="stat">
              <strong>{sources.total}</strong>
              <span>Indexed sources</span>
            </div>
            <div className="stat">
              <strong>{feeds.total}</strong>
              <span>Recent feeds</span>
            </div>
            <div className="stat">
              <strong>Open</strong>
              <span>Anonymous web registration</span>
            </div>
          </div>
        </div>
        <SourceRegisterForm />
      </section>

      <section className="section">
        <div className="page-head">
          <div>
            <h2>Fresh Sources</h2>
            <p className="muted">Newly indexed sources that passed validation and are available for search.</p>
          </div>
          <Link href="/explore" className="button secondary">
            Explore all
          </Link>
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
            <h2>Recent Feed Activity</h2>
            <p className="muted">Publicly available feed metadata collected from active sources.</p>
          </div>
        </div>
        <FeedList feeds={feeds.items} />
      </section>
    </SiteShell>
  );
}

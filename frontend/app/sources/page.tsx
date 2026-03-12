import { SiteShell } from "@/components/site-shell";
import { SourceCard } from "@/components/source-card";
import { SourceRegisterDialog } from "@/components/source-register-dialog";
import { listSources } from "@/lib/api";

export default async function SourcesPage() {
  const sources = await listSources({ limit: "20" }).catch(() => ({ items: [], page: 1, limit: 20, total: 0 }));

  return (
    <SiteShell>
      <section className="section">
        <div className="page-head">
          <div>
            <h1 className="page-title">Sources</h1>
            <p className="muted">Stored RSS sources that passed public indexing rules.</p>
          </div>
          <SourceRegisterDialog />
        </div>
        <div className="list-stack">
          {sources.items.map((source) => (
            <SourceCard key={source.id} source={source} />
          ))}
          {sources.items.length === 0 ? (
            <div className="hero-card empty-state">
              <p className="muted">No sources have been indexed yet.</p>
            </div>
          ) : null}
        </div>
      </section>
    </SiteShell>
  );
}

import { SiteShell } from "@/components/site-shell";
import { SourceCard } from "@/components/source-card";
import { SourceRegisterDialog } from "@/components/source-register-dialog";
import { listSources } from "@/lib/api";

export default async function SourcesPage() {
  const sources = await listSources({ limit: "20" }).catch(() => ({ items: [], page: 1, limit: 20, total: 0 }));

  return (
    <SiteShell>
      <section>
        <div className="page-head">
          <div>
            <h1 className="text-4xl font-semibold tracking-tight md:text-5xl">Sources</h1>
            <p className="mt-3 text-lg text-default-500">Stored RSS sources that passed public indexing rules.</p>
          </div>
          <SourceRegisterDialog />
        </div>
        <div className="list-stack">
          {sources.items.map((source) => (
            <SourceCard key={source.id} source={source} />
          ))}
          {sources.items.length === 0 ? (
            <div className="rounded-large border border-default-200 bg-content1 p-6 text-default-500 shadow-sm">
              No sources have been indexed yet.
            </div>
          ) : null}
        </div>
      </section>
    </SiteShell>
  );
}

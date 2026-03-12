import { HomeHero } from "@/components/home-hero";
import { SiteShell } from "@/components/site-shell";
import { listFeeds, listSources } from "@/lib/api";

export default async function HomePage() {
  const [sources, feeds] = await Promise.all([
    listSources({ limit: "1" }).catch(() => ({ items: [], page: 1, limit: 1, total: 0 })),
    listFeeds({ limit: "1", since: "7d" }).catch(() => ({ items: [], page: 1, limit: 1, total: 0 })),
  ]);

  return (
    <SiteShell>
      <HomeHero sourceCount={sources.total} feedCount={feeds.total} />
    </SiteShell>
  );
}

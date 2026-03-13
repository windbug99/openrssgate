import { Globe, Rss } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
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
    <Card className="border-border/80 bg-card/70 shadow-none">
      <CardContent className="p-0">
        <article className="grid grid-cols-[minmax(0,1fr)_170px_96px] gap-4 px-4 py-3 md:px-5">
          <div className="space-y-3">
            <div className="flex flex-wrap items-center gap-3">
              <h3 className="text-base font-semibold tracking-tight md:text-lg">{source.title}</h3>
              {source.language ? <Badge>{source.language}</Badge> : null}
              {source.category ? <Badge variant="outline">{source.category}</Badge> : null}
              {source.tags.map((tag) => (
                <Badge key={tag} variant="secondary">
                  {tag}
                </Badge>
              ))}
            </div>
            <p className="line-clamp-2 text-sm leading-6 text-muted-foreground">
              {source.description ?? "No description was provided by the feed."}
            </p>
          </div>

          <div className="grid content-center gap-1 text-[11px] leading-5 text-muted-foreground md:text-xs">
            <span className="whitespace-nowrap">Last fetched: {formatDate(source.last_fetched_at)}</span>
            <span className="whitespace-nowrap">Last published: {formatDate(source.last_published_at)}</span>
          </div>

          <div className="flex items-center justify-end gap-2">
            <Button asChild size="sm" variant="outline">
              <a href={source.site_url} target="_blank" rel="noreferrer" aria-label={`${source.title} source URL`}>
                <Globe className="h-4 w-4" />
              </a>
            </Button>
            <Button asChild size="sm" variant="outline">
              <a href={source.rss_url} target="_blank" rel="noreferrer" aria-label={`${source.title} RSS URL`}>
                <Rss className="h-4 w-4" />
              </a>
            </Button>
          </div>
        </article>
      </CardContent>
    </Card>
  );
}

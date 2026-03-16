import { cn } from "@/lib/utils";
import { Globe, Rss } from "lucide-react";
import type { MouseEvent } from "react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import type { Source } from "@/lib/api";
import { LANGUAGE_LABELS, SOURCE_CATEGORY_LABELS, SOURCE_TAG_LABELS, SOURCE_TYPE_LABELS } from "@/lib/source-metadata";

function formatDate(value: string | null): string {
  if (!value) return "Not collected yet";
  const date = new Date(value);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");

  return `${year}.${month}.${day} ${hours}:${minutes}`;
}

export function SourceCard({
  source,
  className,
  onSelect,
}: {
  source: Source;
  className?: string;
  onSelect?: () => void;
}) {
  function handleActionClick(event: MouseEvent) {
    event.stopPropagation();
  }

  const sourceBadgeClassName = "text-[11px]";

  return (
    <article
      className={cn(
        "grid grid-cols-[minmax(0,1fr)_96px] gap-0 px-4 py-3 md:grid-cols-[minmax(0,1fr)_124px] md:px-5",
        onSelect ? "cursor-pointer transition-colors hover:bg-muted/20" : "",
        className,
      )}
      onClick={onSelect}
    >
      <div className="space-y-2 pr-4 md:pr-5">
        <div className="flex items-start justify-between gap-5">
          <div className="min-w-0 flex-1">
            <div className="flex min-w-0 flex-wrap items-center gap-3">
              <div className="flex h-7 w-7 shrink-0 items-center justify-center overflow-hidden rounded-full border border-border/70 bg-muted/40">
                {source.favicon_url ? (
                  <img
                    src={source.favicon_url}
                    alt=""
                    className="h-full w-full rounded-full object-cover"
                    loading="lazy"
                    referrerPolicy="no-referrer"
                  />
                ) : (
                  <span className="text-[11px] font-semibold uppercase text-muted-foreground">
                    {source.title.slice(0, 1)}
                  </span>
                )}
              </div>

              <h3 className="truncate text-base font-semibold tracking-tight md:text-lg">{source.title}</h3>
              {source.language ? <Badge className={sourceBadgeClassName}>{LANGUAGE_LABELS[source.language] ?? source.language}</Badge> : null}
              {source.type ? <Badge variant="outline" className={sourceBadgeClassName}>{SOURCE_TYPE_LABELS[source.type] ?? source.type}</Badge> : null}
              {source.categories.map((category) => (
                <Badge key={category} variant="outline" className={sourceBadgeClassName}>
                  {SOURCE_CATEGORY_LABELS[category] ?? category}
                </Badge>
              ))}
              {source.tags.map((tag) => (
                <Badge key={tag} variant="secondary" className={sourceBadgeClassName}>
                  {SOURCE_TAG_LABELS[tag] ?? tag}
                </Badge>
              ))}
            </div>
          </div>

          <div className="shrink-0 pt-1 text-right text-[12px] leading-5 text-muted-foreground md:text-[13px]">
            <span className="whitespace-nowrap">{formatDate(source.last_published_at)}</span>
          </div>
        </div>

        <p className="truncate text-sm leading-7 text-muted-foreground">
          {source.description ?? "No description was provided by the feed."}
        </p>
      </div>

      <div className="flex items-center justify-end gap-2 self-center border-l border-border/80 pl-4 md:pl-5">
        <Button asChild variant="outline" className="h-11 w-11 rounded-none px-0">
          <a href={source.site_url} target="_blank" rel="noreferrer" aria-label={`${source.title} source URL`} onClick={handleActionClick}>
            <Globe className="h-4 w-4" />
          </a>
        </Button>
        <Button asChild variant="outline" className="h-11 w-11 rounded-none px-0">
          <a href={source.rss_url} target="_blank" rel="noreferrer" aria-label={`${source.title} RSS URL`} onClick={handleActionClick}>
            <Rss className="h-4 w-4" />
          </a>
        </Button>
      </div>
    </article>
  );
}

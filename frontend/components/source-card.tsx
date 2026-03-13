import type { Source } from "@/lib/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

function formatDate(value: string | null): string {
  if (!value) return "Not collected yet";
  return new Intl.DateTimeFormat("ko-KR", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

export function SourceCard({ source }: { source: Source }) {
  return (
    <Card className="h-full">
      <CardHeader className="gap-4 md:flex-row md:items-start md:justify-between">
        <div>
          <CardTitle className="text-xl">{source.title}</CardTitle>
          <p className="mt-2 text-sm leading-6 text-muted-foreground">
            {source.description ?? "No description was provided by the feed."}
          </p>
        </div>
        <Button asChild variant="outline" size="sm">
          <a href={source.site_url} target="_blank" rel="noreferrer">
            Visit
          </a>
        </Button>
      </CardHeader>
      <CardContent className="space-y-4">
      <div className="flex flex-wrap gap-2">
        {source.language ? <Badge>{source.language}</Badge> : null}
        {source.category ? <Badge>{source.category}</Badge> : null}
        {source.tags.map((tag) => (
          <Badge key={tag} variant="outline">{tag}</Badge>
        ))}
      </div>
      <div className="grid gap-1 text-xs text-muted-foreground">
        <span>RSS: {source.rss_url}</span>
        <span>Last fetched: {formatDate(source.last_fetched_at)}</span>
        <span>Last published: {formatDate(source.last_published_at)}</span>
      </div>
      </CardContent>
    </Card>
  );
}

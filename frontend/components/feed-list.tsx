import type { Feed } from "@/lib/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

function formatDate(value: string | null): string {
  if (!value) return "Unknown publish time";
  return new Intl.DateTimeFormat("ko-KR", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

export function FeedList({ feeds }: { feeds: Feed[] }) {
  return (
    <div className="grid gap-4">
      {feeds.map((feed) => (
        <Card key={feed.id}>
          <CardHeader className="pb-3">
            <CardTitle className="text-lg">{feed.title}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2 text-sm text-muted-foreground">
            <p>{formatDate(feed.published_at)}</p>
            <p>
            <a href={feed.feed_url} target="_blank" rel="noreferrer">
              {feed.feed_url}
            </a>
            </p>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}

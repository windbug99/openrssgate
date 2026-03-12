"use client";

import { Card } from "@heroui/react";

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
        <Card key={feed.id}>
          <Card.Content className="gap-3 p-6">
            <h3 className="text-xl font-semibold tracking-tight">{feed.title}</h3>
            <div className="feed-meta text-sm text-default-500">
              <p>{formatDate(feed.published_at)}</p>
              <p>
                <a href={feed.feed_url} target="_blank" rel="noreferrer">
                  {feed.feed_url}
                </a>
              </p>
            </div>
          </Card.Content>
        </Card>
      ))}
    </div>
  );
}

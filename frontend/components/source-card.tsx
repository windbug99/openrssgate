"use client";

import { Button, Card, Chip } from "@heroui/react";

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
    <Card>
      <Card.Content className="gap-5 p-6">
        <header className="source-card-header">
          <div>
            <h3 className="text-2xl font-semibold tracking-tight">{source.title}</h3>
            <p className="mt-2 text-base text-default-500">
              {source.description ?? "No description was provided by the feed."}
            </p>
          </div>
          <a href={source.site_url} target="_blank" rel="noreferrer">
            <Button variant="secondary">Visit</Button>
          </a>
        </header>
        <div className="chip-row">
          {source.language ? <Chip variant="soft">{source.language}</Chip> : null}
          {source.category ? <Chip variant="soft">{source.category}</Chip> : null}
          {source.tags.map((tag) => (
            <Chip key={tag} variant="soft">
              {tag}
            </Chip>
          ))}
        </div>
        <div className="source-meta text-sm text-default-500">
          <span>RSS: {source.rss_url}</span>
          <span>Last fetched: {formatDate(source.last_fetched_at)}</span>
          <span>Last published: {formatDate(source.last_published_at)}</span>
        </div>
      </Card.Content>
    </Card>
  );
}

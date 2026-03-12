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
      <Card.Content className="gap-4 p-5 md:p-6">
        <header className="source-card-header">
          <div>
            <h3 className="text-xl font-semibold tracking-tight md:text-2xl">{source.title}</h3>
            <p className="mt-1.5 max-w-4xl text-sm leading-6 text-default-500 md:text-base">
              {source.description ?? "No description was provided by the feed."}
            </p>
          </div>
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
        <div className="source-meta text-xs leading-5 text-default-400 md:text-sm">
          <span>Last fetched: {formatDate(source.last_fetched_at)}</span>
          <span>Last published: {formatDate(source.last_published_at)}</span>
        </div>
        <div className="flex flex-wrap gap-3">
          <a href={source.site_url} target="_blank" rel="noreferrer">
            <Button size="sm" variant="secondary">
              Visit
            </Button>
          </a>
          <a href={source.rss_url} target="_blank" rel="noreferrer">
            <Button size="sm" variant="outline">
              RSS URL
            </Button>
          </a>
        </div>
      </Card.Content>
    </Card>
  );
}

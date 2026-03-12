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
    <Card className="source-card hero-card">
      <Card.Content>
        <header>
          <div>
            <h3>{source.title}</h3>
            <p className="muted">{source.description ?? "No description was provided by the feed."}</p>
          </div>
          <a href={source.site_url} target="_blank" rel="noreferrer">
            <Button variant="outline">Visit</Button>
          </a>
        </header>
        <div className="pill-row">
          {source.language ? <Chip className="heroui-chip">{source.language}</Chip> : null}
          {source.category ? <Chip className="heroui-chip">{source.category}</Chip> : null}
          {source.tags.map((tag) => (
            <Chip className="heroui-chip" key={tag}>
              {tag}
            </Chip>
          ))}
        </div>
        <div className="source-meta">
          <span>RSS: {source.rss_url}</span>
          <span>Last fetched: {formatDate(source.last_fetched_at)}</span>
          <span>Last published: {formatDate(source.last_published_at)}</span>
        </div>
      </Card.Content>
    </Card>
  );
}

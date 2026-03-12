"use client";

import Link from "next/link";
import { Button, Card } from "@heroui/react";

export function HomeHero({ sourceCount, feedCount }: { sourceCount: number; feedCount: number }) {
  return (
    <section className="hero">
      <Card className="hero-card hero-copy">
        <span className="eyebrow">Open RSS source index</span>
        <h1>Register once. Query everywhere.</h1>
        <p>
          OpenRSSGate centralizes public RSS and Atom feeds into a searchable index. People use the web interface.
          Agents and scripts use the same dataset through REST, MCP, and CLI.
        </p>
        <div className="stats">
          <div className="stat">
            <strong>{sourceCount}</strong>
            <span>Indexed sources</span>
          </div>
          <div className="stat">
            <strong>{feedCount}</strong>
            <span>Recent feeds</span>
          </div>
          <div className="stat">
            <strong>Public</strong>
            <span>Web registration and discovery</span>
          </div>
        </div>
        <div className="hero-actions">
          <Link href="/sources">
            <Button variant="primary">Browse Sources</Button>
          </Link>
          <Link href="/feeds">
            <Button variant="outline">Browse Feeds</Button>
          </Link>
        </div>
      </Card>
    </section>
  );
}

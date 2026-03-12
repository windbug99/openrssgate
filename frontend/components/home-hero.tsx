"use client";

import Link from "next/link";
import { Button, Card } from "@heroui/react";

export function HomeHero({ sourceCount, feedCount }: { sourceCount: number; feedCount: number }) {
  return (
    <section className="hero">
      <Card>
        <Card.Content className="gap-6 p-8 md:p-12">
          <div className="max-w-3xl space-y-4">
            <div className="text-small font-medium uppercase tracking-wide text-default-500">Open RSS source index</div>
            <div className="space-y-3">
              <h1 className="text-4xl font-semibold tracking-tight text-foreground md:text-6xl">
                Register once. Query everywhere.
              </h1>
              <p className="max-w-2xl text-large leading-8 text-default-500">
                OpenRSSGate centralizes public RSS and Atom feeds into a searchable index. People use the web
                interface. Agents and scripts use the same dataset through REST, MCP, and CLI.
              </p>
            </div>
          </div>
          <div className="grid gap-4 md:grid-cols-3">
            <Card>
              <Card.Content className="gap-1 p-5">
                <div className="text-3xl font-semibold">{sourceCount}</div>
                <div className="text-small text-default-500">Indexed sources</div>
              </Card.Content>
            </Card>
            <Card>
              <Card.Content className="gap-1 p-5">
                <div className="text-3xl font-semibold">{feedCount}</div>
                <div className="text-small text-default-500">Recent feeds</div>
              </Card.Content>
            </Card>
            <Card>
              <Card.Content className="gap-1 p-5">
                <div className="text-3xl font-semibold">Public</div>
                <div className="text-small text-default-500">Web registration and discovery</div>
              </Card.Content>
            </Card>
          </div>
          <div className="flex flex-wrap gap-3">
            <Link href="/sources">
              <Button variant="primary">Browse Sources</Button>
            </Link>
            <Link href="/feeds">
              <Button variant="secondary">Browse Feeds</Button>
            </Link>
          </div>
        </Card.Content>
      </Card>
    </section>
  );
}

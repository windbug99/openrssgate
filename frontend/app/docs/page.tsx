"use client";

import { Card, Chip } from "@heroui/react";

import { SiteShell } from "@/components/site-shell";

const endpoints = [
  ["GET", "/v1/sources", "List active sources"],
  ["POST", "/v1/sources", "Register a source from the web frontend"],
  ["GET", "/v1/sources/{source_id}", "Get one source"],
  ["GET", "/v1/sources/{source_id}/feeds", "List feeds for a source"],
  ["GET", "/v1/feeds", "List recent feeds"],
];

const tools = ["search_sources", "get_source", "get_recent_feeds", "get_source_feeds"];

export default function DocsPage() {
  return (
    <SiteShell>
      <section className="docs-grid">
        <Card>
          <Card.Content className="gap-3 p-8">
            <h1 className="text-4xl font-semibold tracking-tight md:text-5xl">Docs</h1>
            <p className="text-lg text-default-500">
              Connection details for REST API, remote MCP access, and the public CLI workflow.
            </p>
          </Card.Content>
        </Card>

        <Card>
          <Card.Content className="gap-5 p-8">
            <h2 className="text-2xl font-semibold tracking-tight">REST API</h2>
            <div className="list-stack">
            {endpoints.map(([method, path, description]) => (
                <Card key={path}>
                  <Card.Content className="gap-1 p-4">
                  <strong>
                    {method} {path}
                  </strong>
                    <p className="text-default-500">{description}</p>
                  </Card.Content>
                </Card>
            ))}
            </div>
          </Card.Content>
        </Card>

        <Card>
          <Card.Content className="gap-5 p-8">
            <h2 className="text-2xl font-semibold tracking-tight">MCP</h2>
            <p className="text-default-500">Remote MCP endpoint for deployed environments.</p>
            <Card>
              <Card.Content className="p-4 font-mono text-sm">
                https://openrssgate-production.up.railway.app/mcp/sse
              </Card.Content>
            </Card>
            <div className="chip-row">
            {tools.map((tool) => (
                <Chip key={tool} variant="soft">
                {tool}
                </Chip>
            ))}
            </div>
          </Card.Content>
        </Card>

        <Card>
          <Card.Content className="gap-5 p-8">
            <h2 className="text-2xl font-semibold tracking-tight">CLI</h2>
            <p className="text-default-500">Set the API base URL, then use the read-only `openrssgate` CLI.</p>
            <Card>
              <Card.Content className="gap-3 p-4 font-mono text-sm">
                <code>export RSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1</code>
                <code>openrssgate list</code>
                <code>openrssgate feeds --since 7d</code>
              </Card.Content>
            </Card>
          </Card.Content>
        </Card>
      </section>
    </SiteShell>
  );
}

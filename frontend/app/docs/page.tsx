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
      <section className="section">
        <Card className="hero-card panel">
          <h1 className="page-title">Docs</h1>
          <p className="muted">
            Connection details for REST API, remote MCP access, and the public CLI workflow.
          </p>
        </Card>
      </section>

      <section className="section">
        <Card className="hero-card panel">
          <h2>REST API</h2>
          <div className="list-stack">
            {endpoints.map(([method, path, description]) => (
              <div className="list-row" key={path}>
                <div className="list-row-main">
                  <strong>
                    {method} {path}
                  </strong>
                  <p className="muted">{description}</p>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </section>

      <section className="section">
        <Card className="hero-card panel">
          <h2>MCP</h2>
          <p className="muted">Remote MCP endpoint for deployed environments.</p>
          <div className="docs-block">
            <code>https://openrssgate-production.up.railway.app/mcp/sse</code>
          </div>
          <div className="pill-row">
            {tools.map((tool) => (
              <Chip className="heroui-chip" key={tool}>
                {tool}
              </Chip>
            ))}
          </div>
        </Card>
      </section>

      <section className="section">
        <Card className="hero-card panel">
          <h2>CLI</h2>
          <p className="muted">
            Set the API base URL, then use the read-only `openrssgate` CLI.
          </p>
          <div className="docs-block">
            <code>export RSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1</code>
          </div>
          <div className="docs-block">
            <code>openrssgate list</code>
          </div>
          <div className="docs-block">
            <code>openrssgate feeds --since 7d</code>
          </div>
        </Card>
      </section>
    </SiteShell>
  );
}

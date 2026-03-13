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
      <section className="card panel">
        <h2>Gateway Interfaces</h2>
        <p className="muted">
          The MVP exposes the same public source index through REST, a read-only MCP tool manifest, and a planned CLI
          surface.
        </p>
      </section>

      <section className="section">
        <div className="card panel">
          <h2>REST API</h2>
          <div className="feed-list">
            {endpoints.map(([method, path, description]) => (
              <div className="feed-item card" key={path}>
                <h3>
                  {method} {path}
                </h3>
                <p>{description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="section">
        <div className="card panel">
          <h2>MCP Tools</h2>
          <div className="pill-row">
            {tools.map((tool) => (
              <span className="pill" key={tool}>
                {tool}
              </span>
            ))}
          </div>
          <p className="muted" style={{ marginTop: 16 }}>
            Current backend exposes `/mcp/tools` as a manifest endpoint. SSE transport wiring can be layered on top of
            the same source and feed APIs.
          </p>
        </div>
      </section>
    </SiteShell>
  );
}

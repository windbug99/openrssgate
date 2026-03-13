import { SiteShell } from "@/components/site-shell";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

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
      <section className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>Gateway Interfaces</CardTitle>
            <CardDescription>
              The MVP exposes the same public source index through REST, a read-only MCP tool manifest, and a planned
              CLI surface.
            </CardDescription>
          </CardHeader>
        </Card>
      </section>

      <section className="mt-8">
        <Card>
          <CardHeader>
            <CardTitle>REST API</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4">
            {endpoints.map(([method, path, description]) => (
                <Card key={path}>
                  <CardContent className="space-y-2 p-5">
                    <h3 className="text-base font-semibold">
                  {method} {path}
                    </h3>
                    <p className="text-sm text-muted-foreground">{description}</p>
                  </CardContent>
                </Card>
            ))}
            </div>
          </CardContent>
        </Card>
      </section>

      <section className="mt-8">
        <Card>
          <CardHeader>
            <CardTitle>MCP Tools</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex flex-wrap gap-2">
            {tools.map((tool) => (
                <Badge key={tool}>{tool}</Badge>
            ))}
            </div>
            <p className="text-sm text-muted-foreground">
              Current backend exposes `/mcp/tools` as a manifest endpoint. SSE transport wiring can be layered on top
              of the same source and feed APIs.
            </p>
          </CardContent>
        </Card>
      </section>
    </SiteShell>
  );
}

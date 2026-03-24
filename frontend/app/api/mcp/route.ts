import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db";
import { sources, feeds } from "@/lib/db/schema";
import { eq, and, ilike, sql, desc, count, gte, inArray } from "drizzle-orm";
import Parser from "rss-parser";

const parser = new Parser();

const TOOLS = [
  {
    name: "search_sources",
    description: "Search sources by keyword, language, type, category, or tag.",
    inputSchema: {
      type: "object",
      properties: {
        keyword: { type: "string" },
        language: { type: "string" },
        type: { type: "string" },
        category: { type: "string" },
        tag: { type: "string" },
        page: { type: "integer", default: 1 },
        limit: { type: "integer", default: 20 },
      },
    },
  },
  {
    name: "get_source",
    description: "Get a single source by id.",
    inputSchema: {
      type: "object",
      properties: {
        source_id: { type: "string" },
      },
      required: ["source_id"],
    },
  },
  {
    name: "get_stats",
    description: "Get public source and feed statistics.",
    inputSchema: { type: "object", properties: {} },
  },
  {
    name: "list_feeds",
    description: "List feeds across active sources.",
    inputSchema: {
      type: "object",
      properties: {
        source_id: { type: "string" },
        q: { type: "string" },
        since: { type: "string", description: "e.g. 1h, 24h, 7d" },
        page: { type: "integer", default: 1 },
        limit: { type: "integer", default: 20 },
      },
    },
  },
  {
    name: "create_source",
    description: "Register a new RSS source.",
    inputSchema: {
      type: "object",
      properties: {
        rss_url: { type: "string" },
        language: { type: "string" },
        type: { type: "string" },
        categories: { type: "array", items: { type: "string" } },
        tags: { type: "array", items: { type: "string" } },
      },
      required: ["rss_url"],
    },
  },
];

function transformSource(source: any) {
  return {
    ...source,
    categories: source.categories ? source.categories.split(",").map((c: string) => c.trim()) : [],
    tags: source.tags ? source.tags.split(",").map((t: string) => t.trim()) : [],
  };
}

export async function GET() {
  return NextResponse.json({
    protocolVersion: "2024-11-05",
    capabilities: { tools: {} },
    serverInfo: { name: "rss-gateway-vercel", version: "0.1.0" },
    tools: TOOLS,
  });
}


export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name, arguments: args } = body;

    switch (name) {
      case "search_sources": {
        const page = args.page || 1;
        const limit = Math.min(args.limit || 20, 100);
        const offset = (page - 1) * limit;
        let conditions = [eq(sources.status, "active")];
        if (args.keyword) conditions.push(ilike(sources.title, `%${args.keyword}%`));
        if (args.language) conditions.push(eq(sources.language, args.language));
        if (args.type) conditions.push(eq(sources.type, args.type));
        if (args.category) conditions.push(sql`${sources.categories} ILIKE ${`%${args.category}%`}`);
        if (args.tag) conditions.push(sql`${sources.tags} ILIKE ${`%${args.tag}%`}`);

        const finalWhere = and(...conditions);
        const [totalResult] = await db.select({ count: count() }).from(sources).where(finalWhere);
        const items = await db.select().from(sources).where(finalWhere).orderBy(desc(sources.last_published_at), desc(sources.registered_at)).limit(limit).offset(offset);

        return NextResponse.json({
          content: [{ type: "text", text: JSON.stringify({ items: items.map(transformSource), total: totalResult.count, page, limit }) }],
        });
      }

      case "get_source": {
        const [source] = await db.select().from(sources).where(eq(sources.id, args.source_id));
        if (!source) return NextResponse.json({ content: [{ type: "text", text: "Source not found" }], isError: true });
        return NextResponse.json({ content: [{ type: "text", text: JSON.stringify(transformSource(source)) }] });
      }

      case "get_stats": {
        const [total] = await db.select({ count: count() }).from(sources);
        const [active] = await db.select({ count: count() }).from(sources).where(eq(sources.status, "active"));
        return NextResponse.json({ content: [{ type: "text", text: JSON.stringify({ total_sources: total.count, active_sources: active.count }) }] });
      }

      case "create_source": {
        // Simple create logic (reuse existing POST logic conceptually)
        const rss_url = args.rss_url;
        const [existing] = await db.select().from(sources).where(eq(sources.rss_url, rss_url));
        if (existing) return NextResponse.json({ content: [{ type: "text", text: "Already registered" }], isError: true });

        const feed = await parser.parseURL(rss_url);
        const [newSource] = await db.insert(sources).values({
          rss_url,
          title: feed.title || "Untitled",
          site_url: feed.link || "",
          description: feed.description || null,
          language: args.language,
          type: args.type,
          categories: args.categories?.join(","),
          tags: args.tags?.join(","),
          status: "active",
        }).returning();

        return NextResponse.json({ content: [{ type: "text", text: JSON.stringify(transformSource(newSource)) }] });
      }

      default:
        return NextResponse.json({ error: "Unknown tool" }, { status: 404 });
    }
  } catch (error) {
    return NextResponse.json({ content: [{ type: "text", text: String(error) }], isError: true }, { status: 500 });
  }
}

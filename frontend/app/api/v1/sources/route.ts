import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db";
import { sources, feeds } from "@/lib/db/schema";
import { eq, and, ilike, sql, desc, count } from "drizzle-orm";
import Parser from "rss-parser";

const parser = new Parser();

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const keyword = searchParams.get("keyword");
  const language = searchParams.get("language");
  const type = searchParams.get("type");
  const category = searchParams.get("category");
  const tag = searchParams.get("tag");
  const page = parseInt(searchParams.get("page") || "1");
  const limit = Math.min(parseInt(searchParams.get("limit") || "20"), 500);

  const offset = (page - 1) * limit;

  let where = eq(sources.status, "active");
  const conditions = [where];

  if (keyword) {
    conditions.push(ilike(sources.title, `%${keyword}%`));
  }
  if (language) {
    conditions.push(eq(sources.language, language));
  }
  if (type) {
    conditions.push(eq(sources.type, type));
  }

  if (category) {
    conditions.push(sql`${sources.categories} ILIKE ${`%${category}%`}`);
  }
  if (tag) {
    conditions.push(sql`${sources.tags} ILIKE ${`%${tag}%`}`);
  }

  const finalWhere = and(...conditions);

  const [totalResult] = await db
    .select({ count: count() })
    .from(sources)
    .where(finalWhere);

  const items = await db
    .select()
    .from(sources)
    .where(finalWhere)
    .orderBy(desc(sources.last_published_at), desc(sources.registered_at))
    .limit(limit)
    .offset(offset);

  const transformedItems = items.map((source) => ({
    ...source,
    categories: source.categories ? source.categories.split(",").map(c => c.trim()) : [],
    tags: source.tags ? source.tags.split(",").map(t => t.trim()) : [],
  }));

  return NextResponse.json({
    items: transformedItems,
    page,
    limit,
    total: totalResult.count,
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { rss_url, language, type, categories, tags } = body;

    if (!rss_url) {
      return NextResponse.json({ error: { code: "invalid_rss_url", message: "rss_url is required" } }, { status: 400 });
    }

    // Check for duplicate
    const [existing] = await db.select().from(sources).where(eq(sources.rss_url, rss_url));
    if (existing) {
      return NextResponse.json({ error: { code: "duplicate_source", message: "This RSS URL is already registered." } }, { status: 409 });
    }

    // Fetch RSS metadata
    let feed;
    try {
      feed = await parser.parseURL(rss_url);
    } catch (err) {
      return NextResponse.json({ error: { code: "invalid_rss_url", message: "Could not fetch or parse RSS feed." } }, { status: 400 });
    }

    const title = feed.title || "Untitled";
    const site_url = feed.link || "";
    const description = feed.description || null;

    // Create source
    const [newSource] = await db.insert(sources).values({
      rss_url,
      site_url,
      title,
      description,
      language,
      type,
      categories: Array.isArray(categories) ? categories.join(",") : null,
      tags: Array.isArray(tags) ? tags.join(",") : null,
      status: "active",
      registered_by: "web",
    }).returning();

    // Initial ingestion (optional but helpful for immediate CLI result)
    if (feed.items && feed.items.length > 0) {
      const feedItems = feed.items.slice(0, 20).map(item => ({
        source_id: newSource.id,
        guid: item.guid || item.id || item.link || crypto.randomUUID(),
        title: item.title || "Untitled",
        feed_url: item.link || "",
        author: item.creator || item.author || null,
        summary: item.contentSnippet || null,
        content: item.content || null,
        published_at: item.pubDate ? new Date(item.pubDate) : null,
      }));

      // Ingest incrementally (ignore duplicates in case of conflict, though unlikely here)
      for (const item of feedItems) {
        await db.insert(feeds).values(item).onConflictDoNothing();
      }
      
      const latestPublishedAt = feedItems.reduce((latest, item) => {
        if (!item.published_at) return latest;
        if (!latest) return item.published_at;
        return item.published_at > latest ? item.published_at : latest;
      }, null as Date | null);

      if (latestPublishedAt) {
        await db.update(sources).set({ last_published_at: latestPublishedAt }).where(eq(sources.id, newSource.id));
      }
    }

    return NextResponse.json({
      ...newSource,
      categories: newSource.categories ? newSource.categories.split(",") : [],
      tags: newSource.tags ? newSource.tags.split(",") : [],
    }, { status: 201 });

  } catch (error) {
    console.error("Failed to create source:", error);
    return NextResponse.json({ error: { code: "internal_error", message: String(error) } }, { status: 500 });
  }
}

import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db";
import { feeds, sources } from "@/lib/db/schema";
import { eq, and, ilike, sql, desc, count, gte, inArray } from "drizzle-orm";

function parseSince(since: string | null): Date | null {
  if (!since) return null;
  const unit = since.slice(-1);
  const amount = parseInt(since.slice(0, -1));
  if (isNaN(amount)) return null;

  const now = new Date();
  if (unit === "h") {
    return new Date(now.getTime() - amount * 60 * 60 * 1000);
  } else if (unit === "d") {
    return new Date(now.getTime() - amount * 24 * 60 * 60 * 1000);
  }
  return null;
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const sourceId = searchParams.get("source_id");
  const sourceIdsStr = searchParams.get("source_ids");
  const language = searchParams.get("language");
  const type = searchParams.get("type");
  const category = searchParams.get("category");
  const tag = searchParams.get("tag");
  const q = searchParams.get("q");
  const since = searchParams.get("since");
  const content = searchParams.get("content") !== "false";
  const page = parseInt(searchParams.get("page") || "1");
  const limit = Math.min(parseInt(searchParams.get("limit") || "20"), 500);

  const offset = (page - 1) * limit;
  const sinceDate = parseSince(since);

  let conditions = [eq(sources.status, "active")];

  if (sourceId) {
    conditions.push(eq(feeds.source_id, sourceId));
  }
  if (sourceIdsStr) {
    const ids = sourceIdsStr.split(",").map(id => id.trim()).filter(id => id);
    if (ids.length > 0) {
      conditions.push(inArray(feeds.source_id, ids));
    }
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
  if (q) {
    conditions.push(ilike(feeds.title, `%${q}%`));
  }
  if (sinceDate) {
    conditions.push(gte(feeds.published_at, sinceDate));
  }

  const finalWhere = and(...conditions);

  const [totalResult] = await db
    .select({ count: count() })
    .from(feeds)
    .innerJoin(sources, eq(feeds.source_id, sources.id))
    .where(finalWhere);

  const entries = await db
    .select({
      id: feeds.id,
      source_id: feeds.source_id,
      guid: feeds.guid,
      title: feeds.title,
      feed_url: feeds.feed_url,
      author: feeds.author,
      summary: feeds.summary,
      content: content ? feeds.content : sql`NULL`,
      published_at: feeds.published_at,
    })
    .from(feeds)
    .innerJoin(sources, eq(feeds.source_id, sources.id))
    .where(finalWhere)
    .orderBy(desc(feeds.published_at))
    .limit(limit)
    .offset(offset);

  return NextResponse.json({
    items: entries,
    page,
    limit,
    total: totalResult.count,
  });
}

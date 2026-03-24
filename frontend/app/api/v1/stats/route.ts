import { NextResponse } from "next/server";
import { db } from "@/lib/db";
import { sources } from "@/lib/db/schema";
import { eq, count } from "drizzle-orm";

export async function GET() {
  try {
    const [totalResult] = await db
      .select({ count: count() })
      .from(sources);

    const [activeResult] = await db
      .select({ count: count() })
      .from(sources)
      .where(eq(sources.status, "active"));

    // We don't have ongoing feed collection, so feeds_last_24h might be irrelevant.
    // But we'll return what's in the DB for compatibility.
    return NextResponse.json({
      total_sources: totalResult.count,
      active_sources: activeResult.count,
      total_feeds: 0, // Placeholder as we are not collecting regularly
      feeds_last_24h: 0,
    });
  } catch (error) {
    console.error("Failed to fetch stats:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

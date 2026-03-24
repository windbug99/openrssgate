import { NextRequest, NextResponse } from "next/server";
import Parser from "rss-parser";

const parser = new Parser();

export async function POST(request: NextRequest) {
  try {
    const { rss_url } = await request.json();
    if (!rss_url) return NextResponse.json({ error: "rss_url required" }, { status: 400 });

    const feed = await parser.parseURL(rss_url);
    return NextResponse.json({
      valid: true,
      rss_url,
      title: feed.title || "",
      site_url: feed.link || "",
      description: feed.description || "",
      feed_format: "rss", // simplified
    });
  } catch (error) {
    return NextResponse.json({ valid: false, message: String(error) }, { status: 400 });
  }
}

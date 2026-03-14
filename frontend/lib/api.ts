import type { LanguageCode, SourceCategory, SourceTag, SourceType } from "@/lib/source-metadata";

export type Source = {
  id: string;
  rss_url: string;
  site_url: string;
  title: string;
  description: string | null;
  favicon_url: string | null;
  language: LanguageCode | null;
  type: SourceType | null;
  categories: SourceCategory[];
  tags: SourceTag[];
  status: string;
  registered_by: string;
  registered_at: string;
  last_fetched_at: string | null;
  last_published_at: string | null;
};

export type Feed = {
  id: string;
  source_id: string;
  guid: string;
  title: string;
  feed_url: string;
  published_at: string | null;
};

export type FeedDetail = Feed & {
  source: {
    id: string;
    title: string;
    site_url: string;
    rss_url: string;
    language: LanguageCode | null;
    type: SourceType | null;
    categories: SourceCategory[];
    tags: SourceTag[];
  };
};

export type Stats = {
  total_sources: number;
  active_sources: number;
  total_feeds: number;
  feeds_last_24h: number;
};

export type SourceValidation = {
  valid: boolean;
  rss_url: string;
  site_url: string;
  title: string;
  description: string | null;
  favicon_url: string | null;
  language: LanguageCode | null;
  type: SourceType | null;
  categories: SourceCategory[];
  tags: SourceTag[];
  feed_format: string | null;
};

type SourceListResponse = {
  items: Source[];
  page: number;
  limit: number;
  total: number;
};

type FeedListResponse = {
  items: Feed[];
  page: number;
  limit: number;
  total: number;
};

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://127.0.0.1:8000/v1";

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
    cache: "no-store",
  });

  if (!response.ok) {
    const payload = (await response.json().catch(() => null)) as
      | { error?: { code?: string; message?: string }; detail?: { code?: string; message?: string } | string }
      | null;
    const detailMessage =
      typeof payload?.detail === "string"
        ? payload.detail
        : payload?.detail && typeof payload.detail === "object"
          ? payload.detail.message
          : undefined;
    throw new Error(payload?.error?.message ?? detailMessage ?? `Request failed with ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export async function listSources(params?: Record<string, string | undefined>): Promise<SourceListResponse> {
  const search = new URLSearchParams();
  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (value) search.set(key, value);
  });
  const query = search.toString();
  return request<SourceListResponse>(`/sources${query ? `?${query}` : ""}`);
}

export async function listFeeds(params?: Record<string, string | undefined>): Promise<FeedListResponse> {
  const search = new URLSearchParams();
  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (value) search.set(key, value);
  });
  const query = search.toString();
  return request<FeedListResponse>(`/feeds${query ? `?${query}` : ""}`);
}

export async function getFeed(feedId: string): Promise<FeedDetail> {
  return request<FeedDetail>(`/feeds/${feedId}`);
}

export async function getStats(): Promise<Stats> {
  return request<Stats>("/stats");
}

export async function validateSource(payload: {
  rss_url: string;
  language?: LanguageCode;
  type?: SourceType;
  categories?: SourceCategory[];
  tags?: SourceTag[];
}): Promise<SourceValidation> {
  return request<SourceValidation>("/sources/validate", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

export async function createSource(payload: {
  rss_url: string;
  language?: LanguageCode;
  type?: SourceType;
  categories?: SourceCategory[];
  tags?: SourceTag[];
}): Promise<Source> {
  return request<Source>("/sources", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

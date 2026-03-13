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
      | { error?: { code?: string; message?: string } }
      | null;
    throw new Error(payload?.error?.message ?? `Request failed with ${response.status}`);
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

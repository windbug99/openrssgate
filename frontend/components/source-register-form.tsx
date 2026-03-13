"use client";

import { useState } from "react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createSource, type Source } from "@/lib/api";

const initialState = {
  rss_url: "",
  language: "",
  category: "",
  tags: "",
};

function getStatusMessage(source: Source): string {
  if (source.status === "active") {
    return `${source.title} has been registered and is now available through the public index.`;
  }
  if (source.status === "hidden") {
    return `${source.title} has been registered, but it is hidden pending operations review.`;
  }
  if (source.status === "rejected") {
    return `${source.title} was received, but it was not approved for public listing.`;
  }
  return `${source.title} has been registered and is awaiting review.`;
}

export function SourceRegisterForm() {
  const [form, setForm] = useState(initialState);
  const [saving, setSaving] = useState(false);
  const [createdSource, setCreatedSource] = useState<Source | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setSaving(true);
    setError(null);

    try {
      const source = await createSource({
        rss_url: form.rss_url,
        language: form.language || undefined,
        category: form.category || undefined,
        tags: form.tags
          .split(",")
          .map((tag) => tag.trim())
          .filter(Boolean),
      });
      setCreatedSource(source);
      setForm(initialState);
    } catch (submitError) {
      setCreatedSource(null);
      setError(submitError instanceof Error ? submitError.message : "Source registration failed.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="space-y-5">
      <div className="space-y-2">
        <p className="text-[0.95rem] leading-7 text-muted-foreground">
          RSS URL only. The server validates the feed, fetches metadata, and stores the first batch of feed entries.
        </p>
      </div>
      <form className="space-y-4" onSubmit={handleSubmit}>
        <div className="grid gap-3 md:grid-cols-2">
          <Input
            className="h-12 rounded-none border-border/80 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0 md:col-span-2"
            placeholder="https://blog.example.com/rss.xml"
            value={form.rss_url}
            onChange={(event) => setForm((current) => ({ ...current, rss_url: event.target.value }))}
            required
          />
          <Input
            className="h-12 rounded-none border-border/80 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
            placeholder="language: ko"
            value={form.language}
            onChange={(event) => setForm((current) => ({ ...current, language: event.target.value }))}
          />
          <Input
            className="h-12 rounded-none border-border/80 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
            placeholder="category: blog"
            value={form.category}
            onChange={(event) => setForm((current) => ({ ...current, category: event.target.value }))}
          />
          <Input
            className="h-12 rounded-none border-border/80 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0 md:col-span-2"
            placeholder="tags: AI, tech, semiconductor"
            value={form.tags}
            onChange={(event) => setForm((current) => ({ ...current, tags: event.target.value }))}
          />
        </div>
        <div className="flex flex-wrap gap-3">
          <Button type="submit" disabled={saving} className="h-12 rounded-none px-6">
            {saving ? "Registering..." : "Register Source"}
          </Button>
        </div>
      </form>
      {createdSource ? (
        <div className="border border-border/80 bg-muted/10 px-4 py-3 text-sm text-foreground">
          <strong>{createdSource.status.toUpperCase()}</strong> {getStatusMessage(createdSource)}
        </div>
      ) : null}
      {error ? <div className="border border-border/80 bg-muted/10 px-4 py-3 text-sm text-destructive">{error}</div> : null}
    </div>
  );
}

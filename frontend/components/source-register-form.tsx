"use client";

import { useState } from "react";
import { Button, Card, Input } from "@heroui/react";

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
    <Card className="hero-card panel">
      <Card.Header className="flex flex-col items-start gap-3 px-7 pt-7 pb-2">
        <div>
          <h2>Anonymous Source Registration</h2>
          <p className="muted">
            RSS URL only. The server validates the feed, fetches metadata, and stores the first batch of feed entries.
          </p>
        </div>
      </Card.Header>
      <Card.Content className="px-7 pb-7">
        <form onSubmit={handleSubmit}>
          <div className="heroui-form-grid">
            <Input
              className="heroui-field-wide"
              aria-label="RSS URL"
              placeholder="https://blog.example.com/rss.xml"
              value={form.rss_url}
              onChange={(event) => setForm((current) => ({ ...current, rss_url: event.target.value }))}
              required
            />
            <Input
              aria-label="Language"
              placeholder="ko"
              value={form.language}
              onChange={(event) => setForm((current) => ({ ...current, language: event.target.value }))}
            />
            <Input
              aria-label="Category"
              placeholder="blog"
              value={form.category}
              onChange={(event) => setForm((current) => ({ ...current, category: event.target.value }))}
            />
            <Input
              className="heroui-field-wide"
              aria-label="Tags"
              placeholder="AI, tech, semiconductor"
              value={form.tags}
              onChange={(event) => setForm((current) => ({ ...current, tags: event.target.value }))}
            />
          </div>
          <div className="mt-4 flex flex-wrap gap-3">
            <Button variant="primary" type="submit" isDisabled={saving}>
              {saving ? "Registering..." : "Register Source"}
            </Button>
          </div>
        </form>
      </Card.Content>
      {createdSource ? (
        <div className="status ok">
          <strong>{createdSource.status.toUpperCase()}</strong> {getStatusMessage(createdSource)}
        </div>
      ) : null}
      {error ? <div className="status error">{error}</div> : null}
    </Card>
  );
}

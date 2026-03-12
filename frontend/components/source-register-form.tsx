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

function SourceRegisterFormInner() {
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
    <>
      <div className="space-y-2">
        <h2 className="text-2xl font-semibold tracking-tight">Anonymous Source Registration</h2>
        <p className="text-default-500">
          RSS URL only. The server validates the feed, fetches metadata, and stores the first batch of feed entries.
        </p>
      </div>
      <form onSubmit={handleSubmit}>
        <div className="form-grid">
          <Input
            className="form-grid-full"
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
            className="form-grid-full"
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
      {createdSource ? (
        <div className="rounded-large bg-success-50 px-4 py-3 text-sm text-success-700">
          <strong>{createdSource.status.toUpperCase()}</strong> {getStatusMessage(createdSource)}
        </div>
      ) : null}
      {error ? <div className="rounded-large bg-danger-50 px-4 py-3 text-sm text-danger-700">{error}</div> : null}
    </>
  );
}

export function SourceRegisterForm({ embedded = false }: { embedded?: boolean }) {
  if (embedded) {
    return <SourceRegisterFormInner />;
  }

  return (
    <Card>
      <Card.Content className="gap-5 p-8">
        <SourceRegisterFormInner />
      </Card.Content>
    </Card>
  );
}

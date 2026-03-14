"use client";

import { Filter } from "lucide-react";
import { useState } from "react";

import { FilterDropdown } from "@/components/filter-dropdown";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createSource, validateSource, type Source, type SourceValidation } from "@/lib/api";
import {
  LANGUAGE_LABELS,
  LANGUAGE_OPTIONS,
  SOURCE_CATEGORY_LABELS,
  SOURCE_CATEGORY_OPTIONS,
  SOURCE_LIMITS,
  SOURCE_TAG_LABELS,
  SOURCE_TAG_OPTIONS,
  SOURCE_TYPE_LABELS,
  SOURCE_TYPE_OPTIONS,
  type LanguageCode,
  type SourceCategory,
  type SourceTag,
  type SourceType,
} from "@/lib/source-metadata";

const initialState = {
  rss_url: "",
  language: "" as LanguageCode | "",
  type: "" as SourceType | "",
  categories: [] as SourceCategory[],
  tags: [] as SourceTag[],
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

function toggleLimitedSelection<T extends string>(current: T[], value: T, maxCount: number): T[] {
  if (current.includes(value)) {
    return current.filter((item) => item !== value);
  }
  if (current.length >= maxCount) {
    return current;
  }
  return [...current, value];
}

function mergeLimitedSelection<T extends string>(current: T[], detected: T[], maxCount: number): T[] {
  if (current.length > 0) {
    return current;
  }
  return detected.slice(0, maxCount);
}

function getAutoAppliedFields(source: SourceValidation): string[] {
  const applied: string[] = [];

  if (source.language) {
    applied.push("language");
  }
  if (source.type) {
    applied.push("type");
  }
  if (source.categories.length > 0) {
    applied.push("categories");
  }
  if (source.tags.length > 0) {
    applied.push("tags");
  }

  return applied;
}

function getValidationMessage(source: SourceValidation): string {
  const parts = ["Validated"];

  if (source.title) {
    parts.push(source.title);
  }
  if (source.feed_format) {
    parts.push(source.feed_format);
  }

  return parts.join(" · ");
}

export function SourceRegisterForm({ onSuccess }: { onSuccess?: (source: Source) => void }) {
  const [form, setForm] = useState(initialState);
  const [saving, setSaving] = useState(false);
  const [validating, setValidating] = useState(false);
  const [createdSource, setCreatedSource] = useState<Source | null>(null);
  const [validatedSource, setValidatedSource] = useState<SourceValidation | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [validationError, setValidationError] = useState<string | null>(null);

  async function handleValidate() {
    if (!form.rss_url.trim()) {
      setValidationError("Enter an RSS URL before validation.");
      setValidatedSource(null);
      return;
    }

    setValidating(true);
    setValidationError(null);
    setError(null);

    try {
      const result = await validateSource({
        rss_url: form.rss_url,
        language: form.language || undefined,
        type: form.type || undefined,
        categories: form.categories,
        tags: form.tags,
      });
      setValidatedSource(result);
      setForm((current) => ({
        ...current,
        rss_url: result.rss_url || current.rss_url,
        language: current.language || result.language || "",
        type: current.type || result.type || "",
        categories: mergeLimitedSelection(current.categories, result.categories, SOURCE_LIMITS.maxCategories),
        tags: mergeLimitedSelection(current.tags, result.tags, SOURCE_LIMITS.maxTags),
      }));
    } catch (submitError) {
      setValidatedSource(null);
      setValidationError(submitError instanceof Error ? submitError.message : "Source validation failed.");
    } finally {
      setValidating(false);
    }
  }

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setSaving(true);
    setError(null);

    try {
      const source = await createSource({
        rss_url: form.rss_url,
        language: form.language || undefined,
        type: form.type || undefined,
        categories: form.categories,
        tags: form.tags,
      });
      setCreatedSource(source);
      setValidatedSource(null);
      setValidationError(null);
      setForm(initialState);
      onSuccess?.(source);
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
          Register the RSS URL and classify the source with controlled options for language, type, categories, and tags.
        </p>
      </div>
      {createdSource ? (
        <div className="border border-border/80 bg-muted/10 px-4 py-3 text-sm text-foreground">
          <strong>{createdSource.status.toUpperCase()}</strong> {getStatusMessage(createdSource)}
        </div>
      ) : null}
      {error ? <div className="border border-border/80 bg-muted/10 px-4 py-3 text-sm text-destructive">{error}</div> : null}
      <form className="space-y-4" onSubmit={handleSubmit}>
        <div className="grid gap-3 md:grid-cols-2">
          <div className="grid gap-3 md:col-span-2 md:grid-cols-[minmax(0,1fr)_180px]">
            <div className="space-y-2">
              <Input
                className="h-12 rounded-none border-border/80 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
                placeholder="https://blog.example.com/rss.xml"
                value={form.rss_url}
                onChange={(event) => {
                  const nextValue = event.target.value;
                  setForm((current) => ({ ...current, rss_url: nextValue }));
                  setValidatedSource((current) => (current?.rss_url === nextValue ? current : null));
                }}
                required
              />
              {validatedSource ? (
                <div className="space-y-1 text-xs leading-5">
                  <div className="text-emerald-500">{getValidationMessage(validatedSource)}</div>
                  <div className="text-muted-foreground">
                    {(() => {
                      const fields = getAutoAppliedFields(validatedSource);
                      if (fields.length === 0) {
                        return "No language, type, category, or tag was detected automatically.";
                      }
                      return `Auto-applied to empty fields: ${fields.join(", ")}.`;
                    })()}
                  </div>
                </div>
              ) : null}
              {validationError ? <div className="text-xs leading-5 text-destructive">{validationError}</div> : null}
            </div>
            <Button type="button" variant="outline" disabled={validating || saving} className="h-12 rounded-none px-6" onClick={handleValidate}>
              {validating ? "Validating..." : "Validate first"}
            </Button>
          </div>
          <label className="space-y-2">
            <span className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Language</span>
            <FilterDropdown
              value={form.language}
              onChange={(value) => setForm((current) => ({ ...current, language: value as LanguageCode | "" }))}
              options={[{ value: "", label: "Select language" }, ...LANGUAGE_OPTIONS]}
              placeholder="Select language"
              icon={<Filter className="h-4 w-4 text-muted-foreground" />}
              className="relative"
              buttonClassName="flex h-12 w-full items-center justify-between border border-border/80 bg-transparent px-4 text-left text-sm text-foreground"
            />
          </label>
          <label className="space-y-2">
            <span className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Type</span>
            <FilterDropdown
              value={form.type}
              onChange={(value) => setForm((current) => ({ ...current, type: value as SourceType | "" }))}
              options={[{ value: "", label: "Select type" }, ...SOURCE_TYPE_OPTIONS]}
              placeholder="Select type"
              icon={<Filter className="h-4 w-4 text-muted-foreground" />}
              className="relative"
              buttonClassName="flex h-12 w-full items-center justify-between border border-border/80 bg-transparent px-4 text-left text-sm text-foreground"
            />
          </label>
          <div className="space-y-2 md:col-span-2">
            <div className="flex items-center justify-between gap-3">
              <span className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Categories</span>
              <span className="text-xs text-muted-foreground">
                Up to {SOURCE_LIMITS.maxCategories}
              </span>
            </div>
            <div className="flex flex-wrap gap-2">
              {SOURCE_CATEGORY_OPTIONS.map((option) => {
                const selected = form.categories.includes(option.value);
                const disabled = !selected && form.categories.length >= SOURCE_LIMITS.maxCategories;
                return (
                  <button
                    key={option.value}
                    type="button"
                    className="h-10 rounded-none border border-border/80 px-3 text-sm transition-colors disabled:cursor-not-allowed disabled:opacity-40 data-[selected=true]:bg-foreground data-[selected=true]:text-background"
                    data-selected={selected}
                    disabled={disabled}
                    onClick={() =>
                      setForm((current) => ({
                        ...current,
                        categories: toggleLimitedSelection(
                          current.categories,
                          option.value,
                          SOURCE_LIMITS.maxCategories,
                        ),
                      }))
                    }
                  >
                    {option.label}
                  </button>
                );
              })}
            </div>
          </div>
          <div className="space-y-2 md:col-span-2">
            <div className="flex items-center justify-between gap-3">
              <span className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Tags</span>
              <span className="text-xs text-muted-foreground">Up to {SOURCE_LIMITS.maxTags}</span>
            </div>
            <div className="flex flex-wrap gap-2">
              {SOURCE_TAG_OPTIONS.map((option) => {
                const selected = form.tags.includes(option.value);
                const disabled = !selected && form.tags.length >= SOURCE_LIMITS.maxTags;
                return (
                  <button
                    key={option.value}
                    type="button"
                    className="h-10 rounded-none border border-border/80 px-3 text-sm transition-colors disabled:cursor-not-allowed disabled:opacity-40 data-[selected=true]:bg-foreground data-[selected=true]:text-background"
                    data-selected={selected}
                    disabled={disabled}
                    onClick={() =>
                      setForm((current) => ({
                        ...current,
                        tags: toggleLimitedSelection(current.tags, option.value, SOURCE_LIMITS.maxTags),
                      }))
                    }
                  >
                    {option.label}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
        <div className="flex flex-wrap gap-3">
          <Button type="submit" disabled={saving} className="h-12 rounded-none px-6">
            {saving ? "Registering..." : "Register Source"}
          </Button>
        </div>
      </form>
    </div>
  );
}

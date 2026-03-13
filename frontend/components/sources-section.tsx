"use client";

import { ArrowUpDown, Database, Filter, Search } from "lucide-react";
import { useMemo, useState } from "react";

import { SourceCard } from "@/components/source-card";
import { Input } from "@/components/ui/input";
import type { Source } from "@/lib/api";

type SortKey = "registered_desc" | "fetched_desc" | "title_asc";

export function SourcesSection({ id, sources }: { id?: string; sources: Source[] }) {
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState("all");
  const [sortKey, setSortKey] = useState<SortKey>("fetched_desc");

  const languages = useMemo(() => {
    return Array.from(new Set(sources.map((source) => source.language).filter(Boolean))) as string[];
  }, [sources]);

  const filteredSources = useMemo(() => {
    const lowered = query.trim().toLowerCase();
    const filtered = sources.filter((source) => {
      const matchesQuery =
        lowered.length === 0 ||
        source.title.toLowerCase().includes(lowered) ||
        (source.description ?? "").toLowerCase().includes(lowered) ||
        source.tags.some((tag) => tag.toLowerCase().includes(lowered));

      const matchesLanguage = language === "all" || source.language === language;

      return matchesQuery && matchesLanguage;
    });

    const ranked = [...filtered];
    ranked.sort((left, right) => {
      if (sortKey === "title_asc") return left.title.localeCompare(right.title);
      if (sortKey === "registered_desc") {
        return new Date(right.registered_at).getTime() - new Date(left.registered_at).getTime();
      }
      return new Date(right.last_fetched_at ?? 0).getTime() - new Date(left.last_fetched_at ?? 0).getTime();
    });

    return ranked;
  }, [language, query, sortKey, sources]);

  return (
    <section id={id} className="scroll-mt-24 space-y-6">
      <div className="border-t border-border/70 pt-8">
        <div className="mb-5 flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-muted-foreground">
          <Database className="h-4 w-4" />
          <span>Sources</span>
        </div>
        <div className="space-y-2">
          <h2 className="text-[1.5rem] font-bold tracking-[-0.04em] text-foreground">
            Indexed sources
          </h2>
          <p className="w-full text-[16px] leading-[1.9] text-muted-foreground">
            Search the public source index, filter the current catalog, and jump directly to the source site or its
            RSS URL from the same list view.
          </p>
        </div>
      </div>

      <div className="grid gap-3 rounded-xl border border-border/70 bg-card/50 p-4 md:grid-cols-[minmax(0,1.6fr)_220px_220px]">
        <label className="relative block">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            className="pl-9"
            placeholder="Search title, description, tag"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
          />
        </label>

        <label className="relative block">
          <Filter className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <select
            className="flex h-10 w-full appearance-none rounded-md border border-input bg-background px-9 py-2 text-sm text-foreground outline-none focus:ring-2 focus:ring-ring"
            value={language}
            onChange={(event) => setLanguage(event.target.value)}
          >
            <option value="all">All languages</option>
            {languages.map((item) => (
              <option key={item} value={item}>
                {item}
              </option>
            ))}
          </select>
        </label>

        <label className="relative block">
          <ArrowUpDown className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <select
            className="flex h-10 w-full appearance-none rounded-md border border-input bg-background px-9 py-2 text-sm text-foreground outline-none focus:ring-2 focus:ring-ring"
            value={sortKey}
            onChange={(event) => setSortKey(event.target.value as SortKey)}
          >
            <option value="fetched_desc">Recently fetched</option>
            <option value="registered_desc">Recently registered</option>
            <option value="title_asc">Title A-Z</option>
          </select>
        </label>
      </div>

      <div className="grid gap-3">
        {filteredSources.map((source) => (
          <SourceCard key={source.id} source={source} />
        ))}
        {filteredSources.length === 0 ? (
          <div className="rounded-xl border border-dashed border-border bg-card/40 px-5 py-10 text-center text-sm text-muted-foreground">
            No sources matched the current search and filter combination.
          </div>
        ) : null}
      </div>
    </section>
  );
}

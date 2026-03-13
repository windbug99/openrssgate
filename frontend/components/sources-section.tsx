"use client";

import { ArrowUpDown, Check, ChevronDown, Database, Filter, Search } from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";

import { SourceCard } from "@/components/source-card";
import { SourceRegisterDialog } from "@/components/source-register-dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import type { Source } from "@/lib/api";

type SortKey = "registered_desc" | "published_desc" | "title_asc";

function FilterDropdown<T extends string>({
  value,
  onChange,
  options,
  icon,
  placeholder,
  className,
}: {
  value: T;
  onChange: (value: T) => void;
  options: Array<{ value: T; label: string }>;
  icon: React.ReactNode;
  placeholder: string;
  className?: string;
}) {
  const [open, setOpen] = useState(false);
  const rootRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handlePointerDown(event: MouseEvent) {
      if (!rootRef.current?.contains(event.target as Node)) {
        setOpen(false);
      }
    }

    function handleEscape(event: KeyboardEvent) {
      if (event.key === "Escape") {
        setOpen(false);
      }
    }

    document.addEventListener("mousedown", handlePointerDown);
    document.addEventListener("keydown", handleEscape);

    return () => {
      document.removeEventListener("mousedown", handlePointerDown);
      document.removeEventListener("keydown", handleEscape);
    };
  }, []);

  const selected = options.find((option) => option.value === value);

  return (
    <div ref={rootRef} className={className}>
      <button
        type="button"
        className="flex h-12 w-full items-center justify-between bg-transparent px-3 text-left text-sm text-foreground"
        onClick={() => setOpen((current) => !current)}
      >
        <span className="flex min-w-0 items-center gap-3">
          {icon}
          <span className="truncate">{selected?.label ?? placeholder}</span>
        </span>
        <ChevronDown className="h-4 w-4 text-muted-foreground" />
      </button>

      {open ? (
        <div className="absolute left-0 top-full z-20 mt-px w-full border border-border bg-background shadow-none">
          {options.map((option) => (
            <button
              key={option.value}
              type="button"
              className="flex h-11 w-full items-center justify-between border-b border-border px-3 text-left text-sm text-foreground last:border-b-0 hover:bg-muted/40"
              onClick={() => {
                onChange(option.value);
                setOpen(false);
              }}
            >
              <span>{option.label}</span>
              {option.value === value ? <Check className="h-4 w-4" /> : null}
            </button>
          ))}
        </div>
      ) : null}
    </div>
  );
}

export function SourcesSection({ id, sources }: { id?: string; sources: Source[] }) {
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState("all");
  const [sortKey, setSortKey] = useState<SortKey>("published_desc");

  const languages = useMemo(() => {
    return Array.from(new Set(sources.map((source) => source.language).filter(Boolean))) as string[];
  }, [sources]);

  const languageOptions = useMemo(
    () => [
      { value: "all", label: "All languages" },
      ...languages.map((item) => ({ value: item, label: item })),
    ],
    [languages],
  );

  const sortOptions: Array<{ value: SortKey; label: string }> = [
    { value: "published_desc", label: "Recently published" },
    { value: "registered_desc", label: "Recently registered" },
    { value: "title_asc", label: "Title A-Z" },
  ];

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
      return new Date(right.last_published_at ?? 0).getTime() - new Date(left.last_published_at ?? 0).getTime();
    });

    return ranked;
  }, [language, query, sortKey, sources]);

  return (
    <section id={id} className="-mx-6 scroll-mt-24 space-y-6 md:-mx-10">
      <div className="border-t border-border/70 px-6 pt-8 md:px-10">
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

      <div className="px-6 md:px-10">
        <div className="grid gap-0 border border-border/80 bg-card/30 md:grid-cols-[minmax(0,1.5fr)_220px_220px_auto]">
          <label className="relative block border-b border-border/80 focus-within:outline focus-within:outline-1 focus-within:outline-border focus-within:outline-offset-[-1px] md:border-b-0 md:border-r">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <Input
              className="h-12 rounded-none border-0 bg-transparent pl-9 shadow-none focus-visible:ring-0"
              placeholder="Search title, description, tag"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
            />
          </label>

          <FilterDropdown
            value={language}
            onChange={setLanguage}
            options={languageOptions}
            placeholder="All languages"
            icon={<Filter className="h-4 w-4 text-muted-foreground" />}
            className="relative border-b border-border/80 md:border-b-0 md:border-r"
          />

          <FilterDropdown
            value={sortKey}
            onChange={setSortKey}
            options={sortOptions}
            placeholder="Sort"
            icon={<ArrowUpDown className="h-4 w-4 text-muted-foreground" />}
            className="relative border-b border-border/80 md:border-b-0 md:border-r"
          />

          <div className="flex">
            <SourceRegisterDialog
              trigger={
                <Button
                  type="button"
                  className="h-12 w-full rounded-none border-0 bg-foreground px-5 text-background hover:bg-foreground/95"
                >
                  Add source
                </Button>
              }
            />
          </div>
        </div>
      </div>

      <div className="px-6 md:px-10">
        {filteredSources.length === 0 ? (
          <div className="border border-dashed border-border bg-card/40 px-5 py-10 text-center text-sm text-muted-foreground">
            No sources matched the current search and filter combination.
          </div>
        ) : (
          <div className="overflow-hidden border border-border/80 bg-card/20">
            {filteredSources.map((source, index) => (
              <SourceCard
                key={source.id}
                source={source}
                className={index > 0 ? "border-t border-border/70" : undefined}
              />
            ))}
          </div>
        )}
      </div>
    </section>
  );
}

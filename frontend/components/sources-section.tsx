"use client";

import { ArrowUpDown, Database, Filter, Search, Signal } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useRef, useState } from "react";

import { FilterDropdown } from "@/components/filter-dropdown";
import { SourceCard } from "@/components/source-card";
import { SourceRegisterDialog } from "@/components/source-register-dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { listSources, type Source, type Stats } from "@/lib/api";
import {
  LANGUAGE_OPTIONS,
  SOURCE_CATEGORY_OPTIONS,
  SOURCE_TYPE_OPTIONS,
  type LanguageCode,
  type SourceCategory,
  type SourceType,
} from "@/lib/source-metadata";

type SortKey = "registered_desc" | "published_desc" | "title_asc";

function formatNumber(value: number): string {
  return new Intl.NumberFormat("en-US").format(value);
}

export function SourcesSection({
  id,
  sources,
  stats,
  initialPage,
  pageSize,
  totalSources,
}: {
  id?: string;
  sources: Source[];
  stats: Stats;
  initialPage: number;
  pageSize: number;
  totalSources: number;
}) {
  const [sourceItems, setSourceItems] = useState(sources);
  const [localStats, setLocalStats] = useState(stats);
  const [currentPage, setCurrentPage] = useState(initialPage);
  const [totalCount, setTotalCount] = useState(totalSources);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState<LanguageCode | "all">("all");
  const [type, setType] = useState<SourceType | "all">("all");
  const [category, setCategory] = useState<SourceCategory | "all">("all");
  const [sortKey, setSortKey] = useState<SortKey>("published_desc");
  const [isRefreshing, setIsRefreshing] = useState(false);
  const deferredQuery = useDeferredValue(query);
  const didMountRef = useRef(false);

  useEffect(() => {
    setSourceItems(sources);
    setCurrentPage(initialPage);
    setTotalCount(totalSources);
  }, [initialPage, sources, totalSources]);

  useEffect(() => {
    setLocalStats(stats);
  }, [stats]);

  const languageOptions = useMemo(
    () => [{ value: "all", label: "All languages" }, ...LANGUAGE_OPTIONS.map((item) => ({ value: item.value, label: item.label }))],
    [],
  );

  const typeOptions = useMemo(
    () => [{ value: "all", label: "All types" }, ...SOURCE_TYPE_OPTIONS.map((item) => ({ value: item.value, label: item.label }))],
    [],
  );

  const categoryOptions = useMemo(
    () => [
      { value: "all", label: "All categories" },
      ...SOURCE_CATEGORY_OPTIONS.map((item) => ({ value: item.value, label: item.label })),
    ],
    [],
  );

  const sortOptions: Array<{ value: SortKey; label: string }> = [
    { value: "published_desc", label: "Recently published" },
    { value: "registered_desc", label: "Recently registered" },
    { value: "title_asc", label: "Title A-Z" },
  ];

  const filteredSources = useMemo(() => {
    const ranked = [...sourceItems];
    ranked.sort((left, right) => {
      if (sortKey === "title_asc") return left.title.localeCompare(right.title);
      if (sortKey === "registered_desc") {
        return new Date(right.registered_at).getTime() - new Date(left.registered_at).getTime();
      }
      return new Date(right.last_published_at ?? 0).getTime() - new Date(left.last_published_at ?? 0).getTime();
    });

    return ranked;
  }, [sortKey, sourceItems]);

  const activeFilters = useMemo(
    () => ({
      keyword: deferredQuery.trim() || undefined,
      language: language === "all" ? undefined : language,
      type: type === "all" ? undefined : type,
      category: category === "all" ? undefined : category,
    }),
    [category, deferredQuery, language, type],
  );

  useEffect(() => {
    if (!didMountRef.current) {
      didMountRef.current = true;
      return;
    }

    const controller = new AbortController();

    async function refreshSources(): Promise<void> {
      setIsRefreshing(true);
      try {
        const response = await listSources(
          {
            ...activeFilters,
            page: "1",
            limit: String(pageSize),
          },
          { signal: controller.signal },
        );
        setSourceItems(response.items);
        setCurrentPage(response.page);
        setTotalCount(response.total);
      } catch (error) {
        if (!(error instanceof Error) || error.name !== "AbortError") {
          setSourceItems([]);
          setCurrentPage(1);
          setTotalCount(0);
        }
      } finally {
        if (!controller.signal.aborted) {
          setIsRefreshing(false);
        }
      }
    }

    void refreshSources();

    return () => {
      controller.abort();
    };
  }, [activeFilters, pageSize]);

  const hasMore = sourceItems.length < totalCount;

  async function handleLoadMore(): Promise<void> {
    if (isLoadingMore || !hasMore) return;

    setIsLoadingMore(true);
    try {
      const nextPage = currentPage + 1;
      const response = await listSources({
        ...activeFilters,
        page: String(nextPage),
        limit: String(pageSize),
      });
      setSourceItems((current) => {
        const seen = new Set(current.map((item) => item.id));
        const appended = response.items.filter((item) => !seen.has(item.id));
        return [...current, ...appended];
      });
      setCurrentPage(response.page);
      setTotalCount(response.total);
    } finally {
      setIsLoadingMore(false);
    }
  }

  return (
    <section id={id} className="-mx-6 scroll-mt-24 space-y-6 md:-mx-10">
      <div className="border-t border-border/70 px-6 pt-8 md:px-10">
        <div className="mb-5 flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-[#E85D4A]">
          <Database className="h-4 w-4 text-[#E85D4A]" />
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
        <div className="mt-5 grid gap-3 sm:grid-cols-3">
          <div className="border border-border/80 bg-card/20 px-4 py-4">
            <div className="flex items-center gap-2 text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">
              <Signal className="h-4 w-4" />
              Active sources
            </div>
            <div className="mt-2 text-2xl font-semibold tracking-[-0.04em] text-foreground">{formatNumber(localStats.active_sources)}</div>
          </div>
          <div className="border border-border/80 bg-card/20 px-4 py-4">
            <div className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Indexed feeds</div>
            <div className="mt-2 text-2xl font-semibold tracking-[-0.04em] text-foreground">{formatNumber(localStats.total_feeds)}</div>
          </div>
          <div className="border border-border/80 bg-card/20 px-4 py-4">
            <div className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">Feeds last 24h</div>
            <div className="mt-2 text-2xl font-semibold tracking-[-0.04em] text-foreground">{formatNumber(localStats.feeds_last_24h)}</div>
          </div>
        </div>
      </div>

      <div className="px-6 md:px-10">
        <div className="border border-border/80 bg-card/30">
          <div className="grid gap-0 md:grid-cols-[minmax(0,1fr)_260px]">
            <label className="relative block border-b border-border/80 focus-within:outline focus-within:outline-1 focus-within:outline-border focus-within:outline-offset-[-1px] md:border-b-0 md:border-r">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input
                className="h-12 rounded-none border-0 bg-transparent pl-9 shadow-none focus-visible:ring-0"
                placeholder="Search title, description, tag"
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
            </label>

            <div className="flex">
              <SourceRegisterDialog
                onSuccess={(source) => {
                  const matchesKeyword =
                    !activeFilters.keyword ||
                    source.title.toLowerCase().includes(activeFilters.keyword.toLowerCase()) ||
                    (source.description ?? "").toLowerCase().includes(activeFilters.keyword.toLowerCase()) ||
                    source.tags.some((tag) => tag.toLowerCase().includes(activeFilters.keyword!.toLowerCase()));
                  const matchesLanguage = !activeFilters.language || source.language === activeFilters.language;
                  const matchesType = !activeFilters.type || source.type === activeFilters.type;
                  const matchesCategory = !activeFilters.category || source.categories.includes(activeFilters.category);

                  setSourceItems((current) => {
                    if (!matchesKeyword || !matchesLanguage || !matchesType || !matchesCategory) {
                      return current;
                    }
                    if (current.some((item) => item.id === source.id)) {
                      return current;
                    }
                    return [source, ...current];
                  });
                  setLocalStats((current) => ({
                    ...current,
                    active_sources: current.active_sources + (source.status === "active" ? 1 : 0),
                  }));
                  setTotalCount((current) => current + (source.status === "active" ? 1 : 0));
                  setQuery("");
                  setLanguage("all");
                  setType("all");
                  setCategory("all");
                  setSortKey("registered_desc");
                }}
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

          <div className="grid gap-0 border-t border-border/80 md:grid-cols-4">
            <FilterDropdown
              value={language}
              onChange={(value) => setLanguage(value as LanguageCode | "all")}
              options={languageOptions}
              placeholder="All languages"
              icon={<Filter className="h-4 w-4 text-muted-foreground" />}
              className="relative border-b border-border/80 md:border-b-0 md:border-r"
            />

            <FilterDropdown
              value={type}
              onChange={(value) => setType(value as SourceType | "all")}
              options={typeOptions}
              placeholder="All types"
              icon={<Filter className="h-4 w-4 text-muted-foreground" />}
              className="relative border-b border-border/80 md:border-b-0 md:border-r"
            />

            <FilterDropdown
              value={category}
              onChange={(value) => setCategory(value as SourceCategory | "all")}
              options={categoryOptions}
              placeholder="All categories"
              icon={<Filter className="h-4 w-4 text-muted-foreground" />}
              className="relative border-b border-border/80 md:border-b-0 md:border-r"
            />

            <FilterDropdown
              value={sortKey}
              onChange={setSortKey}
              options={sortOptions}
              placeholder="Sort"
              icon={<ArrowUpDown className="h-4 w-4 text-muted-foreground" />}
              className="relative"
            />
          </div>
        </div>
      </div>

      <div className="px-6 md:px-10">
        {filteredSources.length === 0 ? (
          <div className="border border-dashed border-border bg-card/40 px-5 py-10 text-center text-sm text-muted-foreground">
            {isRefreshing ? "Searching sources..." : "No sources matched the current search and filter combination."}
          </div>
        ) : (
          <div className="space-y-4">
            <div className="overflow-hidden border border-border/80 bg-card/20">
              {filteredSources.map((source, index) => (
                <SourceCard
                  key={source.id}
                  source={source}
                  className={index > 0 ? "border-t border-border/70" : undefined}
                />
              ))}
            </div>
            {hasMore ? (
              <Button
                type="button"
                variant="outline"
                className="h-11 w-full rounded-none"
                onClick={() => void handleLoadMore()}
                disabled={isLoadingMore}
              >
                {isLoadingMore ? "Loading..." : `Load more (${formatNumber(totalCount - sourceItems.length)} left)`}
              </Button>
            ) : null}
          </div>
        )}
      </div>
    </section>
  );
}

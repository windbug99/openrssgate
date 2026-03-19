"use client";

import { ArrowUpDown, Database, Filter, Search } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";

import { AdminShell } from "@/components/admin/admin-shell";
import { AdminLoadingState } from "@/components/admin/admin-loading-state";
import { SourceCard } from "@/components/source-card";
import { SourceRegisterDialog } from "@/components/source-register-dialog";
import { SourceRegisterForm } from "@/components/source-register-form";
import { FilterDropdown } from "@/components/filter-dropdown";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { deleteAdminSource, searchAdminSources, getAdminMe, updateAdminSource, type AdminSource, type AdminUser } from "@/lib/admin-api";
import type { Source } from "@/lib/api";
import {
  LANGUAGE_OPTIONS,
  SOURCE_CATEGORY_OPTIONS,
  SOURCE_TYPE_OPTIONS,
  type LanguageCode,
  type SourceCategory,
  type SourceTag,
  type SourceType,
} from "@/lib/source-metadata";

const PAGE_SIZE = 100;
type SortKey = "registered_desc" | "published_desc" | "title_asc";

function formatNumber(value: number): string {
  return new Intl.NumberFormat("en-US").format(value);
}

function toPublicSource(source: AdminSource): Source {
  return {
    id: source.id,
    rss_url: source.rss_url,
    site_url: source.site_url,
    title: source.title,
    description: source.description,
    favicon_url: source.favicon_url,
    language: source.language,
    type: source.type,
    categories: source.categories,
    tags: source.tags,
    status: source.status,
    registered_by: "admin",
    registered_at: source.registered_at,
    last_fetched_at: source.last_fetched_at,
    last_published_at: source.last_published_at,
  };
}

export function AdminSourcesCatalog() {
  const router = useRouter();
  const [currentUser, setCurrentUser] = useState<AdminUser | null>(null);
  const [items, setItems] = useState<AdminSource[]>([]);
  const [selectedSource, setSelectedSource] = useState<AdminSource | null>(null);
  const [deleteCandidate, setDeleteCandidate] = useState<AdminSource | null>(null);
  const [query, setQuery] = useState("");
  const [language, setLanguage] = useState<LanguageCode | "all">("all");
  const [type, setType] = useState<SourceType | "all">("all");
  const [category, setCategory] = useState<SourceCategory | "all">("all");
  const [sortKey, setSortKey] = useState<SortKey>("published_desc");
  const [error, setError] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  const [page, setPage] = useState(1);
  const [isInitialLoading, setIsInitialLoading] = useState(false);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(false);
  const [totalCount, setTotalCount] = useState(0);
  const [refreshNonce, setRefreshNonce] = useState(0);
  const deferredQuery = useDeferredValue(query);

  const languageOptions = useMemo(
    () => [{ value: "all", label: "All languages" }, ...LANGUAGE_OPTIONS.map((item) => ({ value: item.value, label: item.label }))],
    [],
  );
  const typeOptions = useMemo(
    () => [{ value: "all", label: "All types" }, ...SOURCE_TYPE_OPTIONS.map((item) => ({ value: item.value, label: item.label }))],
    [],
  );
  const categoryOptions = useMemo(
    () => [{ value: "all", label: "All categories" }, ...SOURCE_CATEGORY_OPTIONS.map((item) => ({ value: item.value, label: item.label }))],
    [],
  );
  const sortOptions: Array<{ value: SortKey; label: string }> = [
    { value: "published_desc", label: "Recently published" },
    { value: "registered_desc", label: "Recently registered" },
    { value: "title_asc", label: "Title A-Z" },
  ];

  const sortedItems = useMemo(() => {
    const ranked = [...items];
    ranked.sort((left, right) => {
      if (sortKey === "title_asc") {
        return left.title.localeCompare(right.title);
      }
      if (sortKey === "registered_desc") {
        return new Date(right.registered_at).getTime() - new Date(left.registered_at).getTime();
      }
      return new Date(right.last_published_at ?? 0).getTime() - new Date(left.last_published_at ?? 0).getTime();
    });
    return ranked;
  }, [items, sortKey]);

  useEffect(() => {
    void getAdminMe()
      .then((user) => setCurrentUser(user))
      .catch(() => router.replace("/admin/login"));
  }, [router]);

  useEffect(() => {
    setError(null);
    setPage(1);
    setIsInitialLoading(true);
    setIsLoadingMore(false);
    const controller = new AbortController();

    void searchAdminSources({
      keyword: deferredQuery.trim() || undefined,
      language: language === "all" ? undefined : language,
      type: type === "all" ? undefined : type,
      category: category === "all" ? undefined : category,
      page: "1",
      limit: String(PAGE_SIZE),
    }, { signal: controller.signal })
      .then((payload) => {
        if (!controller.signal.aborted) {
          setItems(payload.items);
          setPage(payload.page);
          setTotalCount(payload.total);
          setHasMore(payload.page * payload.limit < payload.total);
        }
      })
      .catch((loadError) => {
        if (!controller.signal.aborted) {
          setItems([]);
          setPage(1);
          setTotalCount(0);
          setHasMore(false);
          setError(loadError instanceof Error ? loadError.message : "Failed to load sources.");
        }
      })
      .finally(() => {
        if (!controller.signal.aborted) {
          setIsInitialLoading(false);
        }
      });

    return () => {
      controller.abort();
    };
  }, [category, deferredQuery, language, refreshNonce, type]);

  async function handleLoadMore() {
    if (isLoadingMore || !hasMore) {
      return;
    }

    const nextPage = page + 1;
    setIsLoadingMore(true);
    setError(null);

    try {
      const payload = await searchAdminSources({
        keyword: deferredQuery.trim() || undefined,
        language: language === "all" ? undefined : language,
        type: type === "all" ? undefined : type,
        category: category === "all" ? undefined : category,
        page: String(nextPage),
        limit: String(PAGE_SIZE),
      });
      setItems((current) => [...current, ...payload.items]);
      setPage(payload.page);
      setTotalCount(payload.total);
      setHasMore(payload.page * payload.limit < payload.total);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Failed to load more sources.");
    } finally {
      setIsLoadingMore(false);
    }
  }

  async function handleUpdate(sourceId: string, payload: { language?: LanguageCode; type?: SourceType; categories: SourceCategory[]; tags: SourceTag[] }) {
    const updated = await updateAdminSource(sourceId, {
      language: payload.language,
      type: payload.type,
      categories: payload.categories,
      tags: payload.tags,
    });
    setItems((current) => current.map((item) => (item.id === updated.id ? updated : item)));
    setSelectedSource(updated);
  }

  async function handleDelete() {
    if (!deleteCandidate) {
      return;
    }

    setIsDeleting(true);
    setError(null);

    try {
      await deleteAdminSource(deleteCandidate.id);
      setItems((current) => current.filter((item) => item.id !== deleteCandidate.id));
      setSelectedSource(null);
      setDeleteCandidate(null);
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : "Failed to delete source.");
    } finally {
      setIsDeleting(false);
    }
  }

  function handleSourceAdded(source: Source) {
    setItems((current) => {
      if (current.some((item) => item.id === source.id)) {
        return current;
      }

      const nextItem: AdminSource = {
        id: source.id,
        rss_url: source.rss_url,
        site_url: source.site_url,
        title: source.title,
        description: source.description,
        favicon_url: source.favicon_url,
        language: source.language,
        type: source.type,
        categories: source.categories,
        tags: source.tags,
        status: source.status,
        status_reason: null,
        registered_at: source.registered_at,
        last_fetched_at: source.last_fetched_at,
        last_published_at: source.last_published_at,
        consecutive_fail_count: 0,
        ai_reviewed_at: null,
        ai_review_source: null,
        ai_review_reason: null,
        ai_review_confidence: null,
        ai_review_decision: null,
      };

      return [nextItem, ...current];
    });
    setTotalCount((current) => current + 1);
    setQuery("");
    setLanguage("all");
    setType("all");
    setCategory("all");
    setSortKey("registered_desc");
    setRefreshNonce((current) => current + 1);
  }

  return (
    <AdminShell currentUser={currentUser?.email}>
      <div className="space-y-6">
        <div className="space-y-2">
          <div className="flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-muted-foreground">
            <Database className="h-4 w-4" />
            <span>Sources</span>
          </div>
          <h1 className="text-[1.6rem] font-semibold tracking-[-0.04em] text-foreground">Source metadata</h1>
          <p className="max-w-3xl text-sm leading-7 text-muted-foreground">
            Review the indexed source catalog and open any source in the registration dialog layout to update language, type, categories, and tags.
          </p>
        </div>

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
                onSuccess={handleSourceAdded}
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

        {isInitialLoading && sortedItems.length > 0 ? <AdminLoadingState label="Updating sources..." compact /> : null}

        {sortedItems.length === 0 ? (
          isInitialLoading ? (
            <AdminLoadingState label="Searching sources..." />
          ) : (
            <div className="border border-dashed border-border bg-card/40 px-5 py-10 text-center text-sm text-muted-foreground">
              No sources matched the current search and filter combination.
            </div>
          )
        ) : (
          <div className="space-y-4">
            <div className={`overflow-hidden border border-border/80 bg-card/20 transition-opacity ${isInitialLoading ? "opacity-65" : "opacity-100"}`}>
              {sortedItems.map((item, index) => (
                <SourceCard
                  key={item.id}
                  source={toPublicSource(item)}
                  onSelect={() => setSelectedSource(item)}
                  className={index > 0 ? "border-t border-border/70" : undefined}
                />
              ))}
            </div>
          </div>
        )}

        <div>
          {hasMore ? (
            <Button type="button" variant="outline" className="h-11 w-full rounded-none" disabled={isLoadingMore} onClick={() => void handleLoadMore()}>
              {isLoadingMore ? "Loading..." : `Load more (${formatNumber(totalCount - items.length)} left)`}
            </Button>
          ) : null}
        </div>

        {error ? <p className="text-sm text-destructive">{error}</p> : null}
      </div>

      <Dialog open={Boolean(selectedSource)} onOpenChange={(open) => (!open ? setSelectedSource(null) : undefined)}>
        <DialogContent className="max-w-3xl">
          {selectedSource ? (
            <>
              <DialogHeader className="py-5">
                <DialogTitle>Edit source</DialogTitle>
              </DialogHeader>
              <div className="min-h-0 overflow-y-auto px-6 py-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
                <SourceRegisterForm
                  mode="edit"
                  initialValues={{
                    rss_url: selectedSource.rss_url,
                    language: selectedSource.language ?? "",
                    type: selectedSource.type ?? "",
                    categories: selectedSource.categories,
                    tags: selectedSource.tags,
                  }}
                  onUpdate={async (payload) => {
                    await handleUpdate(selectedSource.id, payload);
                    setSelectedSource(null);
                  }}
                  onDelete={() => setDeleteCandidate(selectedSource)}
                  deleting={isDeleting && deleteCandidate?.id === selectedSource.id}
                />
              </div>
            </>
          ) : null}
        </DialogContent>
      </Dialog>

      <Dialog open={Boolean(deleteCandidate)} onOpenChange={(open) => (!open ? setDeleteCandidate(null) : undefined)}>
        <DialogContent className="max-w-xl">
          {deleteCandidate ? (
            <>
              <DialogHeader className="py-5">
                <DialogTitle>Delete source</DialogTitle>
              </DialogHeader>
              <div className="px-6 py-5">
                <DialogDescription className="text-base leading-7">
                  This will permanently remove <span className="font-medium text-foreground">{deleteCandidate.title}</span> from the index.
                  This action cannot be undone.
                </DialogDescription>
              </div>
              <DialogFooter className="border-t border-border/80 px-6 py-5 sm:justify-start sm:space-x-3">
                <Button type="button" disabled={isDeleting} className="h-12 rounded-none px-6" onClick={() => void handleDelete()}>
                  {isDeleting ? "Deleting..." : "Delete source"}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  disabled={isDeleting}
                  className="h-12 rounded-none px-6"
                  onClick={() => setDeleteCandidate(null)}
                >
                  Cancel
                </Button>
              </DialogFooter>
            </>
          ) : null}
        </DialogContent>
      </Dialog>
    </AdminShell>
  );
}

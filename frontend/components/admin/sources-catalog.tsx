"use client";

import { Database, Filter, Search } from "lucide-react";
import { useDeferredValue, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";

import { AdminShell } from "@/components/admin/admin-shell";
import { SourceCard } from "@/components/source-card";
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
  const [error, setError] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
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

  useEffect(() => {
    void getAdminMe()
      .then((user) => setCurrentUser(user))
      .catch(() => router.replace("/admin/login"));
  }, [router]);

  useEffect(() => {
    setError(null);
    const controller = new AbortController();

    void searchAdminSources({
      keyword: deferredQuery.trim() || undefined,
      language: language === "all" ? undefined : language,
      type: type === "all" ? undefined : type,
      category: category === "all" ? undefined : category,
      limit: "100",
    })
      .then((payload) => {
        if (!controller.signal.aborted) {
          setItems(payload.items);
        }
      })
      .catch((loadError) => {
        if (!controller.signal.aborted) {
          setItems([]);
          setError(loadError instanceof Error ? loadError.message : "Failed to load sources.");
        }
      });

    return () => {
      controller.abort();
    };
  }, [category, deferredQuery, language, type]);

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
          <div className="grid gap-0 md:grid-cols-[minmax(0,1fr)_180px_180px_220px]">
            <label className="relative block border-b border-border/80 focus-within:outline focus-within:outline-1 focus-within:outline-border focus-within:outline-offset-[-1px] md:border-b-0 md:border-r">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input
                className="h-12 rounded-none border-0 bg-transparent pl-9 shadow-none focus-visible:ring-0"
                placeholder="Search source title"
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
            </label>
            <div className="border-b border-border/80 md:border-b-0 md:border-r">
              <FilterDropdown
                value={language}
                onChange={(value) => setLanguage(value as LanguageCode | "all")}
                options={languageOptions}
                placeholder="All languages"
                buttonClassName="flex h-12 w-full items-center justify-between border-0 bg-transparent px-4 text-left text-sm text-foreground"
              />
            </div>
            <div className="border-b border-border/80 md:border-b-0 md:border-r">
              <FilterDropdown
                value={type}
                onChange={(value) => setType(value as SourceType | "all")}
                options={typeOptions}
                placeholder="All types"
                buttonClassName="flex h-12 w-full items-center justify-between border-0 bg-transparent px-4 text-left text-sm text-foreground"
              />
            </div>
            <div>
              <FilterDropdown
                value={category}
                onChange={(value) => setCategory(value as SourceCategory | "all")}
                options={categoryOptions}
                placeholder="All categories"
                buttonClassName="flex h-12 w-full items-center justify-between border-0 bg-transparent px-4 text-left text-sm text-foreground"
              />
            </div>
          </div>
          <div className="border-t border-border/80 px-4 py-3 text-xs uppercase tracking-[0.18em] text-muted-foreground">
            <span className="inline-flex items-center gap-2">
              <Filter className="h-4 w-4" />
              {items.length} source{items.length === 1 ? "" : "s"}
            </span>
          </div>
        </div>

        <div className="border border-border/80">
          {items.map((item, index) => (
            <div key={item.id} className={index === items.length - 1 ? "" : "border-b border-border/80"}>
              <SourceCard source={toPublicSource(item)} onSelect={() => setSelectedSource(item)} />
            </div>
          ))}
          {!items.length ? <p className="px-6 py-10 text-center text-sm text-muted-foreground">No sources matched the current filters.</p> : null}
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

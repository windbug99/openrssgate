"use client";

import Link from "next/link";
import { useEffect, useMemo, useState, useTransition } from "react";
import { useRouter } from "next/navigation";

import type { AdminSource, AdminUser } from "@/lib/admin-api";
import { deleteAdminSource, getAdminMe, listAdminSources, updateAdminSourceStatus } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

const STATUSES = ["pending_review", "hidden", "rejected"] as const;

function statusBadgeVariant(status: string): "default" | "secondary" | "outline" {
  if (status === "rejected") {
    return "default";
  }
  if (status === "hidden") {
    return "outline";
  }
  return "secondary";
}

export function AdminSourcesReview() {
  const router = useRouter();
  const [status, setStatus] = useState<(typeof STATUSES)[number]>("pending_review");
  const [items, setItems] = useState<AdminSource[]>([]);
  const [currentUser, setCurrentUser] = useState<AdminUser | null>(null);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  useEffect(() => {
    void getAdminMe()
      .then((user) => setCurrentUser(user))
      .catch(() => router.replace("/admin/login"));
  }, [router]);

  useEffect(() => {
    setError(null);
    setSelectedId(null);
    setReason("");
    void listAdminSources(status)
      .then((payload) => setItems(payload.items))
      .catch((loadError) => setError(loadError instanceof Error ? loadError.message : "Failed to load the source queue."));
  }, [status]);

  const selected = useMemo(() => items.find((item) => item.id === selectedId) ?? null, [items, selectedId]);

  function refreshCurrentStatus(nextSelectedId?: string | null) {
    void listAdminSources(status)
      .then((payload) => {
        setItems(payload.items);
        if (nextSelectedId && payload.items.some((item) => item.id === nextSelectedId)) {
          setSelectedId(nextSelectedId);
          return;
        }
        setSelectedId(null);
      })
      .catch((loadError) => setError(loadError instanceof Error ? loadError.message : "Failed to refresh the source queue."));
  }

  function handleStatusUpdate(nextStatus: "active" | "hidden" | "rejected") {
    if (!selected) {
      return;
    }
    startTransition(async () => {
      try {
        await updateAdminSourceStatus(selected.id, nextStatus, reason.trim() || undefined);
        setReason("");
        refreshCurrentStatus(nextStatus === status ? selected.id : null);
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to update the source status.");
      }
    });
  }

  function handleDelete() {
    if (!selected) {
      return;
    }
    if (!window.confirm(`Delete "${selected.title}" from the index?`)) {
      return;
    }
    startTransition(async () => {
      try {
        await deleteAdminSource(selected.id, reason.trim() || undefined);
        setReason("");
        refreshCurrentStatus(null);
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to delete the source.");
      }
    });
  }

  return (
    <AdminShell currentUser={currentUser?.email}>
      <div className="border border-border/80">
        <div className="grid grid-cols-1 text-sm md:grid-cols-3">
          {STATUSES.map((item) => {
            const active = status === item;
            return (
              <button
                key={item}
                type="button"
                onClick={() => setStatus(item)}
                className={cn(
                  "flex min-h-[56px] items-center justify-center border-b border-border/80 px-5 text-base capitalize transition-colors md:border-b-0 md:border-r",
                  active ? "bg-foreground text-background" : "bg-background text-foreground hover:bg-muted/30",
                  item === STATUSES[STATUSES.length - 1] && "md:border-r-0",
                )}
              >
                {item}
              </button>
            );
          })}
        </div>
      </div>

      <div className="mt-4 border border-border/80">
        {items.map((item) => (
          <button
            key={item.id}
            type="button"
            onClick={() => {
              setSelectedId(item.id);
              setReason("");
            }}
            className="grid w-full gap-4 border-b border-border/80 px-5 py-5 text-left transition-colors hover:bg-muted/30 md:grid-cols-[minmax(0,1fr)_260px]"
          >
            <div className="min-w-0">
              <div className="flex items-start gap-4">
                <div className="flex h-12 w-12 shrink-0 items-center justify-center overflow-hidden rounded-full border border-border/80 bg-muted/20">
                  {item.favicon_url ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={item.favicon_url} alt="" className="h-full w-full object-cover" />
                  ) : (
                    <span className="text-sm font-semibold uppercase text-muted-foreground">{item.title.slice(0, 1)}</span>
                  )}
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-center gap-3">
                    <p className="truncate text-[1.05rem] font-semibold tracking-[-0.02em] text-foreground">{item.title}</p>
                    <p className="text-sm text-muted-foreground">
                      {item.last_published_at ? new Date(item.last_published_at).toLocaleString() : "Unknown"}
                    </p>
                  </div>
                  <p className="mt-2 truncate text-sm leading-6 text-muted-foreground">
                    {item.description ?? item.rss_url}
                  </p>
                </div>
              </div>
            </div>
            <div className="border-l border-border/80 pl-4 text-sm text-muted-foreground md:pl-5">
              <p className="text-xs uppercase tracking-[0.18em] text-muted-foreground">Reason</p>
              <p className="mt-2 line-clamp-3 text-sm leading-6 text-foreground">
                {item.status_reason ?? "No reason"}
              </p>
            </div>
          </button>
        ))}
        {!items.length ? (
          <p className="py-10 text-center text-base text-muted-foreground">No sources are waiting in this queue.</p>
        ) : null}
      </div>

      {error ? <p className="mt-6 text-sm text-destructive">{error}</p> : null}

      <Dialog open={Boolean(selected)} onOpenChange={(open) => (!open ? setSelectedId(null) : undefined)}>
        <DialogContent className="max-w-4xl rounded-none">
          {selected ? (
            <>
              <DialogHeader>
                <DialogTitle>Review</DialogTitle>
              </DialogHeader>
              <div className="overflow-y-auto px-6 py-5">
                <div className="flex flex-wrap items-center gap-3 pb-3">
                  <span className="inline-flex h-10 items-center border border-border/80 px-4 text-base font-medium text-foreground">
                    {selected.status}
                  </span>
                  {selected.status_reason ? (
                    <span className="inline-flex h-10 items-center border border-border/80 px-4 text-base font-medium text-foreground">
                      {selected.status_reason}
                    </span>
                  ) : null}
                </div>

                <div className="py-3">
                  <h2 className="text-[2rem] font-semibold tracking-[-0.05em] text-foreground">{selected.title}</h2>
                  <p className="mt-2 max-w-3xl text-sm leading-7 text-muted-foreground">
                    {selected.description ?? "No description provided."}
                  </p>
                </div>

                <div className="space-y-4 py-3">
                  <div className="py-3">
                    <p className="text-xs uppercase tracking-[0.24em] text-muted-foreground">RSS URL</p>
                    <div className="mt-3 flex flex-col gap-3 md:flex-row md:items-stretch">
                      <div className="min-h-14 flex-1 border border-border/80 px-4 py-3">
                        <p className="break-all text-base text-foreground">{selected.rss_url}</p>
                      </div>
                      <Link
                        href={selected.site_url}
                        target="_blank"
                        className="inline-flex h-14 items-center justify-center border border-border/80 px-4 text-sm text-foreground"
                      >
                        Open source site
                      </Link>
                    </div>
                  </div>
                  <div className="py-3">
                    <p className="text-xs uppercase tracking-[0.24em] text-muted-foreground">AI Review</p>
                    <div className="mt-3 min-h-14 border border-border/80 px-4 py-3">
                      <p className="text-base text-foreground">{selected.ai_review_decision ?? "none"}</p>
                      {selected.ai_review_reason ? <p className="mt-2 text-sm text-muted-foreground">{selected.ai_review_reason}</p> : null}
                    </div>
                  </div>
                </div>

                <div className="py-3">
                  <label className="block space-y-3">
                    <span className="text-sm text-foreground">Reason</span>
                    <Input
                      value={reason}
                      onChange={(event) => setReason(event.target.value)}
                      placeholder="manual_review / spam / manual_restore"
                      className="h-14 rounded-none"
                    />
                  </label>
                </div>

                <div className="flex flex-wrap gap-3 py-3">
                  <Button
                    type="button"
                    disabled={isPending}
                    className="h-14 rounded-none bg-foreground px-6 text-background hover:opacity-90"
                    onClick={() => handleStatusUpdate("active")}
                  >
                    Restore active
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" className="h-14 rounded-none px-6" onClick={() => handleStatusUpdate("hidden")}>
                    Mark hidden
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" className="h-14 rounded-none px-6" onClick={() => handleStatusUpdate("rejected")}>
                    Mark rejected
                  </Button>
                  <Button
                    type="button"
                    disabled={isPending}
                    variant="outline"
                    className="h-14 rounded-none border-destructive px-6 text-destructive hover:bg-destructive/10"
                    onClick={handleDelete}
                  >
                    Delete source
                  </Button>
                </div>

                <div className="space-y-2 pt-3 text-sm text-muted-foreground">
                  <p>Registered: {new Date(selected.registered_at).toLocaleString()}</p>
                  <p>Last fetched: {selected.last_fetched_at ? new Date(selected.last_fetched_at).toLocaleString() : "Never"}</p>
                  <p>Last published: {selected.last_published_at ? new Date(selected.last_published_at).toLocaleString() : "Unknown"}</p>
                </div>
              </div>
            </>
          ) : null}
        </DialogContent>
      </Dialog>
    </AdminShell>
  );
}

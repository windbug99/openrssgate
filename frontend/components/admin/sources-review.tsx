"use client";

import Link from "next/link";
import { useEffect, useState, useTransition } from "react";
import { useRouter } from "next/navigation";

import type { AdminSource, AdminUser } from "@/lib/admin-api";
import { deleteAdminSource, getAdminMe, listAdminSources, updateAdminSourceStatus } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

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
    void listAdminSources(status)
      .then((payload) => {
        setItems(payload.items);
        setSelectedId((current) => (current && payload.items.some((item) => item.id === current) ? current : payload.items[0]?.id ?? null));
      })
      .catch((loadError) => setError(loadError instanceof Error ? loadError.message : "Failed to load the source queue."));
  }, [router, status]);

  const selected = items.find((item) => item.id === selectedId) ?? null;

  function refreshCurrentStatus() {
    void listAdminSources(status).then((payload) => {
      setItems(payload.items);
      setSelectedId(payload.items[0]?.id ?? null);
    });
  }

  function handleStatusUpdate(nextStatus: "active" | "hidden" | "rejected") {
    if (!selected) {
      return;
    }
    startTransition(async () => {
      try {
        await updateAdminSourceStatus(selected.id, nextStatus, reason.trim() || undefined);
        setReason("");
        refreshCurrentStatus();
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to update the source status.");
      }
    });
  }

  function handleDelete() {
    if (!selected) {
      return;
    }
    const approved = window.confirm(`Delete "${selected.title}" from the index?`);
    if (!approved) {
      return;
    }

    startTransition(async () => {
      try {
        await deleteAdminSource(selected.id, reason.trim() || undefined);
        setReason("");
        refreshCurrentStatus();
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to delete the source.");
      }
    });
  }

  return (
    <AdminShell
      title="Queue moderation"
      description="Work through pending, hidden, and rejected sources with a focused review queue and source-level moderation controls."
      currentUser={currentUser?.email}
    >
      <div className="grid gap-6 lg:grid-cols-[320px_minmax(0,1fr)]">
        <Card className="border-border/80 bg-card/30">
          <CardHeader>
            <CardTitle className="text-xl">Queues</CardTitle>
            <CardDescription>Select the source state you want to review.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex flex-wrap gap-2">
              {STATUSES.map((item) => (
                <Button
                  key={item}
                  type="button"
                  variant={status === item ? "default" : "outline"}
                  className={status === item ? "bg-foreground text-background hover:opacity-90" : ""}
                  onClick={() => setStatus(item)}
                >
                  {item}
                </Button>
              ))}
            </div>
            <div className="space-y-2">
              {items.map((item) => (
                <button
                  type="button"
                  key={item.id}
                  onClick={() => setSelectedId(item.id)}
                  className={`w-full border p-3 text-left transition ${
                    selectedId === item.id ? "border-foreground bg-accent" : "border-border/80 bg-background hover:bg-accent/40"
                  }`}
                >
                  <div className="flex items-center justify-between gap-3">
                    <p className="line-clamp-1 font-medium">{item.title}</p>
                    <Badge variant={statusBadgeVariant(item.status)}>{item.status}</Badge>
                  </div>
                  <p className="mt-1 line-clamp-1 text-xs text-muted-foreground">{item.rss_url}</p>
                </button>
              ))}
              {!items.length ? <p className="text-sm text-muted-foreground">No sources are waiting in this queue.</p> : null}
            </div>
          </CardContent>
        </Card>

        <Card className="border-border/80 bg-card/30">
          <CardHeader>
            <CardTitle className="text-xl">Review</CardTitle>
            <CardDescription>Record a reason, inspect the source, and apply the next moderation state.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-5">
            {selected ? (
              <>
                <div className="flex flex-wrap items-center gap-3">
                  <Badge variant={statusBadgeVariant(selected.status)}>{selected.status}</Badge>
                  {selected.status_reason ? <Badge variant="outline">{selected.status_reason}</Badge> : null}
                  <Link href={selected.site_url} target="_blank" className="text-sm text-foreground underline underline-offset-4">
                    Open source site
                  </Link>
                </div>
                <div>
                  <h2 className="text-3xl font-semibold tracking-[-0.04em]">{selected.title}</h2>
                  <p className="mt-2 text-sm text-muted-foreground">{selected.description ?? "No description provided."}</p>
                </div>
                <dl className="grid gap-4 md:grid-cols-2">
                  <div className="border border-border/80 bg-background px-4 py-4">
                    <dt className="text-xs uppercase tracking-[0.18em] text-muted-foreground">RSS URL</dt>
                    <dd className="mt-2 break-all text-sm">{selected.rss_url}</dd>
                  </div>
                  <div className="border border-border/80 bg-background px-4 py-4">
                    <dt className="text-xs uppercase tracking-[0.18em] text-muted-foreground">AI review</dt>
                    <dd className="mt-2 text-sm">
                      {selected.ai_review_decision ?? "none"}
                      {selected.ai_review_reason ? ` · ${selected.ai_review_reason}` : ""}
                    </dd>
                  </div>
                </dl>
                <label className="block space-y-2">
                  <span className="text-sm text-foreground">Reason</span>
                  <Input value={reason} onChange={(event) => setReason(event.target.value)} placeholder="manual_review / spam / manual_restore" />
                </label>
                <div className="flex flex-wrap gap-3">
                  <Button type="button" disabled={isPending} className="bg-foreground text-background hover:opacity-90" onClick={() => handleStatusUpdate("active")}>
                    Restore active
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" onClick={() => handleStatusUpdate("hidden")}>
                    Mark hidden
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" onClick={() => handleStatusUpdate("rejected")}>
                    Mark rejected
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" className="border-destructive text-destructive hover:bg-destructive/10" onClick={handleDelete}>
                    Delete source
                  </Button>
                </div>
                <div className="border border-border/80 bg-background px-4 py-4 text-sm text-muted-foreground">
                  <p>Registered: {new Date(selected.registered_at).toLocaleString()}</p>
                  <p>Last fetched: {selected.last_fetched_at ? new Date(selected.last_fetched_at).toLocaleString() : "Never"}</p>
                  <p>Last published: {selected.last_published_at ? new Date(selected.last_published_at).toLocaleString() : "Unknown"}</p>
                </div>
              </>
            ) : (
              <p className="text-sm text-muted-foreground">Select a source from the queue to begin review.</p>
            )}
            {error ? <p className="text-sm text-destructive">{error}</p> : null}
          </CardContent>
        </Card>
      </div>
    </AdminShell>
  );
}

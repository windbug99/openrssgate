"use client";

import Link from "next/link";
import { useEffect, useState, useTransition } from "react";
import { useRouter } from "next/navigation";

import type { AdminAuditLog, AdminSource } from "@/lib/admin-api";
import { deleteAdminSource, getAdminSource, listAdminSourceAuditLogs, updateAdminSourceStatus } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function AdminSourceDetail({ sourceId }: { sourceId: string }) {
  const router = useRouter();
  const [source, setSource] = useState<AdminSource | null>(null);
  const [auditLogs, setAuditLogs] = useState<AdminAuditLog[]>([]);
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  useEffect(() => {
    void getAdminSource(sourceId)
      .then((payload) => setSource(payload))
      .catch(() => router.replace("/admin/login"));
    void listAdminSourceAuditLogs(sourceId).then((payload) => setAuditLogs(payload.items)).catch(() => undefined);
  }, [router, sourceId]);

  function refresh() {
    void getAdminSource(sourceId).then((payload) => setSource(payload));
    void listAdminSourceAuditLogs(sourceId).then((payload) => setAuditLogs(payload.items));
  }

  function handleStatus(status: "active" | "hidden" | "rejected") {
    if (!source) {
      return;
    }
    startTransition(async () => {
      try {
        await updateAdminSourceStatus(source.id, status, reason.trim() || undefined);
        refresh();
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to update the source status.");
      }
    });
  }

  function handleDelete() {
    if (!source) {
      return;
    }
    startTransition(async () => {
      try {
        await deleteAdminSource(source.id, reason.trim() || undefined);
        router.push("/admin/sources");
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Failed to delete the source.");
      }
    });
  }

  return (
    <AdminShell>
      <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_300px]">
        <div className="space-y-6">
          <Link href="/admin/sources" className="text-sm text-foreground underline underline-offset-4">
            Back to sources
          </Link>
          <div className="space-y-5 border-y border-border/80 py-5">
            {source ? (
              <>
                <div className="flex flex-wrap gap-2">
                  <Badge>{source.status}</Badge>
                  {source.status_reason ? <Badge variant="outline">{source.status_reason}</Badge> : null}
                </div>
                <div>
                  <h1 className="text-3xl font-semibold tracking-[-0.04em]">{source.title}</h1>
                  <p className="mt-2 text-sm text-muted-foreground">{source.description ?? "No description provided."}</p>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="border-r border-border/80 pr-4 text-sm break-all">{source.rss_url}</div>
                  <div className="text-sm break-all">{source.site_url}</div>
                </div>
                <label className="block space-y-2">
                  <span className="text-sm text-foreground">Reason</span>
                  <Input value={reason} onChange={(event) => setReason(event.target.value)} />
                </label>
                <div className="flex flex-wrap gap-3">
                  <Button type="button" disabled={isPending} onClick={() => handleStatus("active")} className="bg-foreground text-background hover:opacity-90">
                    Restore active
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" onClick={() => handleStatus("hidden")}>
                    Mark hidden
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" onClick={() => handleStatus("rejected")}>
                    Mark rejected
                  </Button>
                  <Button type="button" disabled={isPending} variant="outline" className="border-destructive text-destructive hover:bg-destructive/10" onClick={handleDelete}>
                    Delete source
                  </Button>
                </div>
                {error ? <p className="text-sm text-destructive">{error}</p> : null}
              </>
            ) : null}
          </div>
        </div>
        <div className="h-fit border-y border-border/80 py-5">
          <p className="mb-4 text-sm font-medium text-foreground">Audit Trail</p>
          <div className="space-y-3">
            {auditLogs.map((entry) => (
              <div key={entry.id} className="border-b border-border/80 pb-3">
                <p className="text-sm font-medium">{entry.action}</p>
                <p className="mt-1 text-xs text-muted-foreground">{entry.admin_user_email ?? "unknown"}</p>
                <p className="mt-1 text-xs text-muted-foreground">
                  {entry.from_status ?? "-"} → {entry.to_status ?? "-"}
                  {entry.reason ? ` · ${entry.reason}` : ""}
                </p>
                <p className="mt-2 text-[11px] uppercase tracking-[0.14em] text-muted-foreground">
                  {new Date(entry.created_at).toLocaleString()}
                </p>
              </div>
            ))}
            {!auditLogs.length ? <p className="text-sm text-muted-foreground">No audit entries are recorded for this source.</p> : null}
          </div>
        </div>
      </div>
    </AdminShell>
  );
}

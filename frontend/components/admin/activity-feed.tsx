"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

import type { AdminAuditLog, AdminUser } from "@/lib/admin-api";
import { getAdminMe, listAdminAuditLogs } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";

function getStatusChangeLabel(entry: AdminAuditLog): string {
  if (entry.action === "source.deleted") {
    return "deleted";
  }
  return `${entry.from_status ?? "-"} → ${entry.to_status ?? "-"}`;
}

function getStatusChangeClass(entry: AdminAuditLog): string {
  if (entry.action === "source.deleted") {
    return "border-zinc-500/80 text-zinc-300";
  }
  if (entry.to_status === "active") {
    return "border-emerald-500/80 text-emerald-300";
  }
  if (entry.to_status === "hidden") {
    return "border-sky-500/80 text-sky-300";
  }
  if (entry.to_status === "rejected") {
    return "border-rose-500/80 text-rose-300";
  }
  return "border-border/80 text-foreground";
}

export function AdminActivityFeed() {
  const router = useRouter();
  const [currentUser, setCurrentUser] = useState<AdminUser | null>(null);
  const [auditLogs, setAuditLogs] = useState<AdminAuditLog[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void getAdminMe()
      .then((user) => setCurrentUser(user))
      .catch(() => router.replace("/admin/login"));
    void listAdminAuditLogs(40)
      .then((payload) => setAuditLogs(payload.items))
      .catch((loadError) => setError(loadError instanceof Error ? loadError.message : "Failed to load recent activity."));
  }, [router]);

  return (
    <AdminShell currentUser={currentUser?.email}>
      <div className="border border-border/80">
        {auditLogs.map((entry) => (
          <article key={entry.id} className="border-b border-border/80 px-5 py-5 last:border-b-0">
            <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
              <div className="min-w-0 flex-1">
                <div className="flex flex-col gap-2 md:flex-row md:items-start md:justify-between md:gap-4">
                  <p className="text-base font-semibold tracking-[-0.02em] text-foreground">{entry.source_title ?? entry.source_id ?? "Deleted source"}</p>
                  <p className="shrink-0 text-sm text-muted-foreground">
                    {new Intl.DateTimeFormat("ko-KR", {
                      year: "numeric",
                      month: "numeric",
                      day: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                      second: "2-digit",
                      hour12: false,
                    }).format(new Date(entry.created_at))}
                  </p>
                </div>
                <p className="mt-1 text-sm text-muted-foreground">
                  {entry.admin_user_email ?? "Unknown admin"} · {entry.action}
                </p>
                {entry.reason ? <p className="mt-3 text-sm text-muted-foreground">{entry.reason}</p> : null}
              </div>
              <div className="flex shrink-0 flex-col gap-3 border-border/80 md:min-w-[220px] md:border-l md:pl-5">
                <div className={`inline-flex items-center justify-center rounded-none border bg-muted/10 px-3 py-2 text-center text-sm font-medium ${getStatusChangeClass(entry)}`}>
                  {getStatusChangeLabel(entry)}
                </div>
              </div>
            </div>
          </article>
        ))}
        {!auditLogs.length && !error ? <p className="px-5 py-8 text-sm text-muted-foreground">No activity has been recorded yet.</p> : null}
      </div>
      {error ? <p className="mt-6 text-sm text-destructive">{error}</p> : null}
    </AdminShell>
  );
}

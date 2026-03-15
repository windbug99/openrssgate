"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

import type { AdminAuditLog, AdminUser } from "@/lib/admin-api";
import { getAdminMe, listAdminAuditLogs } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";

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
            <div className="flex flex-col gap-2 md:flex-row md:items-start md:justify-between">
              <div>
                <p className="text-base font-semibold tracking-[-0.02em] text-foreground">{entry.source_title ?? entry.source_id ?? "Deleted source"}</p>
                <p className="mt-1 text-sm text-muted-foreground">
                  {entry.admin_user_email ?? "Unknown admin"} · {entry.action}
                </p>
              </div>
              <p className="text-xs uppercase tracking-[0.18em] text-muted-foreground">{new Date(entry.created_at).toLocaleString()}</p>
            </div>
            <p className="mt-3 text-sm text-muted-foreground">
              {entry.from_status ?? "-"} to {entry.to_status ?? "-"}
              {entry.reason ? ` · ${entry.reason}` : ""}
            </p>
          </article>
        ))}
        {!auditLogs.length && !error ? <p className="px-5 py-8 text-sm text-muted-foreground">No activity has been recorded yet.</p> : null}
      </div>
      {error ? <p className="mt-6 text-sm text-destructive">{error}</p> : null}
    </AdminShell>
  );
}

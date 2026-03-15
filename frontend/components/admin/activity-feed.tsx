"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

import type { AdminAuditLog, AdminUser } from "@/lib/admin-api";
import { getAdminMe, listAdminAuditLogs } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

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
    <AdminShell
      title="Recent admin activity"
      description="Review moderation history, status transitions, and deletion actions from a single audit stream."
      currentUser={currentUser?.email}
    >
      <Card className="border-border/80 bg-card/30">
        <CardHeader>
          <CardTitle>Activity stream</CardTitle>
          <CardDescription>Latest moderation events across all sources.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-3">
          {auditLogs.map((entry) => (
            <article key={entry.id} className="border border-border/80 bg-background px-4 py-4">
              <div className="flex flex-col gap-1 md:flex-row md:items-start md:justify-between">
                <div>
                  <p className="text-base font-semibold text-foreground">{entry.source_title ?? entry.source_id ?? "Deleted source"}</p>
                  <p className="text-sm text-muted-foreground">
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
          {!auditLogs.length && !error ? <p className="text-sm text-muted-foreground">No activity has been recorded yet.</p> : null}
          {error ? <p className="text-sm text-destructive">{error}</p> : null}
        </CardContent>
      </Card>
    </AdminShell>
  );
}

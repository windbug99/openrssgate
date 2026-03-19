"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

import type { AdminSourceRegistrationAttempt, AdminUser } from "@/lib/admin-api";
import { getAdminMe, listAdminRegistrationAttempts } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";

function getResultLabel(entry: AdminSourceRegistrationAttempt): string {
  if (entry.result === "success") {
    return "success";
  }
  return entry.result_reason ?? "failed";
}

function getResultClass(entry: AdminSourceRegistrationAttempt): string {
  if (entry.result === "success") {
    return "border-emerald-500/80 text-emerald-300";
  }
  return "border-rose-500/80 text-rose-300";
}

export function AdminActivityFeed() {
  const router = useRouter();
  const [currentUser, setCurrentUser] = useState<AdminUser | null>(null);
  const [attempts, setAttempts] = useState<AdminSourceRegistrationAttempt[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void getAdminMe()
      .then((user) => setCurrentUser(user))
      .catch(() => router.replace("/admin/login"));
    void listAdminRegistrationAttempts(40)
      .then((payload) => setAttempts(payload.items))
      .catch((loadError) => setError(loadError instanceof Error ? loadError.message : "Failed to load source registration activity."));
  }, [router]);

  return (
    <AdminShell currentUser={currentUser?.email}>
      <div className="border border-border/80">
        {attempts.map((entry) => (
          <article key={entry.id} className="border-b border-border/80 px-5 py-5 last:border-b-0">
            <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
              <div className="min-w-0 flex-1">
                <div className="flex flex-col gap-2 md:flex-row md:items-start md:justify-between md:gap-4">
                  <p className="text-base font-semibold tracking-[-0.02em] text-foreground">{entry.title ?? entry.rss_url}</p>
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
                <p className="mt-1 text-sm text-muted-foreground">{entry.site_url ?? entry.rss_url}</p>
                {entry.site_url && entry.site_url !== entry.rss_url ? (
                  <p className="mt-3 break-all text-sm text-muted-foreground">{entry.rss_url}</p>
                ) : null}
              </div>
              <div className="flex shrink-0 flex-col gap-3 border-border/80 md:min-w-[220px] md:border-l md:pl-5">
                <div className={`inline-flex items-center justify-center rounded-none border bg-muted/10 px-3 py-2 text-center text-sm font-medium ${getResultClass(entry)}`}>
                  {getResultLabel(entry)}
                </div>
              </div>
            </div>
          </article>
        ))}
        {!attempts.length && !error ? <p className="px-5 py-8 text-sm text-muted-foreground">No activity has been recorded yet.</p> : null}
      </div>
      {error ? <p className="mt-6 text-sm text-destructive">{error}</p> : null}
    </AdminShell>
  );
}

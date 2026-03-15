import { AdminShell } from "@/components/admin/admin-shell";
import { AdminLoginForm } from "@/components/admin/login-form";

export default function AdminLoginPage() {
  return (
    <AdminShell
      showAdminNav={false}
      title="Moderate source quality"
      description="Review pending submissions, hide low-quality feeds, reject spam, and inspect moderation history from a single admin console."
    >
      <div className="grid gap-10 lg:grid-cols-[1.05fr_0.95fr] lg:items-start">
        <section className="space-y-6 border border-border/80 bg-card/20 px-6 py-8">
          <div className="space-y-2">
            <p className="text-xs uppercase tracking-[0.24em] text-muted-foreground">Admin access</p>
            <h2 className="text-[2.4rem] font-semibold leading-[1.08] tracking-[-0.05em] text-foreground">
              Source moderation without terminal overhead.
            </h2>
          </div>
          <p className="text-[16px] leading-[1.9] text-muted-foreground">
            Work through moderation queues, inspect AI review signals, and keep the public source index clean without leaving the browser.
          </p>
        </section>
        <AdminLoginForm />
      </div>
    </AdminShell>
  );
}

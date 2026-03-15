"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import type { ReactNode } from "react";

import { logoutAdmin } from "@/lib/admin-api";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { href: "/admin/queues", label: "Queues" },
  { href: "/admin/activity", label: "Activity" },
];

export function AdminShell({
  eyebrow = "OpenRSSGate Admin",
  title,
  description,
  currentUser,
  showAdminNav = true,
  children,
}: {
  eyebrow?: string;
  title: string;
  description: string;
  currentUser?: string | null;
  showAdminNav?: boolean;
  children: ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();

  return (
    <div className="min-h-screen bg-background">
      <header className="w-full border-b border-border/80">
        <div className="mx-auto flex w-full max-w-[1040px] min-h-[56px] flex-col gap-3 px-6 py-3 md:flex-row md:items-center md:justify-between md:px-10 md:py-4">
          <div className="flex items-center gap-6">
            <Link href="/" className="text-[1.25rem] font-semibold tracking-[-0.04em] text-foreground">
              OpenRSSGate
            </Link>
            {showAdminNav ? (
              <nav className="flex items-center gap-2">
                {NAV_ITEMS.map((item) => {
                  const active = pathname === item.href || pathname.startsWith(`${item.href}/`);
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      className={cn(
                        "inline-flex h-9 items-center rounded-md px-3 text-[15px] transition-colors",
                        active ? "bg-foreground text-background" : "text-muted-foreground hover:bg-accent hover:text-foreground",
                      )}
                    >
                      {item.label}
                    </Link>
                  );
                })}
              </nav>
            ) : null}
          </div>
          <div className="flex items-center gap-3">
            <Button asChild variant="ghost" size="sm" className="h-9 px-3 text-[15px] font-normal text-muted-foreground">
              <Link href="/">Public index</Link>
            </Button>
            {showAdminNav ? (
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => {
                  void logoutAdmin().finally(() => router.push("/admin/login"));
                }}
              >
                Sign out
              </Button>
            ) : null}
          </div>
        </div>
      </header>

      <main className="mx-auto w-full max-w-[1040px] border-x border-border/80">
        <section className="border-b border-border/70 px-6 py-10 md:px-10">
          <div className="mb-5 flex items-center gap-2 text-xs font-medium uppercase tracking-[0.24em] text-muted-foreground">
            <span>{eyebrow}</span>
          </div>
          <div className="space-y-2">
            <h1 className="text-[2.2rem] font-bold tracking-[-0.05em] text-foreground md:text-[2.8rem]">{title}</h1>
            <p className="max-w-3xl text-[16px] leading-[1.9] text-muted-foreground">{description}</p>
            {currentUser ? <p className="text-sm text-muted-foreground">Signed in as {currentUser}</p> : null}
          </div>
        </section>
        <div className="px-6 py-8 md:px-10 md:py-10">{children}</div>
      </main>
    </div>
  );
}

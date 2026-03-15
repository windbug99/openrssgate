"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import type { ReactNode } from "react";
import { Github } from "lucide-react";

import { logoutAdmin } from "@/lib/admin-api";
import { ThemeToggle } from "@/components/theme-toggle";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { href: "/admin/sources", label: "Sources" },
  { href: "/admin/queues", label: "Queues" },
  { href: "/admin/activity", label: "Activity" },
];

export function AdminShell({
  currentUser,
  showAdminNav = true,
  children,
}: {
  currentUser?: string | null;
  showAdminNav?: boolean;
  children: ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();

  return (
    <div className="flex min-h-screen flex-col bg-background">
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
            {currentUser ? <span className="hidden text-sm text-muted-foreground md:inline">{currentUser}</span> : null}
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
            <span className="ml-1 h-8 w-px bg-border/80" aria-hidden="true" />
            <ThemeToggle />
          </div>
        </div>
      </header>

      <div className="flex flex-1">
        <div className="mx-auto flex w-full max-w-[1040px] flex-1 flex-col border-x border-border/80">
          <main className="flex-1">
            <div className="px-6 py-8 md:px-10 md:py-10">{children}</div>
          </main>
        </div>
      </div>

      <footer className="w-full border-t border-border/80">
        <div className="mx-auto w-full max-w-[1040px] border-x border-border/80">
          <div className="flex w-full items-center justify-center px-6 py-8 md:px-10">
            <div className="flex flex-wrap items-center justify-center gap-2 text-[13px] text-muted-foreground">
              <a
                href="https://github.com/windbug99/openrssgate"
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-1.5 transition-colors hover:text-foreground"
              >
                <Github className="h-4 w-4" />
                <span>github</span>
              </a>
              <span>·</span>
              <span>mit license</span>
              <span>·</span>
              <span>built by Promethium</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}

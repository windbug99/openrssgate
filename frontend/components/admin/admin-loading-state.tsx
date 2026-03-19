"use client";

import { LoaderCircle } from "lucide-react";

import { cn } from "@/lib/utils";

export function AdminLoadingState({
  label = "Loading...",
  className,
  compact = false,
}: {
  label?: string;
  className?: string;
  compact?: boolean;
}) {
  return (
    <div
      className={cn(
        "flex items-center justify-center gap-3 border border-dashed border-border bg-card/40 text-sm text-muted-foreground",
        compact ? "px-4 py-3" : "px-5 py-10",
        className,
      )}
    >
      <LoaderCircle className="h-4 w-4 animate-spin" />
      <span>{label}</span>
    </div>
  );
}

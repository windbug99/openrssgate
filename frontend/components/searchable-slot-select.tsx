"use client";

import { Check, ChevronDown, Search, X } from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";

import { cn } from "@/lib/utils";

type Option<T extends string> = {
  value: T;
  label: string;
};

function toSlots<T extends string>(value: T[], slotCount: number): Array<T | ""> {
  const slots = Array.from({ length: slotCount }, (_, index) => value[index] ?? "");
  return slots;
}

export function SearchableSlotSelect<T extends string>({
  label,
  value,
  onChange,
  options,
  slotCount,
  columns,
  placeholder,
  emptyMessage,
}: {
  label: string;
  value: T[];
  onChange: (value: T[]) => void;
  options: readonly Option<T>[];
  slotCount: number;
  columns?: number;
  placeholder: string;
  emptyMessage: string;
}) {
  const rootRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [activeSlot, setActiveSlot] = useState<number>(0);
  const slots = toSlots(value, slotCount);

  useEffect(() => {
    function handlePointerDown(event: MouseEvent) {
      if (!rootRef.current?.contains(event.target as Node)) {
        setOpen(false);
      }
    }

    function handleEscape(event: KeyboardEvent) {
      if (event.key === "Escape") {
        setOpen(false);
      }
    }

    document.addEventListener("mousedown", handlePointerDown);
    document.addEventListener("keydown", handleEscape);

    return () => {
      document.removeEventListener("mousedown", handlePointerDown);
      document.removeEventListener("keydown", handleEscape);
    };
  }, []);

  useEffect(() => {
    if (open) {
      inputRef.current?.focus();
    }
  }, [open]);

  const filteredOptions = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();
    const taken = new Set(value.filter((item, index) => index !== activeSlot));
    return [...options]
      .filter((option) => {
        if (taken.has(option.value)) {
          return false;
        }
        if (!normalizedQuery) {
          return true;
        }
        return option.label.toLowerCase().includes(normalizedQuery) || option.value.toLowerCase().includes(normalizedQuery);
      })
      .sort((left, right) => left.label.localeCompare(right.label));
  }, [activeSlot, options, query, value]);

  function updateSlot(slotIndex: number, nextValue: T | "") {
    const nextSlots = [...slots];
    nextSlots[slotIndex] = nextValue;
    onChange(nextSlots.filter((item): item is T => Boolean(item)));
  }

  function handleSelect(option: T) {
    updateSlot(activeSlot, option);
    setQuery("");
    setOpen(false);
  }

  return (
    <div ref={rootRef} className="space-y-2">
      <div className="flex items-center justify-between gap-3">
        <span className="text-xs font-medium uppercase tracking-[0.18em] text-muted-foreground">{label}</span>
        <span className="text-xs text-muted-foreground">
          {value.length}/{slotCount}
        </span>
      </div>
      <div
        className={cn(
          "grid gap-2",
          columns === 3 ? "md:grid-cols-3" : columns === 2 ? "md:grid-cols-2" : "grid-cols-1",
        )}
      >
        {slots.map((selectedValue, slotIndex) => {
          const selectedOption = options.find((option) => option.value === selectedValue);
          const isActive = open && activeSlot === slotIndex;

          return (
            <div key={`${label}-${slotIndex}`} className="relative">
              <button
                type="button"
                className={cn(
                  "flex h-12 w-full items-center justify-between border px-4 text-left text-sm transition-colors",
                  "border-border/80 bg-transparent text-foreground",
                  isActive && "border-foreground",
                )}
                onClick={() => {
                  setActiveSlot(slotIndex);
                  setQuery("");
                  setOpen(true);
                }}
              >
                <span className={cn("truncate", !selectedOption && "text-muted-foreground")}>
                  {selectedOption?.label ?? `${placeholder} ${slotIndex + 1}`}
                </span>
                <span className="flex items-center gap-2">
                  {selectedOption ? (
                    <span
                      className="text-muted-foreground transition-colors hover:text-foreground"
                      onClick={(event) => {
                        event.stopPropagation();
                        updateSlot(slotIndex, "");
                        if (activeSlot === slotIndex) {
                          setQuery("");
                        }
                      }}
                    >
                      <X className="h-4 w-4" />
                    </span>
                  ) : null}
                  <ChevronDown className="h-4 w-4 text-muted-foreground" />
                </span>
              </button>

              {isActive ? (
                <div className="absolute left-0 right-0 top-full z-30 mt-1 border border-border bg-background">
                  <div className="flex items-center gap-2 border-b border-border px-3">
                    <Search className="h-4 w-4 text-muted-foreground" />
                    <input
                      ref={inputRef}
                      value={query}
                      onChange={(event) => setQuery(event.target.value)}
                      placeholder={`Search ${label.toLowerCase()}`}
                      className="h-11 w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
                    />
                  </div>
                  <div className="max-h-56 overflow-y-auto [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
                    {filteredOptions.length > 0 ? (
                      filteredOptions.map((option) => (
                        <button
                          key={option.value}
                          type="button"
                          className="flex h-11 w-full items-center justify-between border-b border-border px-4 text-left text-sm text-foreground last:border-b-0 hover:bg-muted/40"
                          onClick={() => handleSelect(option.value)}
                        >
                          <span>{option.label}</span>
                          {option.value === selectedValue ? <Check className="h-4 w-4" /> : null}
                        </button>
                      ))
                    ) : (
                      <div className="px-4 py-3 text-sm text-muted-foreground">{emptyMessage}</div>
                    )}
                  </div>
                </div>
              ) : null}
            </div>
          );
        })}
      </div>
    </div>
  );
}

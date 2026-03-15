"use client";

import { Check, ChevronDown } from "lucide-react";
import { useEffect, useRef, useState } from "react";

type Option<T extends string> = {
  value: T;
  label: string;
};

export function FilterDropdown<T extends string>({
  value,
  onChange,
  options,
  icon,
  placeholder,
  className,
  buttonClassName,
  menuClassName,
}: {
  value: T;
  onChange: (value: T) => void;
  options: Array<Option<T>>;
  icon?: React.ReactNode;
  placeholder: string;
  className?: string;
  buttonClassName?: string;
  menuClassName?: string;
}) {
  const [open, setOpen] = useState(false);
  const rootRef = useRef<HTMLDivElement>(null);

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

  const selected = options.find((option) => option.value === value);

  return (
    <div ref={rootRef} className={className}>
      <button
        type="button"
        className={buttonClassName ?? "flex h-12 w-full items-center justify-between bg-transparent px-4 text-left text-sm text-foreground"}
        onClick={() => setOpen((current) => !current)}
      >
        <span className="flex min-w-0 items-center gap-3">
          {icon}
          <span className="truncate">{selected?.label ?? placeholder}</span>
        </span>
        <ChevronDown className="mr-1 h-4 w-4 shrink-0 text-muted-foreground" />
      </button>

      {open ? (
        <div
          className={
            menuClassName ??
            "absolute left-0 top-full z-20 mt-px max-h-80 w-full overflow-y-auto border border-border bg-background shadow-none [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden"
          }
        >
          {options.map((option) => (
            <button
              key={option.value}
              type="button"
              className="flex h-11 w-full items-center justify-between border-b border-border px-4 text-left text-sm text-foreground last:border-b-0 hover:bg-muted/40"
              onPointerDown={(event) => {
                event.preventDefault();
                event.stopPropagation();
                onChange(option.value);
                setOpen(false);
              }}
            >
              <span>{option.label}</span>
              {option.value === value ? <Check className="h-4 w-4" /> : null}
            </button>
          ))}
        </div>
      ) : null}
    </div>
  );
}

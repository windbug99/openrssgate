"use client";

import { Plus } from "lucide-react";
import { useState } from "react";
import type { ReactNode } from "react";

import { SourceRegisterForm } from "@/components/source-register-form";
import type { Source } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";

export function SourceRegisterDialog({
  trigger,
  onSuccess,
}: {
  trigger?: ReactNode;
  onSuccess?: (source: Source) => void;
}) {
  const [open, setOpen] = useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        {trigger ?? (
          <Button type="button">
            <Plus className="mr-2 h-4 w-4" />
            Add source
          </Button>
        )}
      </DialogTrigger>
      <DialogContent className="max-w-3xl">
        <DialogHeader className="py-5">
          <DialogTitle>Add a new source</DialogTitle>
        </DialogHeader>
        <div className="min-h-0 overflow-y-auto px-6 py-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
          <SourceRegisterForm
            onSuccess={(source) => {
              onSuccess?.(source);
              setOpen(false);
            }}
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}

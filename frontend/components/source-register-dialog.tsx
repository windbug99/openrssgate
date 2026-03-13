"use client";

import { Plus } from "lucide-react";
import type { ReactNode } from "react";

import { SourceRegisterForm } from "@/components/source-register-form";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";

export function SourceRegisterDialog({ trigger }: { trigger?: ReactNode }) {
  return (
    <Dialog>
      <DialogTrigger asChild>
        {trigger ?? (
          <Button type="button">
            <Plus className="mr-2 h-4 w-4" />
            Add source
          </Button>
        )}
      </DialogTrigger>
      <DialogContent className="max-w-3xl">
        <DialogHeader>
          <DialogTitle>Add a new source</DialogTitle>
        </DialogHeader>
        <div className="overflow-y-auto px-6 py-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
          <SourceRegisterForm />
        </div>
      </DialogContent>
    </Dialog>
  );
}

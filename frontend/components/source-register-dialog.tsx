"use client";

import { Plus } from "lucide-react";

import { SourceRegisterForm } from "@/components/source-register-form";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";

export function SourceRegisterDialog() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button type="button">
          <Plus className="mr-2 h-4 w-4" />
          Add source
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-3xl">
        <DialogHeader>
          <DialogTitle>Add a new source</DialogTitle>
        </DialogHeader>
        <SourceRegisterForm />
      </DialogContent>
    </Dialog>
  );
}

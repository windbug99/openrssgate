"use client";

import { useEffect, useState, useTransition } from "react";
import { useRouter } from "next/navigation";

import { regenerateRecoveryCodes, setupAdminTotp, verifyAdminTotp } from "@/lib/admin-api";
import { AdminShell } from "@/components/admin/admin-shell";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

export function AdminTotpSetup() {
  const router = useRouter();
  const [secret, setSecret] = useState<string | null>(null);
  const [otpauthUrl, setOtpauthUrl] = useState<string | null>(null);
  const [otpCode, setOtpCode] = useState("");
  const [recoveryCodes, setRecoveryCodes] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  useEffect(() => {
    void setupAdminTotp()
      .then((payload) => {
        setSecret(payload.manual_entry_key);
        setOtpauthUrl(payload.otpauth_url);
      })
      .catch(() => router.replace("/admin/login"));
  }, [router]);

  function handleVerify(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();

    setError(null);
    startTransition(async () => {
      try {
        const payload = await verifyAdminTotp(otpCode);
        setRecoveryCodes(payload.recovery_codes);
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "OTP verification failed.");
      }
    });
  }

  return (
    <AdminShell showAdminNav={false}>
      <div className="mx-auto max-w-2xl">
        <Card className="border-border/80 bg-card/30">
          <CardHeader>
            <CardTitle className="text-3xl tracking-[-0.04em]">OTP setup</CardTitle>
            <CardDescription>
              Add the manual key below to an authenticator app, then enter the generated six-digit code.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-5">
            <div className="border border-border/80 bg-background px-4 py-4">
              <p className="text-xs uppercase tracking-[0.18em] text-muted-foreground">Manual entry key</p>
              <p className="mt-2 break-all font-mono text-sm text-foreground">{secret ?? "Loading..."}</p>
              {otpauthUrl ? <p className="mt-3 break-all text-xs text-muted-foreground">{otpauthUrl}</p> : null}
            </div>
            <form className="space-y-4" onSubmit={handleVerify}>
              <label className="block space-y-2 text-sm">
                <span className="text-foreground">OTP code</span>
                <Input
                  type="text"
                  inputMode="numeric"
                  value={otpCode}
                  onChange={(event) => setOtpCode(event.target.value)}
                  className="border-border/80 bg-background"
                  required
                />
              </label>
              {error ? <p className="text-sm text-destructive">{error}</p> : null}
              <div className="flex gap-3">
                <Button type="submit" disabled={isPending} className="bg-foreground text-background hover:opacity-90">
                  {isPending ? "Verifying..." : "Enable OTP"}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    router.push("/admin/login");
                  }}
                >
                  Cancel
                </Button>
              </div>
            </form>
            {recoveryCodes.length ? (
              <div className="space-y-4 border border-border/80 bg-background px-4 py-4">
                <div className="flex items-center justify-between gap-3">
                  <div>
                    <p className="text-xs uppercase tracking-[0.18em] text-muted-foreground">Recovery codes</p>
                    <p className="mt-1 text-sm text-muted-foreground">Each code can be used once. Store them somewhere safe.</p>
                  </div>
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => {
                      void regenerateRecoveryCodes()
                        .then((payload) => setRecoveryCodes(payload.recovery_codes))
                        .catch((regenError) => setError(regenError instanceof Error ? regenError.message : "Failed to regenerate recovery codes."));
                    }}
                  >
                    Regenerate
                  </Button>
                </div>
                <div className="grid gap-2 sm:grid-cols-2">
                  {recoveryCodes.map((code) => (
                    <div key={code} className="border border-border/80 bg-card px-3 py-3 font-mono text-sm text-foreground">
                      {code}
                    </div>
                  ))}
                </div>
                <Button type="button" className="bg-foreground text-background hover:opacity-90" onClick={() => router.push("/admin/sources")}>
                  Continue to sources
                </Button>
              </div>
            ) : null}
          </CardContent>
        </Card>
      </div>
    </AdminShell>
  );
}

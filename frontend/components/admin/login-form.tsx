"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";

import { loginAdmin } from "@/lib/admin-api";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

export function AdminLoginForm() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [otpCode, setOtpCode] = useState("");
  const [recoveryCode, setRecoveryCode] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError(null);

    startTransition(async () => {
      try {
        const session = await loginAdmin({
          email,
          password,
          ...(otpCode.trim() ? { otp_code: otpCode.trim() } : {}),
          ...(recoveryCode.trim() ? { recovery_code: recoveryCode.trim() } : {}),
        });
        router.push(session.requires_totp_setup ? "/admin/setup-otp" : "/admin/sources");
      } catch (submitError) {
        setError(submitError instanceof Error ? submitError.message : "Sign in failed.");
      }
    });
  }

  return (
    <Card className="border-border/80 bg-card/30">
      <CardHeader>
        <CardTitle className="text-3xl tracking-[-0.04em]">Admin Access</CardTitle>
        <CardDescription className="text-sm">
          Sign in with email and password. If OTP is already enabled, add a six-digit code or a recovery code.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <label className="block space-y-2 text-sm">
            <span className="text-foreground">Email</span>
            <Input
              type="email"
              autoComplete="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              className="border-border/80 bg-background"
              required
            />
          </label>
          <label className="block space-y-2 text-sm">
            <span className="text-foreground">Password</span>
            <Input
              type="password"
              autoComplete="current-password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              className="border-border/80 bg-background"
              required
            />
          </label>
          <label className="block space-y-2 text-sm">
            <span className="text-foreground">OTP code</span>
            <Input
              type="text"
              inputMode="numeric"
              placeholder="Only required after OTP is enabled"
              value={otpCode}
              onChange={(event) => setOtpCode(event.target.value)}
              className="border-border/80 bg-background"
            />
          </label>
          <label className="block space-y-2 text-sm">
            <span className="text-foreground">Recovery code</span>
            <Input
              type="text"
              placeholder="Use this instead of an OTP code"
              value={recoveryCode}
              onChange={(event) => setRecoveryCode(event.target.value)}
              className="border-border/80 bg-background"
            />
          </label>
          {error ? <p className="text-sm text-destructive">{error}</p> : null}
          <Button type="submit" disabled={isPending} className="w-full bg-foreground text-background hover:opacity-90">
            {isPending ? "Signing in..." : "Sign In"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}

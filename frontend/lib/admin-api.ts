export type AdminUser = {
  id: string;
  email: string;
  totp_enabled: boolean;
  last_login_at: string | null;
};

export type AdminLoginResponse = {
  access_token: string;
  token_type: "bearer";
  requires_totp_setup: boolean;
  user: AdminUser;
};

export type AdminTotpSetup = {
  secret: string;
  otpauth_url: string;
  manual_entry_key: string;
};

export type AdminTotpVerifyResponse = {
  user: AdminUser;
  recovery_codes: string[];
};

export type AdminSource = {
  id: string;
  rss_url: string;
  site_url: string;
  title: string;
  description: string | null;
  favicon_url: string | null;
  status: string;
  status_reason: string | null;
  registered_at: string;
  last_fetched_at: string | null;
  last_published_at: string | null;
  consecutive_fail_count: number;
  ai_reviewed_at: string | null;
  ai_review_source: string | null;
  ai_review_reason: string | null;
  ai_review_confidence: string | null;
  ai_review_decision: string | null;
};

export type AdminAuditLog = {
  id: string;
  admin_user_email: string | null;
  source_id: string | null;
  source_title: string | null;
  action: string;
  reason: string | null;
  from_status: string | null;
  to_status: string | null;
  created_at: string;
};

export type AdminRecoveryCodesResponse = {
  recovery_codes: string[];
};

const ADMIN_API_BASE_URL = "/api/admin";

async function adminRequest<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${ADMIN_API_BASE_URL}${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
    cache: "no-store",
    credentials: "include",
  });

  if (!response.ok) {
    const payload = (await response.json().catch(() => null)) as
      | { error?: { code?: string; message?: string }; detail?: { code?: string; message?: string } | string }
      | null;
    const detailMessage =
      typeof payload?.detail === "string"
        ? payload.detail
        : payload?.detail && typeof payload.detail === "object"
          ? payload.detail.message
          : undefined;
    throw new Error(payload?.error?.message ?? detailMessage ?? `Request failed with ${response.status}`);
  }

  if (response.status === 204) {
    return undefined as T;
  }
  return response.json() as Promise<T>;
}

export function loginAdmin(payload: { email: string; password: string; otp_code?: string; recovery_code?: string }) {
  return adminRequest<AdminLoginResponse>("/auth/login", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}

export function getAdminMe() {
  return adminRequest<AdminUser>("/auth/me");
}

export function logoutAdmin() {
  return adminRequest<{ status: string }>("/auth/logout", { method: "POST" });
}

export function setupAdminTotp() {
  return adminRequest<AdminTotpSetup>("/auth/totp/setup", { method: "POST" });
}

export function verifyAdminTotp(code: string) {
  return adminRequest<AdminTotpVerifyResponse>("/auth/totp/verify", {
    method: "POST",
    body: JSON.stringify({ code }),
  });
}

export function regenerateRecoveryCodes() {
  return adminRequest<AdminRecoveryCodesResponse>("/auth/recovery-codes/regenerate", {
    method: "POST",
  });
}

export function listAdminSources(status: string) {
  const query = new URLSearchParams({ status }).toString();
  return adminRequest<{ items: AdminSource[] }>(`/sources?${query}`);
}

export function getAdminSource(sourceId: string) {
  return adminRequest<AdminSource>(`/sources/${sourceId}`);
}

export function listAdminAuditLogs(limit = 20) {
  const query = new URLSearchParams({ limit: String(limit) }).toString();
  return adminRequest<{ items: AdminAuditLog[] }>(`/audit-logs?${query}`);
}

export function listAdminSourceAuditLogs(sourceId: string) {
  return adminRequest<{ items: AdminAuditLog[] }>(`/sources/${sourceId}/audit-logs`);
}

export function updateAdminSourceStatus(sourceId: string, status: string, reason?: string) {
  return adminRequest<AdminSource>(`/sources/${sourceId}/status`, {
    method: "POST",
    body: JSON.stringify({ status, reason }),
  });
}

export function deleteAdminSource(sourceId: string, reason?: string) {
  const query = reason ? `?${new URLSearchParams({ reason }).toString()}` : "";
  return adminRequest<{ deleted: { id: string; title: string; status: string } }>(`/sources/${sourceId}${query}`, {
    method: "DELETE",
  });
}

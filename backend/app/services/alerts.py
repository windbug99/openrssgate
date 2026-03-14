from __future__ import annotations

from datetime import UTC, datetime


def summarize_alerts(
    *,
    failing_sources: int,
    stale_sources: int,
    latest_fetched_at: datetime | None,
    stale_sources_threshold: int,
    failing_sources_threshold: int,
    collector_lag_minutes: int,
) -> tuple[str, list[dict[str, object]]]:
    alerts: list[dict[str, object]] = []
    overall_status = "ok"

    if stale_sources >= stale_sources_threshold:
        alerts.append(
            {
                "code": "stale_sources_high",
                "severity": "warning",
                "message": f"Active stale source count is {stale_sources}.",
                "value": stale_sources,
            }
        )
        overall_status = "warning"

    if failing_sources >= failing_sources_threshold:
        alerts.append(
            {
                "code": "failing_sources_high",
                "severity": "warning",
                "message": f"Failing source count is {failing_sources}.",
                "value": failing_sources,
            }
        )
        overall_status = "warning"

    if latest_fetched_at is None:
        alerts.append(
            {
                "code": "collector_no_fetch_history",
                "severity": "critical",
                "message": "Collector has not recorded a successful fetch yet.",
                "value": None,
            }
        )
        overall_status = "critical"
    else:
        fetched_at = latest_fetched_at if latest_fetched_at.tzinfo else latest_fetched_at.replace(tzinfo=UTC)
        lag_minutes = int((datetime.now(UTC) - fetched_at).total_seconds() // 60)
        if lag_minutes >= collector_lag_minutes:
            alerts.append(
                {
                    "code": "collector_lagging",
                    "severity": "critical",
                    "message": f"Collector lag is {lag_minutes} minutes.",
                    "value": lag_minutes,
                }
            )
            overall_status = "critical"

    return overall_status, alerts

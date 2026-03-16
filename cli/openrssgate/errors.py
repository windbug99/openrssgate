from __future__ import annotations

import typer

from openrssgate.client import ApiError
from openrssgate.output import print_hint


def exit_with_api_error(message: str, *hints: str) -> typer.Exit:
    typer.secho(f"Error: {message}", fg=typer.colors.RED, err=True)
    for hint in hints:
        print_hint(hint)
    return typer.Exit(code=1)


def exit_for_list_error(exc: ApiError) -> typer.Exit:
    if exc.status_code == 422:
        return exit_with_api_error(
            str(exc),
            "Check your filter values for `--lang`, `--type`, `--category`, or `--tag`.",
            "Try `openrssgate list` first, then add one filter at a time.",
        )
    return exit_with_api_error(str(exc))


def exit_for_feeds_error(exc: ApiError, source_id: str | None) -> typer.Exit:
    if exc.status_code == 404 and source_id:
        return exit_with_api_error(
            "Source not found.",
            "`openrssgate feeds <source_id>` expects a source ID from `openrssgate list`.",
            f"Check the source ID and try `openrssgate list --keyword ...` before using `{source_id}` again.",
        )
    if exc.status_code == 422:
        return exit_with_api_error(
            str(exc),
            "Check `--since` format and filter values.",
            "Example: `openrssgate feeds --since 2026-03-01T00:00:00Z`",
        )
    return exit_with_api_error(str(exc))


def exit_for_feed_error(exc: ApiError) -> typer.Exit:
    if exc.status_code == 404:
        return exit_with_api_error(
            "Feed not found.",
            "`openrssgate feed <feed_id>` expects a feed ID, not a source ID.",
            "To list feeds for a source, use `openrssgate feeds <source_id>`.",
        )
    return exit_with_api_error(str(exc))


def exit_for_stats_error(exc: ApiError) -> typer.Exit:
    return exit_with_api_error(
        str(exc),
        "Try `openrssgate stats --json` if you want the raw API response when the service is available.",
    )


def exit_for_validate_error(exc: ApiError, rss_url: str) -> typer.Exit:
    if exc.status_code in {400, 404, 422}:
        return exit_with_api_error(
            str(exc),
            "`validate` expects a direct RSS or Atom feed URL.",
            f"If `{rss_url}` is a website URL, first find its actual feed URL.",
        )
    return exit_with_api_error(str(exc))

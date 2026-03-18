from __future__ import annotations

import typer

from openrssgate.client import ApiError, OpenRSSGateClient, format_json
from openrssgate.errors import exit_for_feed_error, exit_for_feeds_error
from openrssgate.output import print_empty, print_hint, print_identifier, print_label_value, print_title


def register(app: typer.Typer) -> None:
    @app.command("feeds", help="List recent feeds with optional source and metadata filters.")
    def feeds(
        source_id: str | None = typer.Argument(default=None, help="Optional source ID to scope feeds to a single source."),
        query: str | None = typer.Option(None, "--q", help="Filter by feed title keyword."),
        lang: str | None = typer.Option(None, "--lang", help="Filter by source language code such as en or ko."),
        source_type: str | None = typer.Option(None, "--type", help="Filter by source type such as blog or news."),
        category: str | None = typer.Option(default=None, help="Filter by source category."),
        tag: str | None = typer.Option(default=None, help="Filter by source tag."),
        since: str | None = typer.Option(default=None, help="Only include feeds published since an ISO-8601 timestamp."),
        page: int = typer.Option(default=1, min=1, help="Page number to fetch."),
        limit: int = typer.Option(default=20, min=1, max=100, help="Number of feeds per page. Maximum is 100."),
        json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON."),
    ) -> None:
        client = OpenRSSGateClient()
        try:
            payload = client.list_feeds(
                source_id=source_id,
                q=query,
                language=lang,
                type=source_type,
                category=category,
                tag=tag,
                since=since,
                page=page,
                limit=limit,
            )
        except ApiError as exc:
            raise exit_for_feeds_error(exc, source_id) from None

        if json_output:
            typer.echo(format_json(payload))
            return

        items = payload.get("items", [])
        if not items:
            print_empty("No feeds found.")
            if source_id:
                print_hint("Check the source ID with `openrssgate list`, or remove filters like `--q` and `--since`.")
            return

        for item in items:
            print_title(item["title"])
            print_identifier("id", item["id"])
            print_identifier("source", item["source_id"])
            print_label_value("published", item.get("published_at") or "-")
            print_label_value("url", item["feed_url"])

    @app.command("feed", help="Show detailed information for a single feed item.")
    def feed(
        feed_id: str = typer.Argument(..., help="Feed ID to retrieve."),
        json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON."),
    ) -> None:
        client = OpenRSSGateClient()
        try:
            payload = client.get_feed(feed_id)
        except ApiError as exc:
            raise exit_for_feed_error(exc) from None

        if json_output:
            typer.echo(format_json(payload))
            return

        source = payload.get("source", {})
        print_title(payload["title"])
        print_identifier("id", payload["id"])
        print_label_value("source", source.get("title") or payload.get("source_id"))
        print_identifier("source id", payload["source_id"])
        print_label_value("published", payload.get("published_at") or "-")
        print_label_value("author", payload.get("author") or "-")
        print_label_value("url", payload["feed_url"])
        print_label_value("site", source.get("site_url") or "-")
        print_label_value("summary", payload.get("summary") or "-")
        print_label_value("content", payload.get("content") or "-")

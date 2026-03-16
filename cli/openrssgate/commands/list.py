from __future__ import annotations

import typer

from openrssgate.client import ApiError, OpenRSSGateClient, format_json
from openrssgate.errors import exit_for_list_error
from openrssgate.output import print_empty, print_identifier, print_label_value, print_title


def register(app: typer.Typer) -> None:
    @app.command("list", help="List public sources with optional filters.")
    def list_sources(
        keyword: str | None = typer.Option(default=None, help="Filter by source title keyword."),
        lang: str | None = typer.Option(None, "--lang", help="Filter by language code such as en or ko."),
        source_type: str | None = typer.Option(None, "--type", help="Filter by source type such as blog or news."),
        category: str | None = typer.Option(default=None, help="Filter by source category."),
        tag: str | None = typer.Option(default=None, help="Filter by source tag."),
        page: int = typer.Option(default=1, min=1, help="Page number to fetch."),
        limit: int = typer.Option(default=20, min=1, max=100, help="Number of sources per page. Maximum is 100."),
        all_pages: bool = typer.Option(False, "--all", help="Fetch and print all remaining pages."),
        json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON."),
    ) -> None:
        client = OpenRSSGateClient()
        request_params = {
            "keyword": keyword,
            "language": lang,
            "type": source_type,
            "category": category,
            "tag": tag,
            "page": page,
            "limit": limit,
        }

        try:
            payload = client.list_sources(**request_params)
        except ApiError as exc:
            raise exit_for_list_error(exc) from None

        if all_pages:
            items = list(payload.get("items", []))
            current_page = int(payload.get("page", page) or page)
            total = int(payload.get("total", len(items)) or 0)

            while len(items) < total:
                current_page += 1
                try:
                    next_payload = client.list_sources(**{**request_params, "page": current_page})
                except ApiError as exc:
                    raise exit_for_list_error(exc) from None
                next_items = next_payload.get("items", [])
                if not next_items:
                    break
                items.extend(next_items)

            payload = {
                **payload,
                "items": items,
                "page": page,
                "limit": limit,
                "total": total,
            }

        if json_output:
            typer.echo(format_json(payload))
            return

        items = payload.get("items", [])
        if not items:
            print_empty("No sources found.")
            return

        for item in items:
            tags = ", ".join(item.get("tags", [])) or "-"
            categories = ", ".join(item.get("categories", [])) or "-"
            print_title(f"{item['title']} [{item.get('language') or '-'} / {item.get('type') or '-'} / {categories}]")
            print_identifier("id", item["id"])
            print_label_value("site", item["site_url"])
            print_label_value("rss", item["rss_url"])
            print_label_value("tags", tags)
            print_label_value("last fetched", item.get("last_fetched_at") or "-")

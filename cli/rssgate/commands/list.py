from __future__ import annotations

import typer

from rssgate.client import RSSGatewayClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("list")
    def list_sources(
        keyword: str | None = typer.Option(default=None),
        lang: str | None = typer.Option(None, "--lang"),
        category: str | None = typer.Option(default=None),
        tag: str | None = typer.Option(default=None),
        page: int = typer.Option(default=1, min=1),
        limit: int = typer.Option(default=20, min=1, max=100),
        json_output: bool = typer.Option(False, "--json"),
    ) -> None:
        client = RSSGatewayClient()
        payload = client.list_sources(
            keyword=keyword,
            language=lang,
            category=category,
            tag=tag,
            page=page,
            limit=limit,
        )

        if json_output:
            typer.echo(format_json(payload))
            return

        items = payload.get("items", [])
        if not items:
            typer.echo("No sources found.")
            return

        for item in items:
            tags = ", ".join(item.get("tags", [])) or "-"
            typer.echo(f"{item['title']} [{item.get('language') or '-'} / {item.get('category') or '-'}]")
            typer.echo(f"  id: {item['id']}")
            typer.echo(f"  site: {item['site_url']}")
            typer.echo(f"  rss: {item['rss_url']}")
            typer.echo(f"  tags: {tags}")
            typer.echo(f"  last fetched: {item.get('last_fetched_at') or '-'}")

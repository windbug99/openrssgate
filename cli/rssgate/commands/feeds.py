from __future__ import annotations

import typer

from rssgate.client import RSSGatewayClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("feeds")
    def feeds(
        source_id: str | None = typer.Argument(default=None),
        lang: str | None = typer.Option(None, "--lang"),
        since: str | None = typer.Option(default=None),
        page: int = typer.Option(default=1, min=1),
        limit: int = typer.Option(default=20, min=1, max=100),
        json_output: bool = typer.Option(False, "--json"),
    ) -> None:
        client = RSSGatewayClient()
        payload = client.list_feeds(
            source_id=source_id,
            language=lang,
            since=since,
            page=page,
            limit=limit,
        )

        if json_output:
            typer.echo(format_json(payload))
            return

        items = payload.get("items", [])
        if not items:
            typer.echo("No feeds found.")
            return

        for item in items:
            typer.echo(item["title"])
            typer.echo(f"  id: {item['id']}")
            typer.echo(f"  source: {item['source_id']}")
            typer.echo(f"  published: {item.get('published_at') or '-'}")
            typer.echo(f"  url: {item['feed_url']}")

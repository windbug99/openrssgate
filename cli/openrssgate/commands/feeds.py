from __future__ import annotations

import typer

from openrssgate.client import OpenRSSGateClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("feeds")
    def feeds(
        source_id: str | None = typer.Argument(default=None),
        query: str | None = typer.Option(None, "--q"),
        lang: str | None = typer.Option(None, "--lang"),
        source_type: str | None = typer.Option(None, "--type"),
        category: str | None = typer.Option(default=None),
        tag: str | None = typer.Option(default=None),
        since: str | None = typer.Option(default=None),
        page: int = typer.Option(default=1, min=1),
        limit: int = typer.Option(default=20, min=1, max=100),
        json_output: bool = typer.Option(False, "--json"),
    ) -> None:
        client = OpenRSSGateClient()
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

    @app.command("feed")
    def feed(
        feed_id: str = typer.Argument(...),
        json_output: bool = typer.Option(False, "--json"),
    ) -> None:
        client = OpenRSSGateClient()
        payload = client.get_feed(feed_id)

        if json_output:
            typer.echo(format_json(payload))
            return

        source = payload.get("source", {})
        typer.echo(payload["title"])
        typer.echo(f"  id: {payload['id']}")
        typer.echo(f"  source: {source.get('title') or payload.get('source_id')}")
        typer.echo(f"  source id: {payload['source_id']}")
        typer.echo(f"  published: {payload.get('published_at') or '-'}")
        typer.echo(f"  url: {payload['feed_url']}")
        typer.echo(f"  site: {source.get('site_url') or '-'}")

from __future__ import annotations

import typer

from openrssgate.client import OpenRSSGateClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("validate")
    def validate(
        rss_url: str = typer.Argument(...),
        lang: str | None = typer.Option(None, "--lang"),
        source_type: str | None = typer.Option(None, "--type"),
        json_output: bool = typer.Option(False, "--json"),
    ) -> None:
        client = OpenRSSGateClient()
        payload = client.validate_source(rss_url, language=lang, type=source_type, categories=[], tags=[])

        if json_output:
            typer.echo(format_json(payload))
            return

        typer.echo(f"valid: {payload['valid']}")
        typer.echo(f"title: {payload.get('title') or '-'}")
        typer.echo(f"site: {payload.get('site_url') or '-'}")
        typer.echo(f"rss: {payload['rss_url']}")
        typer.echo(f"language: {payload.get('language') or '-'}")
        typer.echo(f"type: {payload.get('type') or '-'}")
        typer.echo(f"feed format: {payload.get('feed_format') or '-'}")

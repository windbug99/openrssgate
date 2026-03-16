from __future__ import annotations

import typer

from openrssgate.client import OpenRSSGateClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("validate", help="Validate an RSS or Atom URL without registering it.")
    def validate(
        rss_url: str = typer.Argument(..., help="RSS or Atom URL to validate."),
        lang: str | None = typer.Option(None, "--lang", help="Optional language override to include in validation."),
        source_type: str | None = typer.Option(None, "--type", help="Optional source type override to include in validation."),
        json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON."),
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

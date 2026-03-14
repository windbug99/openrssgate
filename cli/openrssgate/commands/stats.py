from __future__ import annotations

import typer

from openrssgate.client import OpenRSSGateClient, format_json


def register(app: typer.Typer) -> None:
    @app.command("stats")
    def stats(json_output: bool = typer.Option(False, "--json")) -> None:
        client = OpenRSSGateClient()
        payload = client.get_stats()

        if json_output:
            typer.echo(format_json(payload))
            return

        typer.echo(f"total sources: {payload['total_sources']}")
        typer.echo(f"active sources: {payload['active_sources']}")
        typer.echo(f"total feeds: {payload['total_feeds']}")
        typer.echo(f"feeds last 24h: {payload['feeds_last_24h']}")

from __future__ import annotations

import typer

from openrssgate.client import ApiError, OpenRSSGateClient, format_json
from openrssgate.errors import exit_for_stats_error
from openrssgate.output import print_stat


def register(app: typer.Typer) -> None:
    @app.command("stats", help="Show aggregate counts for sources and feeds.")
    def stats(json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON.")) -> None:
        client = OpenRSSGateClient()
        try:
            payload = client.get_stats()
        except ApiError as exc:
            raise exit_for_stats_error(exc) from None

        if json_output:
            typer.echo(format_json(payload))
            return

        print_stat("total sources", payload["total_sources"])
        print_stat("active sources", payload["active_sources"])
        print_stat("total feeds", payload["total_feeds"])
        print_stat("feeds last 24h", payload["feeds_last_24h"])

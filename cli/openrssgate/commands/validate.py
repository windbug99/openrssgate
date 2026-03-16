from __future__ import annotations

import typer

from openrssgate.client import ApiError, OpenRSSGateClient, format_json
from openrssgate.errors import exit_for_validate_error
from openrssgate.output import print_label_value, print_status_value, print_title


def register(app: typer.Typer) -> None:
    @app.command("validate", help="Validate an RSS or Atom URL without registering it.")
    def validate(
        rss_url: str = typer.Argument(..., help="RSS or Atom URL to validate."),
        lang: str | None = typer.Option(None, "--lang", help="Optional language override to include in validation."),
        source_type: str | None = typer.Option(None, "--type", help="Optional source type override to include in validation."),
        json_output: bool = typer.Option(False, "--json", help="Print the raw API response as JSON."),
    ) -> None:
        client = OpenRSSGateClient()
        try:
            payload = client.validate_source(rss_url, language=lang, type=source_type, categories=[], tags=[])
        except ApiError as exc:
            raise exit_for_validate_error(exc, rss_url) from None

        if json_output:
            typer.echo(format_json(payload))
            return

        print_title("Validation result")
        print_status_value("valid", payload["valid"])
        print_label_value("title", payload.get("title") or "-")
        print_label_value("site", payload.get("site_url") or "-")
        print_label_value("rss", payload["rss_url"])
        print_label_value("language", payload.get("language") or "-")
        print_label_value("type", payload.get("type") or "-")
        print_label_value("feed format", payload.get("feed_format") or "-")

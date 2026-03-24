from __future__ import annotations

import typer
from openrssgate.client import OpenRSSGateClient, format_json

app = typer.Typer(name="register", help="Register a new RSS source.")

@app.callback(invoke_without_command=True)
def register(
    ctx: typer.Context,
    rss_url: str = typer.Argument(..., help="The RSS URL to register."),
    language: str | None = typer.Option(None, "--language", "-l", help="The language code (e.g. ko, en)."),
    type: str | None = typer.Option(None, "--type", "-t", help="The source type (e.g. blog, tech)."),
    categories: list[str] = typer.Option(None, "--category", "-c", help="One or more categories."),
    tags: list[str] = typer.Option(None, "--tag", "-g", help="One or more tags."),
) -> None:
    """Register a new source."""
    if ctx.invoked_subcommand is not None:
        return

    client = OpenRSSGateClient()
    typer.echo(f"Registering {rss_url}...")
    
    payload = {
        "rss_url": rss_url,
        "language": language,
        "type": type,
        "categories": categories,
        "tags": tags,
    }
    
    # We'll use the /sources POST endpoint
    result = client._request("/sources", method="POST", json_body=payload)
    typer.echo(format_json(result))

def register_command(parent: typer.Typer) -> None:
    parent.add_typer(app)

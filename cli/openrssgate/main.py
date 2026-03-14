from __future__ import annotations

import typer

from openrssgate.client import ApiError
from openrssgate.commands import feeds, list as list_command, stats, validate

app = typer.Typer(
    add_completion=False,
    no_args_is_help=True,
    help="Read-only CLI for querying RSS Gateway sources and feeds.",
)

list_command.register(app)
feeds.register(app)
stats.register(app)
validate.register(app)


@app.callback()
def main() -> None:
    pass


def _run() -> None:
    try:
        app()
    except ApiError as exc:
        typer.echo(f"Error: {exc}", err=True)
        raise typer.Exit(code=1) from exc


if __name__ == "__main__":
    _run()

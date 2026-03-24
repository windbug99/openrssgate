from __future__ import annotations

import sys

import typer

from openrssgate.client import ApiError
from openrssgate.commands import feeds, list as list_command, stats, validate, register

app = typer.Typer(
    add_completion=False,
    no_args_is_help=True,
    help="Read-only CLI for querying OpenRSSGate sources, feeds, stats, and source validation.",
)

list_command.register(app)
feeds.register(app)
stats.register(app)
validate.register(app)
register.register_command(app)


@app.callback()
def main() -> None:
    pass


def _run() -> int:
    try:
        app()
    except ApiError as exc:
        typer.echo(f"Error: {exc}", err=True)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(_run())

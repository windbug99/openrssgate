from __future__ import annotations

import typer


def print_title(value: str) -> None:
    typer.secho(value, fg=typer.colors.BRIGHT_WHITE, bold=True)


def print_label_value(label: str, value: object) -> None:
    typer.secho(f"  {label}: ", fg=typer.colors.BRIGHT_BLACK, nl=False)
    typer.echo(value)


def print_identifier(label: str, value: object) -> None:
    typer.secho(f"  {label}: ", fg=typer.colors.BRIGHT_BLACK, nl=False)
    typer.secho(str(value), fg=typer.colors.CYAN, bold=True)


def print_status_value(label: str, value: bool) -> None:
    typer.secho(f"  {label}: ", fg=typer.colors.BRIGHT_BLACK, nl=False)
    typer.secho(str(value).lower(), fg=typer.colors.GREEN if value else typer.colors.RED, bold=True)


def print_hint(message: str) -> None:
    typer.secho(f"Hint: {message}", fg=typer.colors.BRIGHT_BLACK, err=True)


def print_empty(message: str) -> None:
    typer.secho(message, fg=typer.colors.BRIGHT_BLACK)


def print_stat(label: str, value: object) -> None:
    typer.secho(f"{label}: ", fg=typer.colors.BRIGHT_BLACK, nl=False)
    typer.secho(str(value), fg=typer.colors.BRIGHT_WHITE, bold=True)

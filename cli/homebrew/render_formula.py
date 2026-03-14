from __future__ import annotations

import argparse
from pathlib import Path


ROOT = Path(__file__).resolve().parent
TEMPLATE_PATH = ROOT / "Formula" / "openrssgate.rb.template"
OUTPUT_PATH = ROOT / "Formula" / "openrssgate.rb"


def render_formula(*, url: str, sha256: str, output_path: Path) -> None:
    template = TEMPLATE_PATH.read_text(encoding="utf-8")
    rendered = (
        template.replace("__OPENRSSGATE_SDIST_URL__", url)
        .replace("__OPENRSSGATE_SDIST_SHA256__", sha256)
    )
    output_path.write_text(rendered, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Render the OpenRSSGate Homebrew formula from the local template.")
    parser.add_argument("--url", required=True, help="Release source archive URL")
    parser.add_argument("--sha256", required=True, help="SHA256 for the source archive")
    parser.add_argument(
        "--output",
        default=str(OUTPUT_PATH),
        help=f"Output formula path (default: {OUTPUT_PATH})",
    )
    args = parser.parse_args()

    render_formula(url=args.url, sha256=args.sha256, output_path=Path(args.output))
    print(f"Rendered Homebrew formula to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

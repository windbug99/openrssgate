from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

from render_formula import OUTPUT_PATH, render_formula


def sha256_for_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compute the SHA256 for a release archive and render the OpenRSSGate Homebrew formula."
    )
    parser.add_argument("--archive", required=True, help="Path to the sdist or release tarball")
    parser.add_argument("--url", required=True, help="Public URL for the same archive")
    parser.add_argument(
        "--output",
        default=str(OUTPUT_PATH),
        help=f"Output formula path (default: {OUTPUT_PATH})",
    )
    args = parser.parse_args()

    archive_path = Path(args.archive).expanduser().resolve()
    if not archive_path.is_file():
        raise SystemExit(f"Archive not found: {archive_path}")

    sha256 = sha256_for_file(archive_path)
    output_path = Path(args.output)
    render_formula(url=args.url, sha256=sha256, output_path=output_path)

    print(f"Archive: {archive_path}")
    print(f"SHA256:  {sha256}")
    print(f"Formula: {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

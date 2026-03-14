from __future__ import annotations

import argparse
import shutil
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Copy the rendered OpenRSSGate Homebrew formula into a tap checkout.")
    parser.add_argument("--formula", required=True, help="Path to the rendered openrssgate.rb formula")
    parser.add_argument("--tap-repo", required=True, help="Path to the checked out tap repository")
    parser.add_argument(
        "--formula-dir",
        default="Formula",
        help="Formula directory relative to the tap repository (default: Formula)",
    )
    args = parser.parse_args()

    formula_path = Path(args.formula).expanduser().resolve()
    tap_repo = Path(args.tap_repo).expanduser().resolve()
    target_dir = tap_repo / args.formula_dir
    target_path = target_dir / "openrssgate.rb"

    if not formula_path.is_file():
        raise SystemExit(f"Rendered formula not found: {formula_path}")
    if not tap_repo.is_dir():
        raise SystemExit(f"Tap repository not found: {tap_repo}")

    target_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(formula_path, target_path)
    print(f"Copied {formula_path} -> {target_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

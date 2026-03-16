# GitHub Actions Release

The CLI release workflow is defined in [.github/workflows/release-openrssgate-cli.yml](/Users/tomato/cursor/openrssgate/.github/workflows/release-openrssgate-cli.yml).
The Homebrew tap publish workflow is defined in [.github/workflows/publish-openrssgate-homebrew.yml](/Users/tomato/cursor/openrssgate/.github/workflows/publish-openrssgate-homebrew.yml).

## Trigger modes

- Push a tag like `openrssgate-cli-v0.1.0`
- Run the workflow manually with `version=0.1.0`

## What the workflow does

1. Verifies the CLI version across `pyproject.toml`, `setup.py`, and `openrssgate/__init__.py`
2. Runs CLI tests
3. Builds sdist and wheel
4. Publishes the package to PyPI
5. Generates a Homebrew formula artifact from the published sdist filename

## Required GitHub configuration

- PyPI trusted publishing enabled for this repository
  or a PyPI token-based setup compatible with `pypa/gh-action-pypi-publish`
- Repository permission to use `id-token: write`

## After the workflow finishes

The workflow uploads two artifacts:

- `openrssgate-cli-dist`
- `openrssgate-homebrew-formula`

The Homebrew artifact is the rendered `openrssgate.rb` starter formula. You still need to run `brew update-python-resources` against the final formula in the tap repository before publishing it.

For releases that should expose the preferred `org` command, verify that:

- `cli/pyproject.toml` contains `org = "openrssgate.main:_run"` under `[project.scripts]`
- the Homebrew formula test uses `#{bin}/org --help`
- install verification is performed with `org --help` and `org list`

## Homebrew tap automation

The tap publish workflow expects these repository secrets:

- `OPENRSSGATE_HOMEBREW_TAP_REPOSITORY`
  Example: `owner/homebrew-tap`
- `OPENRSSGATE_HOMEBREW_TAP_TOKEN`
  A token with permission to push to the tap repository

The workflow is manually triggered with:

- `version`
- `formula_artifact_run_id`

It downloads the previously generated `openrssgate-homebrew-formula` artifact and commits it into the tap repository.

## Recommended release verification

After both workflows succeed:

```bash
pipx install openrssgate
org --help
org list
```

```bash
brew tap <owner>/tap
brew install openrssgate
org --help
org list
```

`openrssgate` can remain as a compatibility alias, but `org` should be treated as the primary acceptance check.

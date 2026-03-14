# PyPI Release

## Package target

- PyPI package name: `openrssgate`
- Console command: `openrssgate`

## Pre-release checklist

1. Update `version` in `pyproject.toml`, `setup.py`, and `openrssgate/__init__.py`
2. Run tests
3. Build sdist and wheel
4. Upload to PyPI
5. Verify `pipx install openrssgate`

## Commands

```bash
cd /Users/tomato/cursor/openrssgate/cli
python -m pip install -U build twine
python -m build
python -m twine check dist/*
python -m twine upload dist/*
```

GitHub Actions automation is documented in [GITHUB_ACTIONS.md](/Users/tomato/cursor/openrssgate/cli/GITHUB_ACTIONS.md).
External account and repository setup is documented in [EXTERNAL_SETUP.md](/Users/tomato/cursor/openrssgate/cli/EXTERNAL_SETUP.md).

## Install verification

```bash
pipx install openrssgate
openrssgate --help
openrssgate list
```

## Homebrew release

Homebrew distribution should be published through a custom tap. The repository-side template lives at [homebrew/Formula/openrssgate.rb.template](/Users/tomato/cursor/openrssgate/cli/homebrew/Formula/openrssgate.rb.template).

### Tap release flow

1. Publish the PyPI release or GitHub source tarball for the target version
2. Build or download the exact source archive that will be referenced by the formula
3. Run `python homebrew/prepare_formula_release.py --archive <local-archive> --url <sdist-url>`
4. Copy the generated `homebrew/Formula/openrssgate.rb` to the tap repository
5. If dependencies changed since the last release, regenerate the Homebrew `resource` blocks and sync them back into [homebrew/Formula/openrssgate.rb.template](/Users/tomato/cursor/openrssgate/cli/homebrew/Formula/openrssgate.rb.template)
6. Commit the finished formula to the tap repository

If you want to automate the tap update, configure the Homebrew workflow described in [GITHUB_ACTIONS.md](/Users/tomato/cursor/openrssgate/cli/GITHUB_ACTIONS.md).

### Install verification

```bash
brew tap windbug99/homebrew-tap
brew install openrssgate
openrssgate --help
openrssgate list
```

## Current verified release

- PyPI: `openrssgate==0.1.1`
- Homebrew tap: `windbug99/homebrew-tap`

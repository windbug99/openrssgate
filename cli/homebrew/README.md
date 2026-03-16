# Homebrew Tap

This directory contains the template used to publish `openrssgate` to a custom Homebrew tap.

## Expected install flow

```bash
brew tap <owner>/tap
brew install openrssgate
org --help
org list
```

`brew install openrssgate` installs the package name, while the preferred runtime command is `org`.
The legacy `openrssgate` command remains available as a backward-compatible alias.

## Release inputs

Before publishing the formula, fill in these values in `Formula/openrssgate.rb.template`:

- `__OPENRSSGATE_SDIST_URL__`
- `__OPENRSSGATE_SDIST_SHA256__`

The expected source artifact is the PyPI sdist or a GitHub release tarball for the same version.

You can render the starting formula automatically:

```bash
cd /Users/tomato/cursor/openrssgate/cli/homebrew
python render_formula.py \
  --url https://files.pythonhosted.org/packages/source/o/openrssgate/openrssgate-0.1.0.tar.gz \
  --sha256 <sha256>
```

If you already have the release archive locally, you can compute the hash and render the formula in one step:

```bash
cd /Users/tomato/cursor/openrssgate/cli/homebrew
python prepare_formula_release.py \
  --archive /path/to/openrssgate-0.1.0.tar.gz \
  --url https://files.pythonhosted.org/packages/source/o/openrssgate/openrssgate-0.1.0.tar.gz
```

## Resource generation

The template already includes the Python dependency `resource` blocks required for the current pinned CLI dependencies.

If the CLI dependency set changes, regenerate the resource blocks against a real tap formula:

```bash
brew tap <owner>/tap
cp Formula/openrssgate.rb /opt/homebrew/Library/Taps/<owner>/homebrew-tap/Formula/openrssgate.rb
brew update-python-resources /opt/homebrew/Library/Taps/<owner>/homebrew-tap/Formula/openrssgate.rb
```

Then sync the updated `resource` blocks back into `Formula/openrssgate.rb.template` before the next release.

## Release verification for `org`

After updating the tap formula to a version that includes the `org` script entrypoint:

```bash
brew update
brew upgrade openrssgate
which org
org --help
org list
```

If you are testing from a clean machine:

```bash
brew tap <owner>/tap
brew install openrssgate
which org
org --help
org list
```

Expected result:

- `which org` resolves to the Homebrew-installed binary
- `org --help` prints the CLI help output
- `org list` returns source data from the configured API

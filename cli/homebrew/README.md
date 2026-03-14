# Homebrew Tap

This directory contains the template used to publish `openrssgate` to a custom Homebrew tap.

## Expected install flow

```bash
brew tap <owner>/tap
brew install openrssgate
```

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

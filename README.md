# homebrew-nodus

Official Homebrew tap for Nodus.

## User install

Preferred one-command install:

```bash
brew install nodus-rs/nodus/nodus
```

Equivalent two-step install:

```bash
brew tap nodus-rs/nodus
brew install nodus
```

## Maintainer release flow

After publishing `nodus` release assets on GitHub, update the tap with:

```bash
./scripts/update-formula.sh v0.3.4
```

What this does:

- fetches the published release checksums from GitHub
- updates `Formula/nodus.rb` to the new current version
- creates a versioned formula like `Formula/nodus@0.3.3.rb` when bumping from the previous current version
- keeps Linux arm64 support when that release asset exists
- falls back to no Linux arm64 support when a release does not publish that asset

## Validate locally

```bash
ruby -c Formula/nodus.rb
brew install --formula ./Formula/nodus.rb
brew test nodus
```

If a versioned formula was created, you can also validate it:

```bash
ruby -c Formula/nodus@0.3.3.rb
```

## Notes

- The formula installs prebuilt GitHub Release archives instead of compiling with Rust.
- `generate_completions_from_executable` installs shell completions from `nodus completion`.
- Homebrew resolves `brew tap nodus-rs/nodus` to `https://github.com/nodus-rs/homebrew-nodus`.

# environment-setup

Scripts and config to set up or update my macOS development machine.

## Install

```bash
git clone <this-repo> ~/environment-setup
cd ~/environment-setup
./bin/install
```

The repo can live anywhere; the scripts resolve their own location.

## What gets installed

See [docs/specification.md](docs/specification.md). It is the source of truth: everything the
scripts do should be listed there, and undecided items are tracked as open questions.

## Layout

- `bin/` — `install` (and later `update`)
- `config/` — `Brewfile` and app config
- `home/` — dotfiles symlinked into `~` (planned)
- `macos/` — macOS defaults and shortcuts (planned)
- `docs/` — specification

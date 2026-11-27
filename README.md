# environment-setup

Scripts and config to set up or update my macOS development machine.

## Install

```bash
git clone https://github.com/wafto/environment-setup ~/environment-setup
cd ~/environment-setup
./bin/install
```

The repo can live anywhere; the scripts resolve their own location.

## What gets installed

See [docs/specification.md](docs/specification.md). It is the source of truth: everything the
scripts do should be listed there, and undecided items are tracked as open questions.

## Layout

- `bin/` — `install`, plus helpers `xdebug` and `exclude-from-spotlight` (`update` and `migrate-from-herd` planned)
- `config/` — `Brewfile`, oh-my-posh theme, Ghostty, Zed and VS Code config
- `home/` — dotfiles symlinked into `~` (`.zshrc`, `.aliases`, `.exports`, `.functions`, `.gitconfig`)
- `macos/` — macOS defaults
- `docs/` — specification

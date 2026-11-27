# Environment Setup Specification

This file is the source of truth for what `bin/install` and `bin/update` do on my Mac.
Each section lists what gets **installed**, what is deliberately **not installed** (with
a reason), and **open questions** still to decide. Scripts and config should only ever
implement what is written here.

Status legend:
- `[x]` decided: `bin/install` / `bin/update` must do this.
- `[ ]` not decided yet: do not implement.
- `[?]` open question that needs an answer before it can be decided.

---

## 1. Goals and non-goals

**Goals**
- One command (`./bin/install`) sets up a fresh Mac; one command (`./bin/update`) keeps it current.
- Idempotent: safe to re-run at any time without duplicating config or breaking things.
- Apple Silicon first (`/opt/homebrew`).
- The repo can live anywhere; scripts resolve their own location. `~/environment-setup` is the suggested clone path.
- No secrets in the repo (git identity, tokens, SSH keys stay local/untracked).
- Never destroy existing config: files replaced by symlinks are backed up first (§10).

**Non-goals**
- Installing Xcode.app itself (too large; install manually from the App Store if needed).
- App Store apps (no `mas`); they are installed manually.
- Flutter SDK (set up manually, see §5).
- Claude Code configuration (`~/.claude` stays outside this repo).

---

## 2. Repository layout

```
bin/            executable entry points (install, update, migrate-from-herd) and helpers
                (xdebug, exclude-from-spotlight)
config/         Brewfile and app config (ghostty, zed, vscode, oh-my-posh theme, ...)
home/           dotfiles symlinked into ~ (.zshrc, .aliases, .gitconfig, ...)
macos/          macOS defaults (set-defaults.sh)
docs/           this specification and other notes
```

---

## 3. Bootstrap

- [x] macOS check: abort if not Darwin
- [x] Xcode Command Line Tools: `xcode-select --install` if missing
- [x] Homebrew: official installer, `/opt/homebrew`
- [x] `brew shellenv` in `~/.zprofile`, only appended if not already present
- [x] `brew bundle` from `config/Brewfile`

---

## 4. CLI tools (Homebrew formulae)

- [x] git
- [x] gh — GitHub CLI
- [x] jq
- [x] wget
- [x] awscli
- [x] uv — Python toolchain
- [x] go
- [x] cmake
- [x] ninja
- [x] sevenzip
- [x] git-filter-repo
- [x] zsh-autosuggestions
- [x] oh-my-posh (tap `jandedobbeleer/oh-my-posh`)
- [x] mole
- [x] shellcheck — lint the scripts in this repo
- [x] PHP and extensions (see §5; Composer is not a brew formula here)
- [x] fnm (see §5)

---

## 5. Languages and runtimes

### PHP
All PHP versions and extensions come from the `shivammathur/php` and
`shivammathur/extensions` taps, declared in the Brewfile (no pecl).

- [x] `shivammathur/php/php@8.5` (default; keg-only, so `bin/install` runs `brew link --force --overwrite php@8.5`
  before installing Composer and Valet)
- [x] `shivammathur/php/php@8.4`
- [x] `shivammathur/php/php@8.3`
- [x] Extensions for each version above (`<ext>@8.5`, `<ext>@8.4`, `<ext>@8.3`):
  `phpredis`, `xdebug`, `imagick`, `memcached`, `pcov`
- [x] Default: `pcov` enabled, `xdebug` installed but disabled. `xdebug-on` / `xdebug-off`
  shell functions toggle it for the active PHP version.
- [x] Composer via the official installer (checksum verified) into `/opt/homebrew/bin/composer`,
  not the brew formula: that formula depends on core `php`, which would be linked over `php@8.5`.
  `bin/update` runs `composer self-update`.
- [x] Global Composer packages: `laravel/installer`, `laravel/pint`, `laravel/valet`,
  `laravel/envoy`, `spatie/phpunit-watcher`, `cpx/cpx`
- [x] `valet install` (after Herd is removed, see §6); switch versions per project with `valet use php@8.x`

Note: the tap's unversioned `php` formula already tracks the newest release (8.6), so the
Brewfile always uses explicit `php@8.x` names.

### Node
- [x] `fnm` via brew, `fnm install --lts`, `fnm default lts-latest`
- [x] `eval "$(fnm env --use-on-cd)"` in `.zshrc`
- No global npm packages; use `npx` as needed.

### Python
- [x] `uv` (manages Python versions and tools; no pyenv)

### Go
- [x] `go` via brew

### Mobile
- [x] Android Studio — installed manually (bundles its own JDK)
- [x] `ANDROID_HOME` and platform-tools on `PATH` in `.exports`
- Flutter: installed manually, not managed by this repo. iOS builds also need Xcode.app
  and CocoaPods, both installed manually.

---

## 6. Herd migration (one-time, `bin/migrate-from-herd`)

Herd currently provides `php`, `composer` and Node (via its own nvm), and its `bin`
directory comes first in `PATH`. This only applies to the current machine; a fresh Mac
has no Herd, so it lives in a separate script, not in `bin/install`.

- [x] Run **before** `valet install` (Herd and Valet both claim ports 80/443 and `.test` DNS)
- [x] Quit and uninstall Herd (`/Applications/Herd.app`, `~/Library/Application Support/Herd`)
- [x] Herd's `PATH`, `HERD_PHP_*_INI_SCAN_DIR` and nvm lines disappear when `~/.zshrc` is
  replaced by the repo's version (the old file is backed up, §10)
- [x] Print a list of sites to re-link with `valet link` / `valet park`

---

## 7. Databases and services

- [x] DBngin (installed manually)
- [x] TablePlus as GUI client
- [x] Docker Desktop for anything else (installed manually)

---

## 8. GUI applications (Homebrew casks)

- [x] ghostty — primary terminal
- [x] claude-code
- [x] tableplus
- [x] zoom
- [x] brave-browser
- [x] codexbar

Installed manually (downloaded from the vendor), not managed by the Brewfile; listed in the
README: Zed, Visual Studio Code, Claude, ChatGPT, Docker Desktop, DBngin, Postman, Figma,
Obsidian, Slack, WhatsApp, Google Chrome, AppCleaner, The Unarchiver, VLC, Tailscale,
Android Studio.

---

## 9. Fonts

- [x] font-fira-code
- [x] font-jetbrains-mono-nerd-font (needed by oh-my-posh glyphs)

---

## 10. Shell configuration

Shell: macOS zsh + oh-my-posh prompt + zsh-autosuggestions. No Oh My Zsh.

- [x] Symlink helper: if the target exists and is not already the correct symlink, move it
  to `~/.environment-setup-backup/<timestamp>/` before linking
- [x] `home/.zshrc` → `~/.zshrc`; it resolves `DOTFILES_DIR` through its own symlink and
  provides what Oh My Zsh used to: history settings, `compinit`, case-insensitive completion
- [x] `home/.aliases`, `home/.exports`, `home/.functions` sourced from `.zshrc`
  (contents of the current `~/.alias` and the git aliases actually used move into `.aliases`)
- [x] oh-my-posh theme: current `~/.ZSHThemes.json` moves to `config/oh-my-posh/theme.omp.json`
- [x] `~/.hushlogin` (suppress "Last login" banner)
- [ ] Optional untracked `~/.zshrc.local` sourced last for machine-specific config

---

## 11. Git configuration

- [x] `home/.gitconfig` → `~/.gitconfig` (aliases, default branch `main`, pull rebase, etc.)
- [x] Identity (name/email) in untracked `~/.gitconfig.local`, included from `.gitconfig`;
  the installer prompts for it on first run
- [x] `home/.global-gitignore` → `~/.global-gitignore` (`.DS_Store`, `.idea/`, `.vscode/`)

---

## 12. Editor and terminal configuration

- [x] `config/ghostty/config` → `~/.config/ghostty/config`. Ghostty also loads
  `~/Library/Application Support/com.mitchellh.ghostty/config` (and it overrides the XDG one),
  so the installer backs that file up and removes it.
- [x] `config/zed/settings.json`, `config/zed/keymap.json` → `~/.config/zed/`
- [x] `config/vscode/settings.json`, `config/vscode/keybindings.json` →
  `~/Library/Application Support/Code/User/`
- [x] `config/vscode/extensions.txt` installed with `code --install-extension`
  (generated from `code --list-extensions`)

---

## 13. macOS defaults

`macos/set-defaults.sh`, run by the installer (asks first). Some settings need a
logout/restart to take effect; the script says so at the end.

- [x] Screenshots: save to `~/Pictures/Screenshots`, PNG, no shadow
- [x] Trackpad: tap to click
- [x] Spotlight: `bin/exclude-from-spotlight` drops a `.metadata_never_index` marker into
  `node_modules`, `vendor` and `.git` under `~/Development`, and into DBngin's data directory
  (`~/Library/Application Support/com.tinyapp.DBngin`). The marker is in the global gitignore.
- [ ] Finder: show hidden files, path bar, status bar, extensions
- [ ] Dock: autohide, size, no recent apps
- [ ] Keyboard: fast key repeat, short delay, disable press-and-hold
- [ ] Custom app shortcuts via `defaults write <domain> NSUserKeyEquivalents`

---

## 14. Update flow (`bin/update`)

- [x] `git pull` this repo
- [x] `brew update && brew upgrade && brew bundle && brew cleanup`
- [x] `brew bundle cleanup` (report only, no `--force`): list installed items missing from the Brewfile
- [x] `fnm install --lts` and set it as default
- [x] `composer self-update && composer global update`
- [x] `valet restart` (picks up upgraded PHP versions)
- [x] `softwareupdate -l` (report only, never installs)

---

## 15. Not installing

Rejected on purpose; the scripts ignore these.

| Item | Reason |
|---|---|
| Oh My Zsh | Only used for git aliases; oh-my-posh draws the prompt |
| Herd | Replaced by Homebrew PHP + Valet (§6) |
| nvm | Replaced by fnm |
| pecl | Replaced by `shivammathur/extensions` formulae |
| pyenv, pyenv-virtualenv | Replaced by uv |
| zsh (brew) | macOS zsh is recent enough |
| openjdk, openjdk@17 | Android Studio bundles its own JDK |
| ruby (brew) | Not needed (CocoaPods is manual) |
| wxwidgets, libusb | One-off project dependencies |
| pkhex-cli, opencode | Not needed |
| iterm2 | Ghostty is the terminal |
| hiddenbar, ollama, caffeinated, wispr-flow, amazon-chime | Not needed |
| flutter, fvm | Flutter is set up manually |
| mas | App Store apps are installed manually |
| Global npm packages | Use `npx` |
| Mackup / settings sync | Out of scope |
| Steam, calibre, qbittorrent, transmission, tor-browser, sweet-home3d | Personal; install manually if wanted |
| GarageBand, iMovie, Keynote, Pages, Numbers, TestFlight, Xcode | App Store, installed manually |

---

## 16. Open questions

- [ ] Finder, Dock and keyboard defaults (§13): tick to enable
- [ ] Custom app shortcuts (§13): which shortcuts
- [ ] `~/.zshrc.local` (§10)

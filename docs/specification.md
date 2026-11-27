# Environment Setup Specification

This file is the source of truth for what `bin/install` and `bin/update` do on my Mac.
Each section lists what gets **installed**, what is deliberately **not installed** (with
a reason), and **open questions** still to decide. Scripts and config should only ever
implement what is written here.

Status legend: `[x]` implemented, `[ ]` planned, `[?]` undecided.

---

## 1. Goals and non-goals

**Goals**
- One command (`./bin/install`) sets up a fresh Mac; one command (`./bin/update`) keeps it current.
- Idempotent: safe to re-run at any time without duplicating config or breaking things.
- Apple Silicon first (`/opt/homebrew`).
- No secrets in the repo (git identity, tokens, SSH keys stay local/untracked).

**Non-goals**
- Installing Xcode.app itself (too large; install manually from the App Store if needed).

---

## 2. Repository layout

```
bin/            executable entry points (install, update, helpers)
config/         Brewfile and app config (ghostty, zed, oh-my-posh theme, ...)
home/           dotfiles symlinked into ~ (.zshrc, .aliases, .gitconfig, ...)
macos/          macOS defaults and keyboard shortcuts (set-defaults.sh)
docs/           this specification and other notes
```

---

## 3. Bootstrap

| Item | Status | Notes |
|---|---|---|
| macOS check | [x] | Abort if not Darwin |
| Xcode Command Line Tools | [x] | `xcode-select --install` if missing |
| Homebrew | [x] | Official installer, `/opt/homebrew` |
| `brew shellenv` in `~/.zprofile` | [x] | Only appended if not already present |
| `brew bundle` from `config/Brewfile` | [x] | |

---

## 4. CLI tools (Homebrew formulae)

**Install**
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
- [x] php (see §5)
- [x] composer (see §5)
- [x] fnm (see §5)

---

## 5. Languages and runtimes

### PHP (Homebrew, replaces Herd — see §6)
- [x] `php` (latest) via brew
- [x] Additional versions via `shivammathur/php` tap (e.g. `php@8.3`)
- [x] pecl extensions: `redis`, `xdebug`
- [x] pecl: `imagick`, `memcached`, `pcov`
- [x] `composer` via brew
- [x] Global Composer packages: `laravel/installer`, `laravel/pint`
- [x] Global Composer: `laravel/valet`, `laravel/envoy`, `spatie/phpunit-watcher`, `cpx/cpx`

### Node
- [x] `fnm` via brew, `fnm install --lts`, `fnm default lts-latest`
- [x] `eval "$(fnm env --use-on-cd)"` in `.zshrc`
- [x] Global npm packages

### Python
- [x] `uv` (manages Python versions and tools; no pyenv)

### Go
- [x] `go` via brew

### Mobile
- [x] Flutter — currently installed; brew cask `flutter` or manual?
- [x] Android Studio — cask `android-studio`

---

## 6. Herd migration

Herd currently provides `php`, `composer` and Node (via its own nvm), and its `bin`
directory comes first in `PATH`. Moving to Homebrew PHP + fnm means:

- [x] Remove Herd's `bin` and nvm entries from `PATH` (`.zshrc`/`.zprofile`)
- [x] Remove the global `nvm` shell function loaded by Herd
- [x] Uninstall Herd entirely
- [x] Local `*.test` sites: Valet (`composer global require laravel/valet && valet install`)

---

## 7. Databases and services

- [x] DBngin (cask `dbngin`, currently installed)
- [x] TablePlus as GUI client
- [x] Docker Desktop for anything else

---

## 8. GUI applications (Homebrew casks)

**Install**
- [x] ghostty — primary terminal
- [x] zed
- [x] visual-studio-code
- [x] claude
- [x] claude-code
- [x] docker-desktop
- [x] tableplus
- [x] postman
- [x] figma
- [x] obsidian
- [x] slack
- [x] zoom
- [x] whatsapp
- [x] google-chrome
- [x] brave-browser
- [x] appcleaner
- [x] the-unarchiver
- [x] vlc
- [x] tailscale-app
- [x] codexbar
- [x] chatgpt

---

## 9. Fonts

- [x] font-fira-code
- [x] font-jetbrains-mono-nerd-font (needed by oh-my-posh glyphs)

---

## 10. Shell configuration

Shell: macOS zsh + oh-my-posh prompt + zsh-autosuggestions. No Oh My Zsh.

- [x] `home/.zshrc` → `~/.zshrc` (symlink)
- [x] `home/.aliases`, `home/.exports`, `home/.functions` sourced from `.zshrc`
- [x] oh-my-posh theme in `config/oh-my-posh/theme.omp.json`
- [x] `~/.hushlogin` (suppress "Last login" banner)
- [ ] Optional untracked `~/.zshrc.local` sourced last for machine-specific config

---

## 11. Git configuration

- [x] `home/.gitconfig` → `~/.gitconfig` (aliases, default branch `main`, pull rebase, etc.)
- [x] Identity (name/email) in untracked `~/.gitconfig.local`, included from `.gitconfig`; the installer prompts for it on first run
- [x] `home/.global-gitignore` → `~/.global-gitignore` (`.DS_Store`, `.idea/`, `.vscode/`)

---

## 12. Editor and terminal configuration

- [ ] `config/ghostty/config` → `~/.config/ghostty/config`
- [ ] `config/zed/settings.json`, `config/zed/keymap.json` → `~/.config/zed/`
- [?] VS Code settings/extensions (`code --install-extension` list)

---

## 13. macOS defaults and keyboard shortcuts

`macos/set-defaults.sh`, run by the installer (asks first).

- [ ] Finder: show hidden files, path bar, status bar, extensions
- [ ] Dock: autohide, size, no recent apps
- [ ] Keyboard: fast key repeat, short delay, disable press-and-hold
- [x] Screenshots: save to `~/Pictures/Screenshots`, PNG, no shadow
- [x] Trackpad: tap to click
- [ ] Custom app shortcuts via `defaults write <domain> NSUserKeyEquivalents`
- [?] Exact values and which shortcuts to define
- [?] Spotlight exclusions for `~/Development` (`node_modules`, `vendor`)

---

## 14. Claude Code setup

Optional step (installer asks).

- [?] Symlink `config/claude/settings.json` and `CLAUDE.md` into `~/.claude/`
- [?] Skills/agents kept in this repo and symlinked

---

## 15. Update flow (`bin/update`)

- [x] `git pull` this repo
- [x] `brew update && brew upgrade && brew bundle && brew cleanup`
- [x] `npm update -g`
- [x] `composer global update`
- [?] `mas upgrade`
- [?] `softwareupdate -l` (report only)

---

## 16. Open questions (summary)

- [ ] Final list of undecided formulae (§4) and casks (§8)
- [ ] Which PHP versions and pecl extensions (§5)
- [ ] Herd: uninstall or keep out of `PATH`; Valet or not (§6)
- [ ] DBngin vs brew services (§7)
- [ ] Use `mas` for App Store apps (§8)
- [ ] iTerm2 vs Ghostty only (§8)
- [ ] Modern CLI tools (zoxide, fzf, eza, bat, ripgrep) (§10)
- [ ] macOS defaults values and keyboard shortcuts (§13)
- [ ] Mackup or other settings sync (§1)
- [ ] Claude Code config in this repo (§14)

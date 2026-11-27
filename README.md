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

## Install manually

These apps are not in the Brewfile; download and install them from their vendors:

- [Zed](https://zed.dev/download)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Claude](https://claude.ai/download)
- [ChatGPT](https://openai.com/chatgpt/download/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [DBngin](https://dbngin.com)
- [Postman](https://www.postman.com/downloads/)
- [Figma](https://www.figma.com/downloads/)
- [Obsidian](https://obsidian.md/download)
- [Slack](https://slack.com/downloads/mac)
- [WhatsApp](https://www.whatsapp.com/download)
- [Google Chrome](https://www.google.com/chrome/)
- [AppCleaner](https://freemacsoft.net/appcleaner/)
- [The Unarchiver](https://theunarchiver.com)
- [VLC](https://www.videolan.org/vlc/)
- [Tailscale](https://tailscale.com/download/mac)
- [Android Studio](https://developer.android.com/studio)

Install Zed and VS Code before running `./bin/install` (or re-run it afterwards) so their
config gets linked and the VS Code extensions get installed. For VS Code, run
"Shell Command: Install 'code' command in PATH" from the command palette first.

## Layout

- `bin/` — `install`, plus helpers `xdebug` and `exclude-from-spotlight` (`update` and `migrate-from-herd` planned)
- `config/` — `Brewfile`, oh-my-posh theme, Ghostty, Zed and VS Code config
- `home/` — dotfiles symlinked into `~` (`.zshrc`, `.aliases`, `.exports`, `.functions`, `.gitconfig`)
- `macos/` — macOS defaults
- `docs/` — specification

#!/usr/bin/env bash
#
# macOS defaults (spec §13). Safe to re-run.
# Some settings only apply after logging out or restarting.

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC} $1"; }
pretty()  { local p="$1"; [[ "$p" == "$HOME"* ]] && p="~${p#"$HOME"}"; echo "$p"; }

# Screenshots: ~/Pictures/Screenshots, PNG, no window shadow
SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"
defaults write com.apple.screencapture location -string "$SCREENSHOTS_DIR"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
killall SystemUIServer &>/dev/null || true
success "Screenshots: $(pretty "$SCREENSHOTS_DIR"), PNG, no shadow"

# Trackpad: tap to click (built-in and Bluetooth trackpads, current user and login screen)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
success "Trackpad: tap to click"

warn "Log out and back in for the trackpad setting to take effect."

# ~/.zshrc — managed by environment-setup (symlink). Machine-specific config does not belong here.

# Repo location, resolved through the ~/.zshrc symlink so the repo can live anywhere.
export DOTFILES_DIR="${${(%):-%x}:A:h:h}"

# --- History ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space share_history

# --- Shell behaviour (what Oh My Zsh used to provide) -----------------------
setopt auto_cd interactive_comments
export CLICOLOR=1

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# --- Dotfiles ----------------------------------------------------------------
for file in "$DOTFILES_DIR"/home/.{exports,aliases,functions}; do
    [[ -r $file ]] && source "$file"
done
unset file

# --- Node (fnm) --------------------------------------------------------------
if (( $+commands[fnm] )); then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# --- Prompt (oh-my-posh) -----------------------------------------------------
if [[ $TERM_PROGRAM != "Apple_Terminal" ]] && (( $+commands[oh-my-posh] )); then
    eval "$(oh-my-posh init zsh --config "$DOTFILES_DIR/config/oh-my-posh/theme.omp.json")"
fi

# --- Plugins -----------------------------------------------------------------
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9
source ~/.powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
source ~/fzf-git.sh/fzf-git.sh

fpath+=( ~/.zsh/fzf-tab )
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

zstyle ':fzf-tab:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 {}'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 {}'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 {}'
zstyle ':fzf-tab:*' fzf-flags --height=40% --border --info=inline --preview-window=right:50%

# completion using arrow keys (based on history)
bindkey -e

bindkey '^k' history-search-backward
bindkey '^j' history-search-forward

bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

eval "$(fzf --zsh)"

alias cd="z"
alias c="clear"
alias e="exit"
alias v="nvim"
alias gc="git checkout"
alias ga="git add"
alias gaa="git add ."
alias gpf="git push -f"
alias gp="git pull"
alias gr="git rebase"
alias nr="npm run"
alias g="git status"
alias t="tmux"
alias ta="tmux a"

# language and frameworks
# . "$HOME/.cargo/env"
export XDG_CURRENT_DESKTOP=Hyprland
export PATH=$PATH:$(go env GOPATH)/bin
export GODEBUG=netdns=go
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# flutter
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
export CHROME_EXECUTABLE=/opt/google/chrome/google-chrome

export QT_QPA_PLATFORMTHEME=qt5ct

export PATH="$HOME/.local/bin:$PATH"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/powerlevel10k/p10k.zsh.
[[ ! -f ~/.config/powerlevel10k/p10k.zsh ]] || source ~/.config/powerlevel10k/p10k.zsh

# Download Znap, if it's not there yet.
[[ -f ~/.local/share/zsh-snap/znap.zsh ]] ||
  git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/.local/share/zsh-snap

zstyle ':znap:*' repos-dir ~/.local/share/zsh-snap/plugins
source ~/.local/share/zsh-snap/znap.zsh

export EDITOR='nvim'
export VISUAL='nvim'

##
# ⚠️ WARNING: Don't manually `source` your .zshrc file! It can have unexpected
# side effects. Instead, to safely apply changes, use `znap restart`.
#

znap source hlissner/zsh-autopair
znap source jeffreytse/zsh-vi-mode
znap source marlonrichert/zsh-autocomplete

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

znap source marlonrichert/zsh-hist
zstyle ':hist:*' expand-aliases yes

znap source romkatv/powerlevel10k
znap prompt romkatv/powerlevel10k

export ASDF_DIR="$HOME/.local/share/zsh-snap/plugins/asdf"
znap source asdf-vm/asdf asdf.sh

znap source ajeetdsouza/zoxide zoxide.plugin.zsh
#eval "$(zoxide init zsh)"

#znap source cantino/mcfly
#eval "$(mcfly init zsh)"
#export MCFLY_KEY_SCHEME=vim
#export MCFLY_FUZZY=true
#export MCFLY_DISABLE_MENU=true

#znap source ellie/atuin
#znap source MenkeTechnologies/zsh-expand

# can't work with znap

#eval "$(atuin init zsh)"


unsetopt HIST_REDUCE_BLANKS

#. "$HOME/.local/state/asdf.asdf.sh"

export HOMEBREW_NO_ENV_HINTS=true
export GOPRIVATE="gitlab.com/pinvest/*"

#export PNPM_HOME="/Users/ymbp/Library/pnpm"
#export PATH="$PNPM_HOME:$PATH"

# Golang
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"
export GOMODCACHE="$HOME/.cache/go"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="exa"
alias ll="exa -l"
alias la="exa -a"
alias lla="exa -la"

# alternate default
alias cat="bat"
alias hx="helix"
export BAT_THEME="Nord"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/yofriadi/.local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/home/yofriadi/.local/share/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/home/yofriadi/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/yofriadi/.local/share/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/home/yofriadi/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

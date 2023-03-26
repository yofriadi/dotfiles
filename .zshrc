# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/powerlevel10k/p10k.zsh.
[[ ! -f ~/.config/powerlevel10k/p10k.zsh ]] || source ~/.config/powerlevel10k/p10k.zsh

eval "$(sheldon source)"
eval "$(zoxide init zsh)"

export ASDF_DIR="$HOME/.local/share/sheldon/repos/github.com/asdf-vm/asdf"

export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPRIVATE="gitlab.com/pinvest/*"
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

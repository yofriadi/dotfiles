#!/bin/zsh

##
# Plugins & Plugin manager
#

local znap=~/.local/bin/zsh-snap/znap.zsh

# Auto-install Znap if it's not there yet.
if ! [[ -r $znap ]]; then   # Check if the file exists and can be read.
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.local/bin/zsh-snap/
fi

. $znap   # Load Znap.

# Add the plugins you want to use here.
# For more info on each plugin, visit its repo at github.com/<plugin>
# -a sets the variable's type to array.
local -a plugins=(
    #marlonrichert/zsh-autocomplete      # Real-time type-ahead completion
    #marlonrichert/zsh-edit              # Better keyboard shortcuts
    #marlonrichert/zsh-hist              # Edit history from the command line.
    #marlonrichert/zcolors               # Colors for completions and Git
    zsh-users/zsh-autosuggestions       # Inline suggestions
    zsh-users/zsh-completions           # completions
    zsh-users/zsh-syntax-highlighting   # Command-line syntax highlighting

    romkatv/powerlevel10k
    hlissner/zsh-autopair
    jeffreytse/zsh-vi-mode
    #z-shell/F-Sy-H
)

# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
#   zstyle ':autocomplete:*' min-delay 0.5  # seconds
#
# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
#   zstyle ':autocomplete:*' async no


# Speed up the first startup by cloning all plugins in parallel.
# This won't clone plugins that we already have.
znap clone $plugins

# Load each plugin, one at a time.
local p=
for p in $plugins; do
  znap source $p
done

# `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
# caching and compilation of <command>'s output, making it ~10 times faster.
#znap eval zcolors zcolors   # Extra init code needed for zcolors.

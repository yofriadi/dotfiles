#!/bin/zsh

##
# Prompt theme
#

# Reduce startup time by making the left side of the primary prompt visible
# *immediately.*
#znap prompt launchpad

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/powerlevel10k/.p10k.zsh ]] || source ~/.config/powerlevel10k/.p10k.zsh

# `znap prompt` can autoload our prompt function, because in 04-env.zsh, we
# added its parent dir to our $fpath.

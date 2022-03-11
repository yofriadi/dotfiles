#### The .zshrc file traditionally contains all shell script related to settings, activites, aliases and the like.
#### However, in an effort to keep this codebase as clean and easy to navigate as possible each section of this file
#### has been broken up into modules which are only loaded by this file. Therefore, all this shell script does is:
####    1. Load all files within the "ZDOTDIR/zsh-script/" directory.

## Load all needed modules.
for module in "${ZDOTDIR}"/zsh-scripts/*
do
	if [ -f "${module}" ]; then
		. "${module}"
	fi
done

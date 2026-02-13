# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_zb_global_optspecs
	string join \n root= prefix= concurrency= auto-init h/help V/version
end

function __fish_zb_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_zb_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_zb_using_subcommand
	set -l cmd (__fish_zb_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c zb -n "__fish_zb_needs_command" -l root -r -F
complete -c zb -n "__fish_zb_needs_command" -l prefix -r -F
complete -c zb -n "__fish_zb_needs_command" -l concurrency -r
complete -c zb -n "__fish_zb_needs_command" -l auto-init
complete -c zb -n "__fish_zb_needs_command" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_needs_command" -s V -l version -d 'Print version'
complete -c zb -n "__fish_zb_needs_command" -f -a "install"
complete -c zb -n "__fish_zb_needs_command" -f -a "bundle"
complete -c zb -n "__fish_zb_needs_command" -f -a "uninstall"
complete -c zb -n "__fish_zb_needs_command" -f -a "migrate"
complete -c zb -n "__fish_zb_needs_command" -f -a "list"
complete -c zb -n "__fish_zb_needs_command" -f -a "info"
complete -c zb -n "__fish_zb_needs_command" -f -a "gc"
complete -c zb -n "__fish_zb_needs_command" -f -a "reset"
complete -c zb -n "__fish_zb_needs_command" -f -a "init"
complete -c zb -n "__fish_zb_needs_command" -f -a "completion"
complete -c zb -n "__fish_zb_needs_command" -f -a "run"
complete -c zb -n "__fish_zb_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c zb -n "__fish_zb_using_subcommand install" -l no-link
complete -c zb -n "__fish_zb_using_subcommand install" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand install" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand bundle" -s f -l file -r -F
complete -c zb -n "__fish_zb_using_subcommand bundle" -l no-link
complete -c zb -n "__fish_zb_using_subcommand bundle" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand bundle" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand uninstall" -l all
complete -c zb -n "__fish_zb_using_subcommand uninstall" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand uninstall" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand migrate" -s y -l yes
complete -c zb -n "__fish_zb_using_subcommand migrate" -l force
complete -c zb -n "__fish_zb_using_subcommand migrate" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand migrate" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand list" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand list" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand info" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand info" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand gc" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand gc" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand reset" -s y -l yes
complete -c zb -n "__fish_zb_using_subcommand reset" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand reset" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand init" -l no-modify-path
complete -c zb -n "__fish_zb_using_subcommand init" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand init" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand completion" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand completion" -s h -l help -d 'Print help'
complete -c zb -n "__fish_zb_using_subcommand run" -l auto-init
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "install"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "bundle"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "uninstall"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "migrate"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "list"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "info"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "gc"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "reset"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "init"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "completion"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "run"
complete -c zb -n "__fish_zb_using_subcommand help; and not __fish_seen_subcommand_from install bundle uninstall migrate list info gc reset init completion run help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'

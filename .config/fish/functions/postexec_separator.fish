function postexec_separator --on-event fish_postexec
    # Get the terminal width (using tput for portability)
    set width (tput cols)
    # Print a line of your chosen character (here we use the box-drawing dash)
    printf '%*s\n' $width '' | tr ' ' '─'
end

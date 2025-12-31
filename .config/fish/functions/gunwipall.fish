# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall
    set -l _commit (git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

    # Check if a commit without "--wip--" was found and it's not the same as HEAD
    if test "$_commit" != (git rev-parse HEAD)
        git reset $_commit; or return 1
    end
end

# Automatically run ls after cd
function __ls_after_cd__on_variable_pwd --on-variable PWD
    if status --is-interactive
        eza -hlF $PWD
    end

    # if .git directory exists, run git status
    if test -d $PWD/.git
        git status -s
    end
end

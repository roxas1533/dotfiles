function nsl --description 'Shortcut for nix shell nixpkgs#...'
    set -l pkgs
    for arg in $argv
        set -a pkgs "nixpkgs#$arg"
    end
    nix shell $pkgs
end

function nix --wraps nix --description 'Nix wrapper with shell detection'
    if test (count $argv) -ge 1; and contains -- $argv[1] shell develop
        if test "$argv[1]" = shell
            set -l pkgs
            for arg in $argv[2..]
                if not string match -q -- '-*' $arg
                    set -a pkgs (string replace -r '.*#' '' $arg)
                end
            end
            if test (count $pkgs) -gt 0
                set -gx --append NIX_SHELL_PACKAGES (string join ", " $pkgs)
            end
        else
            set -l flake ""
            for arg in $argv[2..]
                if not string match -q -- '-*' $arg
                    set flake $arg
                    break
                end
            end
            if test -n "$flake"
                set -gx --append NIX_SHELL_PACKAGES "dev:$flake"
            else
                set -gx --append NIX_SHELL_PACKAGES dev
            end
        end

        command nix $argv

        # pop
        if test (count $NIX_SHELL_PACKAGES) -le 1
            set -e NIX_SHELL_PACKAGES
        else
            set -e NIX_SHELL_PACKAGES[-1]
        end
    else
        command nix $argv
    end
end

function _prompt_nix_shell --description 'Show Nix shell indicator'
    set -l parts

    if test -n "$IN_NIX_SHELL"
        set -a parts "$IN_NIX_SHELL"
    end

    if test (count $NIX_SHELL_PACKAGES) -gt 0
        set -a parts "$NIX_SHELL_PACKAGES[-1]"
    end

    if test (count $parts) -gt 0
        echo "❄️ "(string join " " $parts)
    end
end

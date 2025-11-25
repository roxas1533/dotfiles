function _prompt_nix_shell --description 'Show Nix shell indicator'
    if test -n "$IN_NIX_SHELL"
        if test "$IN_NIX_SHELL" = "pure"
            echo "❄️ pure"
        else if test "$IN_NIX_SHELL" = "impure"
            echo "❄️ impure"
        else
            echo "❄️"
        end
    end
end

function __nrs_expand --description 'Print the concrete rebuild command for the nrs abbreviation'
    set -l flake "$HOME/dotfiles"
    set -l native_flake "$flake#nixos-native"

    if set -q NRS_NATIVE_FLAKE
        set native_flake "$NRS_NATIVE_FLAKE"
    else if test -f "$HOME/nixos-local/flake.nix"
        set native_flake "$HOME/nixos-local#this"
    end

    # Not NixOS: server (home-manager)
    if not test -f /etc/NIXOS
        echo "home-manager switch --flake $flake#server"
        return
    end

    if test (systemd-detect-virt) = wsl
        echo "nix run $flake#switch --"
    else
        echo "sudo nixos-rebuild switch --flake $native_flake"
    end
end

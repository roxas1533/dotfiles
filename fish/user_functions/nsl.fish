function nsl --description 'Shortcut for nix shell nixpkgs#...'
    set -l pkgs
    for arg in $argv
        set -a pkgs "nixpkgs#$arg"
    end
    nix shell $pkgs
end

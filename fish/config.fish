if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g theme_display_user yes
    # set fish_prompt_pwd_dir_length 0
    set -x LD_LIBRARY_PATH /usr/lib/wsl/lib
end

# Add user functions to function path
set -gp fish_function_path $__fish_config_dir/user_functions $fish_function_path
alias vim="nvim"
set -x EDITOR nvim
alias se="export EDITOR=$EDITOR; sudoedit"

function cdw
    set dir (echo $argv[1] | sed -e 's,\(.\):,/mnt/\L\1,' -e 's,\\\\,/,g')
    cd $dir
end

function setWsl
    if test ! -S "$XDG_RUNTIME_DIR/wayland-0"
        ln -s /mnt/wslg/runtime-dir/wayland-0* "$XDG_RUNTIME_DIR"
    end
end

if type -q direnv
    direnv hook fish | source
end

alias setwsl="setWsl"

function fullpath
    set full_path (realpath $argv[1])
    echo $full_path
    echo $full_path | wl-copy
end

set -x LANG ja_JP.UTF-8
set -x DISPLAY :0
set -x DENO_TLS_CA_STORE system

# NixOS rebuild / home-manager switch helper
function nrs --description "nixos-rebuild switch with WSL/native auto-detect, or home-manager for server"
    set -l flake "$HOME/dotfiles"

    # Check for -s flag (server mode)
    if contains -- -s $argv
        set -l args (string match -v -- '-s' $argv)
        home-manager switch --flake $flake#server $args
        return
    end

    # Check if running on NixOS
    if not test -f /etc/NIXOS
        echo "Error: This is not a NixOS system."
        echo "Use 'nrs -s' for server (home-manager) or run on NixOS."
        return 1
    end

    # Auto-detect WSL/native for NixOS
    if test (systemd-detect-virt) = "wsl"
        nix run $flake#switch -- $argv
    else
        nix run $flake#switch-native -- $argv
    end
end

# Load all config files - overrides NixOS default settings
for file in $__fish_config_dir/config/*.fish
    source $file &
end

source $__fish_config_dir/themes/hydro-config.fish

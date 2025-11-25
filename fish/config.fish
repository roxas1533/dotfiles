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

# Load all config files - overrides NixOS default settings
for file in $__fish_config_dir/config/*.fish
    source $file &
end

source $__fish_config_dir/themes/hydro-config.fish

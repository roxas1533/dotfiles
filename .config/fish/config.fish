if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g theme_display_user yes
    # set fish_prompt_pwd_dir_length 0
    set -x LD_LIBRARY_PATH /usr/lib/wsl/lib
end
alias vim="nvim"
set -x DENO_INSTALL ~/.deno
set -x PATH $DENO_INSTALL/bin:$PATH

set EDITOR nvim
alias se="export EDITOR=$EDITOR; sudoedit"

function cdw
    set dir (echo $argv[1] | sed -e 's,\(.\):,/mnt/\L\1,' -e 's,\\\\,/,g')
    cd $dir
end

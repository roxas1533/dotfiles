if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g theme_display_user yes
    set fish_prompt_pwd_dir_length 0
    
    set -x PYENV_ROOT $HOME/.pyenv
    set -x PATH $PYENV_ROOT/bin:$PATH
    pyenv init - | source
    set -x LD_LIBRARY_PATH /usr/lib/wsl/lib
end

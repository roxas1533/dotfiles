#!bin/bash
set -ue


link_to_homedir(){
    local script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd -P)"
    local dotdir=$(dirname ${script_dir})
    
    if [ -n "$(which wslpath)" ]; then
        type "wslvar" > /dev/null 2>&1 || sudo apt install -y wslu
        local base_directory=$(echo "$dotdir"|cut -d "/" -f2)
        if [ "$base_directory" != "mnt" ]; then
            echo "dotfilesが/mnt上にありません"
            echo "dotfilesを/mnt上に移動してインストールしますか？(y/n)"
            local win_user_file=$(wslpath "$(wslvar USERPROFILE)")
            read answer
            case $answer in
                "" | "Y" | "y" | "yes" | "Yes" | "YES" ) 
                    sudo cp -r $dotdir $win_user_file/
                    dotdir="$win_user_file/dotfiles"
                    ;;
                * ) echo "インストールを中止します" && exit ;;
            esac
        fi
        for f in $dotdir/Code/*.json; do
            cp -f $f $(wslpath "$(wslvar APPDATA)")/Code/User/
        done
        # ln -snfv $dotdir/Code Code
    fi
    if [ "$HOME" != "$dotdir" ]; then
        for f in $dotdir/.??*; do
            [ `basename $f` = ".git" ] && continue
                ln -snfv ${f} ${HOME}
            echo $f
        done
        fish fisher update
    else
        command echo "dotfiles are already linked to home directory"
    fi
}

link_to_homedir
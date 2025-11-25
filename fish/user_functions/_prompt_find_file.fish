function _prompt_find_file --description 'Find file in current or parent directories'
    set -l target $argv[1]
    set -l current_dir $PWD

    while test "$current_dir" != "/"
        if test -f "$current_dir/$target"
            return 0
        end
        set current_dir (dirname "$current_dir")
    end
    return 1
end

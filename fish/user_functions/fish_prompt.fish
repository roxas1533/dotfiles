function fish_prompt --description 'Custom Hydro prompt with background colors'
    # Custom colors (background)
    set -l bg_pwd 3465A4      # blue
    set -l bg_git 4E9A06      # green
    set -l bg_duration C0A36E # yellow
    set -l fg_normal DCD7BA   # foreground (light)

    # Powerline separator (right-pointing for left prompt)
    set -l sep_right ""

    # Nerd Font icons
    set -l icon_folder ""  # Folder icon
    set -l icon_git ""     # Git branch icon

    set -l output ""
    set -l prev_bg ""

    # PWD segment with folder icon
    if set -q _hydro_pwd
        set -l pwd_clean (string replace -r '\x1b\[[^m]+m' '' $_hydro_pwd)
        set output "$output"(set_color -b $bg_pwd)(set_color $fg_normal)" $icon_folder $pwd_clean "
        set prev_bg $bg_pwd
    end

    # Git segment with branch icon (use indirect variable reference)
    if set -q _hydro_git
        set -l git_var_name $_hydro_git
        if set -q $git_var_name
            set -l git_info (string trim $$git_var_name)
            if test -n "$git_info"
                # Add separator
                if test -n "$prev_bg"
                    set output "$output"(set_color -b $bg_git)(set_color $prev_bg)"$sep_right"
                end
                set output "$output"(set_color -b $bg_git)(set_color $fg_normal)" $icon_git $git_info "
                set prev_bg $bg_git
            end
        end
    end

    # Final separator to normal background
    if test -n "$prev_bg"
        set output "$output"(set_color normal)(set_color $prev_bg)"$sep_right"
    end

    # Reset and add spacing
    set output "$output"(set_color normal)

    # Add newline if multiline mode
    if test "$hydro_multiline" = true
        set output "$output\n"
    end

    # Determine prompt symbol color based on context
    # Use git color if git info is present, otherwise use pwd color
    set -l prompt_color $bg_pwd  # Default to pwd color (blue)

    if set -q _hydro_git
        set -l git_var_name $_hydro_git
        if set -q $git_var_name
            set -l git_info (string trim $$git_var_name)
            if test -n "$git_info"
                set prompt_color $bg_git  # Use git color (green) when git info exists
            end
        end
    end

    # Get prompt symbol
    set -q hydro_symbol_prompt; or set -l hydro_symbol_prompt "❱"

    # Output prompt symbol with dynamic color
    set output "$output"(set_color $prompt_color)"$hydro_symbol_prompt"

    echo -ne "$output"(set_color normal)" "
end

function fish_right_prompt --description 'Custom right prompt with Tide-like styling'
    # Vibrant colors (background)
    set -l bg_nix AD7FA8      # bright purple
    set -l bg_time F57900     # orange
    set -l bg_default normal  # terminal default background
    set -l fg_normal DCD7BA   # foreground (light)
    set -l fg_dark 16161D     # background (dark)

    # Powerline separators (right prompt: left-pointing)
    set -l sep_left ""

    set -l output ""
    set -l prev_bg $bg_default

    # Build segments from right to left (reverse order for right prompt)
    set -l segments_data

    # Time segment (rightmost)
    set -l time_str (date "+%H:%M:%S")
    set -a segments_data "time|$bg_time|$fg_normal| $time_str "

    # Command duration segment (left of time)
    if set -q _hydro_cmd_duration
        set -l duration (string trim $_hydro_cmd_duration)
        if test -n "$duration"
            set -a segments_data "duration|$bg_nix|$fg_normal| ⏱ $duration "
        end
    end

    # Nix Shell indicator (if present, left of duration/time)
    set -l nix_info (_prompt_nix_shell)
    if test -n "$nix_info"
        set -a segments_data "nix|$bg_nix|$fg_normal| $nix_info "
    end

    # Reverse segments for right-to-left rendering
    for i in (seq (count $segments_data) -1 1)
        set -l segment $segments_data[$i]
        set -l parts (string split '|' $segment)
        set -l seg_name $parts[1]
        set -l seg_bg $parts[2]
        set -l seg_fg $parts[3]
        set -l seg_text $parts[4]

        # Add powerline separator (with previous segment's bg color)
        if test "$prev_bg" != "$bg_default"
            set output "$output"(set_color -b $seg_bg)(set_color $prev_bg)"$sep_left"
        end

        # Add segment content
        set output "$output"(set_color -b $seg_bg)(set_color $seg_fg)"$seg_text"

        set prev_bg $seg_bg
    end

    # Final separator to terminal background
    if test "$prev_bg" != "$bg_default"
        set output "$output"(set_color normal)(set_color $prev_bg)"$sep_left"
    end

    # Reset colors
    set output "$output"(set_color normal)

    echo -n $output
end

# Fix cursor shape after exiting vim/nvim
# Set cursor to vertical bar (beam) in insert mode
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

# Reset cursor shape on prompt display
function reset_cursor_shape --on-event fish_prompt
    echo -en '\e[6 q'  # Vertical bar cursor
end

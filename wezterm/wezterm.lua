-- WezTerm configuration
local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.font_size = 11.0
config.use_ime = true
config.window_background_opacity = 0.3
config.window_decorations = "RESIZE"
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.font = wezterm.font_with_fallback { 'HackGen35 Console NF', 'Noto Color Emoji', '0xProto Nerd Font Mono' }

config.keys = {
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(1),
  },
  { -- <C-.>
    key="f",
    mods="CTRL|SHIFT",
    action=wezterm.action.SendKey({ key = 'F', mods = 'CTRL|SHIFT' }),
  },
    { key = 'UpArrow',    mods = 'NONE',       action = wezterm.action.SendString '\x1bOA' },
    { key = 'DownArrow',  mods = 'NONE',       action = wezterm.action.SendString '\x1bOB' },
    { key = 'RightArrow', mods = 'NONE',       action = wezterm.action.SendString '\x1bOC' },
    { key = 'LeftArrow',  mods = 'NONE',       action = wezterm.action.SendString '\x1bOD' },
}

return config

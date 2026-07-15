--- @type Wezterm
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true

config.font_size = 15.0
config.window_background_opacity = 0.85
-- config.macos_window_background_blur = 0.9

config.status_update_interval = 1500
-- load modul keymaps
local keymaps = require("keymaps")
keymaps.apply_to_config(config)
return config

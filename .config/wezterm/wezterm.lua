---@type Wezterm
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true

config.font_size = 15.0
config.window_background_opacity = 0.85
config.macos_window_background_blur = 8 -- opacityで視覚的に制御

config.status_update_interval = 1500
config.window_decorations = "RESIZE"
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = true

config.disable_default_quick_select_patterns = true

-- config.colors = {
-- 	tab_bar = {
-- 		background = "#ffffff",
-- 		inactive_tab = { bg_color = "#0d47a1", fg_color = "#e3f2fd" },
-- 		active_tab = { bg_color = "#1976d2", fg_color = "#ffffff" },
-- 		inactive_tab_hover = { bg_color = "#1565c0", fg_color = "#ffffff" },
-- 	},
-- }

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local title = tab.tab_title
-- 	if not title or #title == 0 then
-- 		title = tab.active_pane.title
-- 	end
--
-- 	local bg = tab.is_active and "#1976d2" or (hover and "#1565c0" or (tab.is_last_active and "#1565c0" or "#0d47a1"))
-- 	local fg = "#ffffff"
--
-- 	return {
-- 		{ Background = { Color = bg } },
-- 		{ Foreground = { Color = fg } },
-- 		{ Text = " " .. title .. " " },
-- 	}
-- end)

-- load modul keymaps
local keymaps = require("keymaps")
local statusbar = require("statusbar")
local appearance = require("appearance")
local tab_simple = require("tab_simple")

tab_simple.apply_to_config(config)
appearance.apply_to_config(config)
keymaps.apply_to_config(config)
statusbar.apply_to_config(config)
return config

local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local leader = { key = ";", mods = "CTRL", timeout_milliseconds = 2000 }

local keys = {
	-- Split pane
	{ key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Pindah fokus antar pane
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- Tutup pane aktif
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Toggle zoom pane
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- resize pane mode
	{ key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
}

local key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },

		-- Keluar dari resize mode
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

function module.apply_to_config(config)
	config.leader = leader
	config.keys = keys
	config.key_tables = key_tables
end

return module

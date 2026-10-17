local wezterm = require("wezterm")
local act = wezterm.action
local claude = require("claude_accounts")

local module = {}

local leader = { key = ";", mods = "CTRL", timeout_milliseconds = 2000 }

local keys = {
	-- Split pane (mewarisi akun Claude dari pane saat ini)
	{ key = "d", mods = "LEADER", action = claude.split("Bottom") },
	{ key = "r", mods = "LEADER", action = claude.split("Right") },

	-- Pindah fokus antar pane
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- Tutup pane aktif
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Toggle zoom pane
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Pindah posisi pane (rotate searah / berlawanan jarum jam)
	{ key = "]", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "[", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },

	-- resize pane mode
	{ key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Claude multi-account
	-- Opsi A: Ctrl+Shift+2 -> tab baru akun kedua di direktori yang sama
	-- ("@" juga didaftarkan karena Shift+2 bisa terbaca sebagai "@")
	{ key = "2", mods = "CTRL|SHIFT", action = claude.new_kedua_tab },
	{ key = "@", mods = "CTRL|SHIFT", action = claude.new_kedua_tab },
	-- Opsi B: Leader+2 -> workspace akun kedua, Leader+1 -> kembali ke default
	{ key = "2", mods = "LEADER", action = claude.switch_to_kedua_workspace },
	{ key = "1", mods = "LEADER", action = claude.switch_to_default_workspace },
	-- Cmd+T mewarisi akun dari pane saat ini
	{ key = "t", mods = "SUPER", action = claude.new_tab },
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

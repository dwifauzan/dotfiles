-- =============================================================================
-- Multi-account Claude Code
--
-- Akun utama : config default (~/.claude), tanpa env tambahan
-- Akun kedua : CLAUDE_CONFIG_DIR=~/.claude-kedua
--
-- Env disuntik langsung oleh WezTerm saat spawn (set_environment_variables),
-- jadi tidak perlu `export` di .zshrc dan bebas `cd` ke mana saja.
--
-- Opsi A: tab baru akun kedua (cwd ikut pane saat ini)
-- Opsi B: workspace "claude-kedua"; semua tab/split di dalamnya otomatis akun kedua
-- =============================================================================

local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

local CONFIG_DIR = wezterm.home_dir .. "/.claude-kedua"
local WORKSPACE = "claude-kedua"
local ENV = {
	CLAUDE_CONFIG_DIR = CONFIG_DIR,
	-- Penanda untuk prompt zsh / script (opsional dipakai)
	CLAUDE_ACCOUNT = "kedua",
}

-- WezTerm versi lama (mis. 20240203) mengabaikan set_environment_variables
-- kalau args tidak diisi, jadi shell login selalu disebut eksplisit
local SHELL_ARGS = { os.getenv("SHELL") or "/bin/zsh", "-l" }

-- Tab yang dibuka lewat Opsi A. Disimpan di GLOBAL supaya tidak hilang
-- saat config di-reload (automatically_reload_config = true)
wezterm.GLOBAL.claude_kedua_tabs = wezterm.GLOBAL.claude_kedua_tabs or {}

-- -----------------------------------------------------------------------------
-- Helper
-- -----------------------------------------------------------------------------

-- cwd pane saat ini sebagai path biasa (nil kalau tidak terdeteksi)
local function cwd_of(pane)
	local url = pane:get_current_working_dir()
	if not url then
		return nil
	end
	-- Versi baru mengembalikan objek Url, versi lama berupa string "file://host/path"
	if type(url) == "string" then
		return url:gsub("^file://[^/]*", "")
	end
	return url.file_path
end

local function mark_tab(tab)
	wezterm.GLOBAL.claude_kedua_tabs[tostring(tab:tab_id())] = true
end

-- Apakah pane ini milik akun kedua (via workspace Opsi B atau tab Opsi A)
function module.is_kedua(window, pane)
	if window:active_workspace() == WORKSPACE then
		return true
	end
	local tab = pane:tab()
	return tab ~= nil and wezterm.GLOBAL.claude_kedua_tabs[tostring(tab:tab_id())] == true
end

local function spawn_kedua_tab(window, pane)
	local tab = window:mux_window():spawn_tab({
		args = SHELL_ARGS,
		cwd = cwd_of(pane),
		set_environment_variables = ENV,
	})
	mark_tab(tab)
end

-- -----------------------------------------------------------------------------
-- Actions (dipakai di keymaps.lua)
-- -----------------------------------------------------------------------------

-- Opsi A: tab baru akun kedua, direktori kerja tetap sama
module.new_kedua_tab = wezterm.action_callback(spawn_kedua_tab)

-- Opsi B: pindah ke workspace akun kedua (dibuat kalau belum ada)
module.switch_to_kedua_workspace = wezterm.action_callback(function(window, pane)
	window:perform_action(
		act.SwitchToWorkspace({
			name = WORKSPACE,
			spawn = { args = SHELL_ARGS, cwd = cwd_of(pane), set_environment_variables = ENV },
		}),
		pane
	)
end)

module.switch_to_default_workspace = act.SwitchToWorkspace({ name = "default" })

-- Tab baru biasa (Cmd+T) yang mewarisi akun dari pane saat ini
module.new_tab = wezterm.action_callback(function(window, pane)
	if module.is_kedua(window, pane) then
		spawn_kedua_tab(window, pane)
	else
		window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
	end
end)

-- Split yang mewarisi akun dari pane saat ini.
-- direction: "Bottom" (= SplitVertical) atau "Right" (= SplitHorizontal)
function module.split(direction)
	return wezterm.action_callback(function(window, pane)
		if module.is_kedua(window, pane) then
			pane:split({
				direction = direction,
				args = SHELL_ARGS,
				cwd = cwd_of(pane),
				set_environment_variables = ENV,
			})
		elseif direction == "Bottom" then
			window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
		else
			window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
		end
	end)
end

-- Teks indikator akun untuk status bar
function module.status(window, pane)
	if module.is_kedua(window, pane) then
		return { { Foreground = { Color = "#F5A97F" } }, { Text = " Claude: kedua " } }
	end
	return { { Foreground = { Color = "#6c7086" } }, { Text = " Claude: utama " } }
end

return module

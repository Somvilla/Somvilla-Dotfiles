local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- File that the wallpaper script will touch to force reload
local home = os.getenv("HOME")
local reload_trigger = home .. "/.cache/wezterm-wallpaper-reload"

-- Watch this file; when it changes, wezterm reloads config
wezterm.add_to_config_reload_watch_list(reload_trigger)
-- === get wallpaper from swww, with fallback ===
local function get_swww_wallpaper()
	-- Take the first monitor's image path from `swww query`
	local handle = io.popen("swww query 2>/dev/null | awk '/image:/ {print $NF; exit}'")
	if not handle then
		return nil
	end

	local output = handle:read("*a") or ""
	handle:close()

	local path = output:gsub("%s+", "") -- strip newline/whitespace
	if path == "" then
		return nil
	end

	return path
end
local fallback_wallpaper = os.getenv("HOME") .. "/wallpapers/winter/Clearnight.jpg"
local wallpaper = get_swww_wallpaper() or fallback_wallpaper

-- === your existing config ===

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "NONE"
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.font_size = 12.5
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.enable_tab_bar = false
config.window_padding = {
	left = 7,
	right = 0,
	top = 2,
	bottom = 0,
}

config.background = {
	{
		source = {
			File = wallpaper,
		},
		hsb = {
			hue = 1.0,
			saturation = 1.02,
			brightness = 0.25,
		},
		-- attachment = { Parallax = 0.3 },
		-- width = "100%",
		-- height = "100%",
	},
	{
		source = {
			Color = "#1E1E2E",
		},
		width = "100%",
		height = "100%",
		opacity = 0.75,
	},
}

-- config.window_background_opacity = 0.3
-- config.macos_window_background_blur = 20

config.keys = {
	{ key = "Enter", mods = "CTRL", action = wezterm.action({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
}

-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	{
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
}

return config

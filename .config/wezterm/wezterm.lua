local wezterm = require("wezterm")
local config = require("config")
require("events")

-- Color scheme disabled to allow starship palette control
-- WezTerm will use default ANSI colors that starship can control
-- Uncomment below to re-enable WezTerm color schemes (will override starship colors)

-- Color scheme removed to allow starship ANSI color control

-- local themes = {
-- 	nord = "Nord (Gogh)",
-- 	onedark = "One Dark (Gogh)",
-- 	catppuccin = "Catppuccin Mocha",
-- 	-- catppuccin = "Catppuccin Macchiato",
-- 	-- catppuccin = "Catppuccin Frappe",
-- 	-- catppuccin = "Catppuccin Latte",
-- }
-- local success, stdout, stderr = wezterm.run_child_process({ os.getenv("SHELL"), "-c", "printenv WEZTERM_THEME" })
-- local selected_theme = stdout:gsub("%s+", "") -- Remove all whitespace characters including newline
-- config.color_scheme = themes[selected_theme]

return config

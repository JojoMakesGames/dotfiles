local wezterm = require("wezterm")

local config = {}

config.initial_cols = 300
config.initial_rows = 300
config.use_dead_keys = false
config.window_background_opacity = 1.0
config.scrollback_lines = 10000
config.colors = require("cyberdream")
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

return config

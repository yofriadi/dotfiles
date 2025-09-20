local wezterm = require 'wezterm'

-- Load the plugin once at the beginning
local neapsix_plugin = wezterm.plugin.require('https://github.com/neapsix/wezterm')

wezterm.on('reload', function()
  wezterm.config_dir_reload()
end)

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local config = {
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  font = wezterm.font({
    family = "JetBrainsMono Nerd Font Mono",
    weight = "Regular",
    stretch = "Normal",
    italic = false
  }),
  font_size = 15,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  initial_rows = 60,
  initial_cols = 130
  --window_background_opacity = 1.0,
  --text_background_opacity = 0.3
}

-- Apply the colors directly to the config instead of using color_scheme
if get_appearance():find 'Dark' then
  config.colors = neapsix_plugin.moon.colors()
else
  config.colors = neapsix_plugin.dawn.colors()
end

return config

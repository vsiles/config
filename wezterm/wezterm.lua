local wezterm = require "wezterm";

-- TODO
-- capture current screen and open it in vim/nvim
-- https://github.com/wez/wezterm/issues/222
-- works very nicely buth my path is not right. I need to find
-- a way to fix this
--
-- InputSelector/ActivateCommandPalette looks awesome for workspace selection.
-- Learn more about them at some point 
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/InputSelector.html
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateCommandPalette.html
--

-- use your devserver hostname here!
local SB = "XXX.YYY.com"
local SB_Big = "AAA.BBB.com"

local config = {}

-- on windows, starts powershell
-- TODO: double check the triple value
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'powershell.exe' }
end


-- font configuration
config.font = wezterm.font "UbuntuMono Nerd Font Mono"
config.font_size = 18.0
-- config.font_antialias = "Subpixel", -- None, Greyscale, Subpixel
-- config.font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full

-- theme & look
config.color_scheme = 'Default Dark (base16)'
-- config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

config.scrollback_lines = 5000


-- key bindings
config.leader = { key = 'b', mods = 'CTRL' }

config.keys = {
    -- TODO learn what that is
    -- { key = "a", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
    { key = 'x', mods = 'LEADER',          action = wezterm.action.CloseCurrentPane { confirm = true }},
    { key = 's', mods = 'LEADER',          action = wezterm.action.ShowLauncher },
    { key = 'P', mods = 'LEADER|SHIFT',          action = wezterm.action.ActivateCommandPalette },
    -- TODO create a local detachable domain
    { key = "d", mods = "LEADER",          action = wezterm.action.DetachDomain "CurrentPaneDomain"}, 
    -- { key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
    { key = 'x', mods = 'LEADER|CTRL',     action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }},
    { key = 'v', mods = 'LEADER|CTRL',     action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }},
    { key = 'q', mods = 'LEADER',          action = wezterm.action.PaneSelect },
    { key = "n", mods = "LEADER",          action = wezterm.action.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER",          action = wezterm.action.ActivateTabRelative(-1) },
    { key = "z", mods = "LEADER",          action = wezterm.action.TogglePaneZoomState },
    { key = "c", mods = "LEADER",          action = wezterm.action.SpawnTab "CurrentPaneDomain"},
    { key = "h", mods = "LEADER",          action = wezterm.action.ActivatePaneDirection "Left"},
    { key = "j", mods = "LEADER",          action = wezterm.action.ActivatePaneDirection "Down"},
    { key = "k", mods = "LEADER",          action = wezterm.action.ActivatePaneDirection "Up"},
    { key = "l", mods = "LEADER",          action = wezterm.action.ActivatePaneDirection "Right"},
    { key = "LeftArrow", mods = "LEADER",  action = wezterm.action.ActivatePaneDirection "Left"},
    { key = "DownArrow", mods = "LEADER",  action = wezterm.action.ActivatePaneDirection "Down"},
    { key = "UpArrow",   mods = "LEADER",  action = wezterm.action.ActivatePaneDirection "Up"},
    { key = "RightArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Right"},
    { key = "H", mods = "LEADER|SHIFT",    action = wezterm.action.AdjustPaneSize {"Left", 5}},
    { key = "J", mods = "LEADER|SHIFT",    action = wezterm.action.AdjustPaneSize {"Down", 5}},
    { key = "K", mods = "LEADER|SHIFT",    action = wezterm.action.AdjustPaneSize {"Up", 5}},
    { key = "L", mods = "LEADER|SHIFT",    action = wezterm.action.AdjustPaneSize {"Right", 5}},
    -- { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
    -- { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
    -- { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
    -- { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
    -- { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
    -- { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
    -- { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
    -- { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
    -- { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
    -- rename tab with prompt
    { key = ",", mods = "LEADER",
      action = wezterm.action.PromptInputLine {
          description = "Enter new name for tab",
          action = wezterm.action_callback(function(window, pane, line)
              -- https://github.com/wez/wezterm/issues/522
              if line then window:active_tab():set_title(line) end
          end),
      }
    },
    { key = "[", mods = "LEADER",          action = wezterm.action.ActivateCopyMode },
}

-- config I don't understand yet :)
config.hyperlink_rules = {
    {
        -- Linkify things that look like URLs
        -- This is actually the default if you don't specify any hyperlink_rules
        regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
        format = "$0",
    },
    {
        -- Make task, diff and paste numbers clickable
        regex = "\\b([tTdDpP]\\d+)\\b",
        format = "https://fburl.com/b/$1",
    },
}
  
-- See: https://wezfurlong.org/wezterm/quickselect.html
config.quick_select_patterns = {
    -- Make task, diff and paste numbers quick-selectable
    "\\b([tTdDpP]\\d+)\\b",
}

config.tls_clients = {
    {
        name = "sb",
        remote_address = SB .. ":8098",
        bootstrap_via_ssh = SB,
    },
    {
        name = "sb_big",
        remote_address = SB_Big .. ":8099",
        bootstrap_via_ssh = SB_Big,
    },
}

return config

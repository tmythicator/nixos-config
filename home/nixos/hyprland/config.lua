-- Resolved Binary Paths from Nix
local paths = {
  dbus            = "@dbus@",
  systemctl       = "@systemctl@",
  swaybg          = "@swaybg@",
  nmApplet        = "@nmApplet@",
  blueman         = "@blueman@",
  polkit          = "@polkit@",
  fuzzel          = "@fuzzel@",
  cliphist        = "@cliphist@",
  wlCopy          = "@wlCopy@",
  ghostty         = "@ghostty@",
  hyprlock        = "@hyprlock@",
  pkill           = "@pkill@",
  swayncClient    = "@swayncClient@",
  wireplumber     = "@wireplumber@",
  brightnessctl   = "@brightnessctl@",
  playerctl       = "@playerctl@",
  screenshot      = "@screenshot@",
  aceSwap         = "@aceSwap@",
  split           = "@split@",
  switchBuffer    = "@switchBuffer@",
  barBg           = "@barBg@",
}

-- Monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Environment Variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")

-- Autostart essential services with palette background
hl.on("hyprland.start", function()
  hl.exec_cmd(paths.dbus .. " --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd(paths.systemctl .. " --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd(paths.swaybg .. " -c '" .. paths.barBg .. "'")
  hl.exec_cmd(paths.nmApplet .. " --indicator")
  hl.exec_cmd(paths.blueman)
  hl.exec_cmd(paths.polkit)
end)

-- Look, Feel, and Inputs
hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    layout = "dwindle",
  },
  decoration = {
    rounding = 4,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      new_optimizations = true,
      ignore_opacity = true,
    },
    shadow = {
      enabled = true,
      range = 8,
      render_power = 2,
    },
  },
  group = {
    groupbar = {
      font_family = "JetBrainsMono Nerd Font",
      font_size = 10,
      gradients = false,
    },
  },
  input = {
    kb_layout = "us,de,ru",
    kb_options = "ctrl:nocaps,grp:win_space_toggle",
    follow_mouse = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  dwindle = {
    preserve_split = true,
  },
  cursor = {
    no_hardware_cursors = 2,
  },
  misc = {
    disable_hyprland_logo = true,
  },
})

-- Load Dynamic Theme Colors
dofile(os.getenv("HOME") .. "/.config/hypr/theme.lua")

-- Animations & Curves
hl.curve("snappy", { type = "bezier", points = { { 0.15, 0.9 }, { 0.2, 1.0 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "snappy" })

-- Keybindings Configuration
local mod = "SUPER"
local clipCmd = paths.cliphist
  .. " list | "
  .. paths.fuzzel
  .. " -d --prompt 'clip: ' | "
  .. paths.cliphist
  .. " decode | "
  .. paths.wlCopy

-- Standard Binds
local standard_binds = {
  -- Core Apps & Actions
  { mod .. " + P", hl.dsp.exec_cmd(paths.fuzzel) },
  { mod .. " + V", hl.dsp.exec_cmd(clipCmd) },
  { mod .. " + A", hl.dsp.exec_cmd(paths.ghostty) },
  { mod .. " + E", hl.dsp.exec_cmd("emacsclient -c -n") },
  { mod .. " + 0", hl.dsp.exec_raw("movetoworkspacesilent special:minimized") },
  { mod .. " + K", hl.dsp.window.kill() },
  { mod .. " + SHIFT + E", hl.dsp.exit() },

  -- System Controls
  { mod .. " + L", hl.dsp.exec_cmd(paths.hyprlock) },
  { mod .. " + SHIFT + L", hl.dsp.exec_cmd(paths.systemctl .. " suspend") },
  { mod .. " + backslash", hl.dsp.exec_cmd(paths.pkill .. " -SIGUSR1 waybar") },
  { mod .. " + C", hl.dsp.exec_cmd(paths.swayncClient .. " -t -sw") },
  { mod .. " + SHIFT + T", hl.dsp.exec_cmd("toggle-theme") },
  { mod .. " + SHIFT + O", hl.dsp.exec_cmd(paths.aceSwap) },
  { mod .. " + RETURN", hl.dsp.window.fullscreen(1) },

  -- Screenshots
  { mod .. " + S", hl.dsp.exec_cmd(paths.screenshot .. " region") },
  { mod .. " + SHIFT + S", hl.dsp.exec_cmd(paths.screenshot .. " full") },

  -- Focus (Arrows)
  { mod .. " + left", hl.dsp.focus({ direction = "left" }) },
  { mod .. " + right", hl.dsp.focus({ direction = "right" }) },
  { mod .. " + up", hl.dsp.focus({ direction = "up" }) },
  { mod .. " + down", hl.dsp.focus({ direction = "down" }) },
  { mod .. " + O", hl.dsp.window.cycle_next() },

  -- Window Movement within Workspace (Arrows)
  { mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }) },
  { mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }) },
  { mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }) },
  { mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }) },

  -- Window Swapping with Adjacent (Arrows)
  { mod .. " + CTRL + left", hl.dsp.window.swap({ direction = "left" }) },
  { mod .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }) },
  { mod .. " + CTRL + up", hl.dsp.window.swap({ direction = "up" }) },
  { mod .. " + CTRL + down", hl.dsp.window.swap({ direction = "down" }) },

  -- Window Tabs / Groups
  { mod .. " + G", hl.dsp.group.toggle() },
  { mod .. " + bracketleft", hl.dsp.group.prev() },
  { mod .. " + bracketright", hl.dsp.group.next() },
}

for _, b in ipairs(standard_binds) do
  hl.bind(b[1], b[2])
end

-- Window Cycling (Next + Bring to Top)
local function cycle_top(prev)
  local dsp = prev and hl.dsp.exec_raw("cyclenext prev") or hl.dsp.window.cycle_next()
  return function()
    hl.dispatch(dsp)
    hl.dispatch(hl.dsp.window.bring_to_top())
  end
end

hl.bind(mod .. " + TAB", cycle_top(false))
hl.bind(mod .. " + SHIFT + TAB", cycle_top(true))

-- Workspaces 1..9
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
  hl.bind(mod .. " + CTRL + " .. i, hl.dsp.exec_raw("movetoworkspacesilent " .. i))
end

-- Hardware, Media, and Resizing Keys
local default_sink = "@" .. "DEFAULT_AUDIO_SINK@"
local media_binds = {
  -- Repeating Volume & Brightness
  { "XF86AudioRaiseVolume", hl.dsp.exec_cmd(paths.wireplumber .. " set-volume -l 1.5 " .. default_sink .. " 5%+"), { repeating = true } },
  { "XF86AudioLowerVolume", hl.dsp.exec_cmd(paths.wireplumber .. " set-volume " .. default_sink .. " 5%-"), { repeating = true } },
  { "XF86MonBrightnessUp",  hl.dsp.exec_cmd(paths.brightnessctl .. " set +5%"), { repeating = true } },
  { "XF86MonBrightnessDown",hl.dsp.exec_cmd(paths.brightnessctl .. " set 5%-"), { repeating = true } },

  -- Locked Media Controls
  { "XF86AudioMute",        hl.dsp.exec_cmd(paths.wireplumber .. " set-mute " .. default_sink .. " toggle"), { locked = true } },
  { "XF86AudioMicMute",     hl.dsp.exec_cmd("toggle-mic"), { locked = true } },
  { "XF86AudioPlay",        hl.dsp.exec_cmd(paths.playerctl .. " play-pause"), { locked = true } },
  { "XF86AudioNext",        hl.dsp.exec_cmd(paths.playerctl .. " next"), { locked = true } },
  { "XF86AudioPrev",        hl.dsp.exec_cmd(paths.playerctl .. " previous"), { locked = true } },

  -- Repeating Window Resizing (Arrows)
  { mod .. " + ALT + right",hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true } },
  { mod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true } },
  { mod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true } },
  { mod .. " + ALT + up",   hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true } },

  -- Mouse Window Drag / Resize
  { mod .. " + mouse:272",  hl.dsp.window.drag(), { mouse = true } },
  { mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true } },
}

for _, b in ipairs(media_binds) do
  hl.bind(b[1], b[2], b[3])
end

-- Emacs Chording Submap (SUPER + X)
hl.bind(mod .. " + X", hl.dsp.submap("emacs_x"))

hl.define_submap("emacs_x", function()
  local function chord(key, action)
    hl.bind(key, function()
      if type(action) == "function" then
        action()
      else
        hl.dispatch(action)
      end
      hl.dispatch(hl.dsp.submap("reset"))
    end)
  end

  local chords = {
    { "0", function()
      hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized" }))
      hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
    end },
    { "1",           hl.dsp.window.fullscreen(1) },
    { "2",           hl.dsp.exec_cmd(paths.split .. " d") },
    { "3",           hl.dsp.exec_cmd(paths.split .. " r") },
    { "4",           hl.dsp.exec_cmd(paths.split .. " d") },
    { "b",           hl.dsp.exec_cmd(paths.switchBuffer) },
    { "B",           hl.dsp.exec_cmd(paths.switchBuffer) },
    { "k",           hl.dsp.window.close() },
    { "K",           hl.dsp.window.close() },
    { "o",           hl.dsp.window.cycle_next() },
    { "O",           hl.dsp.window.cycle_next() },
    { "G",           hl.dsp.submap("reset") },
    { "escape",      hl.dsp.submap("reset") },
    { "SUPER + X",   hl.dsp.submap("reset") },
  }

  for _, c in ipairs(chords) do
    chord(c[1], c[2])
  end
end)

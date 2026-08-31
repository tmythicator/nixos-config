{ ... }:
{
  home.file.".aerospace.toml".text = ''
    # Automatically start AeroSpace on login
    start-at-login = true

    # Layout
    default-root-node-layout = 'tiles'
    default-root-node-orientation = 'auto'
    automatically-unhide-macos-hidden-apps = true

    # Gaps
    [gaps]
    inner.horizontal = 8
    inner.vertical   = 8
    outer.left       = 8
    outer.bottom     = 8
    outer.top        = 8
    outer.right      = 8

    # Mouse
    [exec]
    inherit-env-vars = true

    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    # Window filter rules
    [[on-window-detected]]
    if.app-id = 'com.apple.systempreferences'
    run = 'layout floating'

    [[on-window-detected]]
    if.app-id = 'com.apple.ArchiveUtility'
    run = 'layout floating'

    [[on-window-detected]]
    if.app-id = 'org.keepassxc.keepassxc'
    run = 'layout floating'

    # Keybindings
    [mode.main.binding]

    # Core Applications
    alt-a = 'exec-and-forget open -n -a Alacritty'
    alt-t = 'exec-and-forget open -n -a Alacritty'
    alt-enter = 'exec-and-forget open -n -a Alacritty'
    alt-e = 'exec-and-forget emacsclient -c -n || open -a Emacs'
    alt-p = 'exec-and-forget open -a Raycast || osascript -e "tell application \"System Events\" to key code 49 using {command down}"'

    # Window State
    alt-k = 'close'
    alt-return = 'fullscreen'
    alt-g = 'layout tiles horizontal vertical'
    alt-shift-space = 'layout floating tiling'
    alt-shift-r = 'reload-config'

    # Screenshots
    alt-s = 'exec-and-forget open -a Screenshot'
    alt-shift-s = 'exec-and-forget screencapture -c'

    # Focus Navigation
    alt-left  = 'focus left'
    alt-down  = 'focus down'
    alt-up    = 'focus up'
    alt-right = 'focus right'
    alt-b     = 'focus left'
    alt-n     = 'focus down'
    alt-u     = 'focus up'
    alt-f     = 'focus right'

    # Window Movement
    alt-shift-left  = 'move left'
    alt-shift-down  = 'move down'
    alt-shift-up    = 'move up'
    alt-shift-right = 'move right'
    alt-shift-b     = 'move left'
    alt-shift-n     = 'move down'
    alt-shift-u     = 'move up'
    alt-shift-f     = 'move right'

    # Window Resizing
    alt-r = 'mode resize'
    alt-ctrl-left  = 'resize width -40'
    alt-ctrl-right = 'resize width +40'
    alt-ctrl-down  = 'resize height +40'
    alt-ctrl-up    = 'resize height -40'
    alt-ctrl-b     = 'resize width -40'
    alt-ctrl-f     = 'resize width +40'
    alt-ctrl-n     = 'resize height +40'
    alt-ctrl-u     = 'resize height -40'

    # Workspaces
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'

    # Move Window to Workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'

    # Emacs Chording Submap
    alt-x = 'mode emacs_x'

    # Submap: emacs_x
    [mode.emacs_x.binding]
    1 = ['fullscreen', 'mode main']
    2 = ['split vertical', 'mode main']
    3 = ['split horizontal', 'mode main']
    k = ['close', 'mode main']
    o = ['focus right', 'mode main']
    0 = ['move-node-to-workspace 9', 'mode main']
    b = ['exec-and-forget open -n -a Alacritty', 'mode main']
    t = ['layout tiles horizontal vertical', 'mode main']
    esc = 'mode main'
    g = 'mode main'
    alt-x = 'mode main'

    # Submap: resize
    [mode.resize.binding]
    left  = 'resize width -40'
    right = 'resize width +40'
    down  = 'resize height +40'
    up    = 'resize height -40'
    b     = 'resize width -40'
    f     = 'resize width +40'
    n     = 'resize height +40'
    u     = 'resize height -40'
    esc   = 'mode main'
    enter = 'mode main'
  '';
}

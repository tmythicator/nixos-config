{ ... }:
{
  xdg.configFile."aerospace/aerospace.toml".text = ''
    # AeroSpace Configuration for macOS
    start-at-login = true

    # Layout defaults
    accordion-padding = 30
    default-root-container-layout = 'tiles'
    default-root-container-orientation = 'auto'

    # Gaps
    [gaps]
    inner.horizontal = 6
    inner.vertical = 6
    outer.left = 6
    outer.bottom = 6
    outer.top = 6
    outer.right = 6

    # Keybindings
    [mode.main.binding]
    # Launchers
    alt-a = 'exec-and-forget open -a Alacritty'
    alt-e = 'exec-and-forget emacsclient -c -n'

    # Focus movement
    alt-b = 'focus left'
    alt-f = 'focus right'
    alt-n = 'focus down'
    alt-p = 'focus up'

    # Alt-Tab window switching
    alt-tab = 'focus-back-and-forth'
    alt-shift-tab = 'focus --dfs-prev'

    # Window movement
    alt-shift-b = 'move left'
    alt-shift-f = 'move right'
    alt-shift-n = 'move down'
    alt-shift-p = 'move up'

    # Resize
    alt-minus = 'resize smart -50'
    alt-equal = 'resize smart +50'

    # Workspaces
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'

    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'

    # Emacs chords
    alt-x = 'mode emacs_x'

    [mode.emacs_x.binding]
    o = ['focus --dfs-next', 'mode main']
    zero = ['move-node-to-workspace 9', 'mode main']
    k = ['close', 'mode main']
    one = ['fullscreen', 'mode main']
    two = ['split vertical', 'mode main']
    three = ['split horizontal', 'mode main']
    esc = 'mode main'
    alt-x = 'mode main'
  '';
}

DIR="${1:-d}"
hyprctl dispatch "hl.dsp.exec_raw('fullscreen 0')"
hyprctl dispatch "hl.dsp.exec_raw('layoutmsg preselect $DIR')"
ghostty &

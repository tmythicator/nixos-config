if [ "$(cat "$HOME/.config/timcha-theme/mode" 2>/dev/null)" = "light" ]; then
  printf '{"text":"Light","class":"light","tooltip":"Theme: Light\\nClick to toggle"}\n'
else
  printf '{"text":"Dark","class":"dark","tooltip":"Theme: Dark\\nClick to toggle"}\n'
fi

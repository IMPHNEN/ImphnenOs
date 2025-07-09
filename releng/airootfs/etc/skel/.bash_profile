if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
  exec maomao
fi

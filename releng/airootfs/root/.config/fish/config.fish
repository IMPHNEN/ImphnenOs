function fish_greeting
  chafa ~/.config/fish/banner.png
end

function neofetch
  fastfetch --logo ~/.config/fastfetch/malas.gif --logo-type kitty-direct --logo-animate
end

if status is-login
   if test -z "$DISPLAY" -a (tty) = /dev/tty1
     exec maomao
     #exec dbus-run-session startx --keeptty
     #exec run_dwl
   end
end


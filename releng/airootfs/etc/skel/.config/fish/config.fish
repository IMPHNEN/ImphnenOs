function fish_greeting
  chafa ~/.config/maomao/banner.png
end

function neofetch
  fastfetch --logo ~/.config/fastfetch/malas.gif --logo-type kitty-direct --logo-animate
end

if status is-login
     exec maomao
     #exec dbus-run-session startx --keeptty
     #exec run_dwl
end


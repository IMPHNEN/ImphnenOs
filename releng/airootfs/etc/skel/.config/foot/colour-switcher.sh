#!/bin/bash

scheme_path="${XDG_STATE_HOME:-$HOME/.local/state}/caelestia/scheme/current.txt"
schemes="$(dirname "$0")/schemes"
config_path="$schemes/current.ini"

update() {
    cp "$schemes/template.ini" "$config_path"

    while read -r line || [ -n "$line" ]; do
        local colour=( $line )
        sed -i "s/\$${colour[0]}/${colour[1]}/g" "$config_path"
    done < "$scheme_path"

    # ex: 'regular0=0b0b0b'
    sed -n -r 's/^\w*(regular|bright)([0-9])=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3 \4 \5/p' "$config_path" |
        while read color_type idx r g b; do
            if [ "$color_type" = 'bright' ]; then
                idx="$((idx + 8))"
            fi
            echo -ne "\x1b]4;$idx;rgb:$r/$g/$b\x1b\\"
        done
    # ex: 'custom0=0b0b0b'
    sed -n -r 's/^\w*custom([0-9])=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3 \4/p' "$config_path" |
        while read idx r g b; do
            echo -ne "\x1b]4;$((idx + 16));rgb:$r/$g/$b\x1b\\"
        done
    # ex: 'foreground=ffffff'
    sed -n -r 's/^\w*foreground=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$config_path" |
        while read r g b; do
            echo -ne "\x1b]10;rgb:$r/$g/$b\x1b\\"
        done
    # ex: 'background=0b0b0b'
    sed -n -r 's/^\w*background=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$config_path" |
        while read r g b; do
            echo -ne "\x1b]11;rgb:$r/$g/$b\x1b\\"
        done
    # ex: 'cursor=0b0b0b'
    sed -n -r 's/^\w*cursor=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$config_path" |
        while read r g b; do
            echo -ne "\x1b]12;rgb:$r/$g/$b\x1b\\"
        done
	# ex: 'selection=0b0b0b'
    sed -n -r 's/^\w*selection=([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2}).*/\1 \2 \3/p' "$config_path" |
        while read r g b a; do
            echo -ne "\x1b]17;rgb:$r/$g/$b\x1b\\"
        done
}

update

inotifywait -q -e 'close_write,moved_to,create' -m "$(dirname "$scheme_path")" | while read -r dir events file; do
    if test "$dir$file" = "$scheme_path"; then
        update
    fi
done &

exec fish "$@"

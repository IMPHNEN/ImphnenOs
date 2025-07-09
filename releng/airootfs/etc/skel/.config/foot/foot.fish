#!/bin/fish

set -l idx (contains -i -- -- $argv)
if test -n "$idx"
    # Exec colour switcher if has -- arg
    test $idx -gt 1 && set -l foot_args $argv[..(math $idx - 1)]
    set -l cmd $argv[(math $idx + 1)..]

    /bin/foot $foot_args -- (dirname (realpath (status filename)))/colour-switcher.sh -c "$cmd"
else
    # Normal execution
    /bin/foot $argv
end

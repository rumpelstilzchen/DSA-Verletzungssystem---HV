#!/bin/bash
# prints a png file to stdout, [./vbogen.png <ko> <lep> | lp] or [./vbogen.png <ko> <lep> > bogen.png] prints/saves it.
# note: copy the bg.png file to ~/.hv/ (create dir yourself)
hv --vbogen "$@" | dot -Gbgcolor=transparent -Tpng | convert -resize 1140x - - | composite -gravity West - ~/.hv/bg.png png:-

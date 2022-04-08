set term gif size 1024,1024 animate  delay 1
set output "animation.gif"

set encoding utf8

set tmargin at screen 0.99
set bmargin at screen 0.01
set rmargin at screen 0.99
set lmargin at screen 0.01

set key  top right font ",15"
set key spacing 1.5

set title "" font "Helvetica Bold,15"

set xtics font ", 15"
set ytics font ", 15"


set xrange [-400:200]
set yrange [-200:400]


set style line 1 lc rgb 'red' pt 7 ps 2 lt 1 lw 2
set style line 2 lc rgb 'blue' pt 7 ps 2 lt 1 lw 2
set style line 3 lc rgb 'green' pt 7 ps 2 lt 1 lw 2



set format x ""
set format y ""

set xlabel "" font ",15" offset 0
set ylabel "" font ",15" offset 0



do for [i=1:5000] {   plot   "dades.dat" every::i::i u 2:3 t '' with points ls 1,\
                            "dades.dat" every::i::i u 4:5 t '' with points ls 2,\
                            "dades.dat" every::i::i u 6:7 t '' with points ls 3,\
                     "dades.dat" every::i-100::i u 2:3 t '' with line lt 1 lw 2 lc rgb 'red',\
                     "dades.dat" every::i-100::i u 4:5 t '' with line lt 1 lw 2 lc rgb 'blue',\
                     "dades.dat" every::i-100::i u 6:7 t '' with line lt 1 lw 2 lc rgb 'green',\
                     "dades.dat" every::i-3000::i u 2:3 t '' with line lt 1 lw 1 lc rgb 'red',\
                     "dades.dat" every::i-3000::i u 4:5 t '' with line lt 1 lw 1 lc rgb 'blue',\
                     "dades.dat" every::i-3000::i u 6:7 t '' with line lt 1 lw 1 lc rgb 'green'}
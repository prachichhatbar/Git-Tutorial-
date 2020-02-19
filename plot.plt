set terminal postscript color enhanced "Helvetica"

set output "plot.eps"

set style data line

set ylabel "Metric records / ETH"
set xlabel "Iteration"

plot "tmp/tmp.dat" using 1:4 title "Operator balance" lw 4,\
     "tmp/tmp.dat" using 1:5 title "Customer balance" lw 4,\
     "tmp/tmp.dat" using 1:2 title "Operator metric records" lw 4,\
     "tmp/tmp.dat" using 1:3 title "Customer metric records" lw 4

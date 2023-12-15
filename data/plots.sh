#!/bin/sh

gnuplot << ---EOF---
set term png
set output "../coe-sh-out.png"
set xlabel "Time (Timestamp Periods)"
set ylabel "Number of Simultaneous Values"
#set logscale y
set xrange [:3500]
#set yrange [100:10000]
set nokey
# set label 1 "RCU" at 0.1,10 left
# set label 2 "spinlock" at 0.5,3.0 left
# set label 3 "brlock" at 0.4,0.6 left
# set label 4 "rwlock" at 0.3,1.6 left
# set label 5 "refcnt" at 0.15,2.8 left
plot "coe.out-4.dat" w l
---EOF---

gnuplot << ---EOF---
set term png
set output "../fre-sh-out.png"
set xlabel "Store-to-Load Latency (Timestamp Periods)"
set ylabel "Number of Samples"
#set logscale y
set xrange [-200:100]
#set yrange [100:10000]
set nokey
# set label 1 "RCU" at 0.1,10 left
# set label 2 "spinlock" at 0.5,3.0 left
# set label 3 "brlock" at 0.4,0.6 left
# set label 4 "rwlock" at 0.3,1.6 left
# set label 5 "refcnt" at 0.15,2.8 left
plot "fre.sh.out.dat"
---EOF---

gnuplot << ---EOF---
set term png
set output "../rfe-sh-out.png"
set xlabel "Store-to-Load Latency (Timestamp Periods)"
set ylabel "Number of Samples"
#set logscale y
set xrange [0:200]
#set yrange [100:10000]
set nokey
# set label 1 "RCU" at 0.1,10 left
# set label 2 "spinlock" at 0.5,3.0 left
# set label 3 "brlock" at 0.4,0.6 left
# set label 4 "rwlock" at 0.3,1.6 left
# set label 5 "refcnt" at 0.15,2.8 left
plot "rfe.sh.out.dat"
---EOF---

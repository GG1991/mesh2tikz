#!/bin/bash
#
# Gives a tiks file that represents a mesh
#

if [ $# -ne 3 ]; then echo "Usage: mesh2tikz <elements.dat> <coordinates.dat> <colors.dat>"; exit 1; fi

elem_file=$1
coor_file=$2
colo_file=$3

if [ ! -e $elem_file ]; then echo "file $elem_file not exist"; exit 2; fi
if [ ! -e $coor_file ]; then echo "file $coor_file not exist"; exit 3; fi
if [ ! -e $colo_file ]; then echo "file $colo_file not exist"; exit 4; fi

nelm=$(wc -l $elem_file | awk '{print $1}')
nnod=$(wc -l $coor_file | awk '{print $1}')
ncol=$(wc -l $colo_file | awk '{print $1}')

if [ $ncol -ne $nelm ]; then echo "$colo_file should have the same number of lines than $elem_file"; exit 1; fi

mapfile -t coor < $coor_file
mapfile -t elem < $elem_file

echo "\documentclass[tikz,border=5]{standalone}"
echo "\usetikzlibrary{automata,arrows,calc,positioning}"
echo "\begin{document}"
echo "\begin{tikzpicture}[>=stealth', shorten >=1pt, auto,
    node distance=1.5cm, scale=1, 
    transform shape, align=center, 
    state/.style={circle, draw, inner sep=1pt, minimum size=0.0]}]"

for i in "${!coor[@]}"; do
 echo "\coordinate [draw=black,shift={(0,0)}] ($i) at (${coor[$i]});"
done

# poligons
for i in "${!elem[@]}"; do 
 printf "%s" "\draw [fill=blue!50] " #(0) -- (1) -- (3) -- (2);"
 for j in "${elem[i]:0:${#elem[i]}-1}"; do 
  printf "(%d) -- " $j
 done
 for j in "${elem[i]:${#elem[i]}-1:${#elem[i]}}"; do 
  printf "(%d) -- cycle;\n" $j
 done
done

# circles in nodes
for i in "${!coor[@]}"; do 
 echo "\node [fill=black, draw=none, circle, inner sep=0pt, minimum size=0.1cm,scale=0.3] at ($i) {h};"
done

echo "\end{tikzpicture}"
echo "\end{document}"

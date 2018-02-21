#!/bin/bash
#
# Gives a tiks file that represents a mesh
#
# coordinates
# 0.0,1.0
# 1.2,1.3
# ...
#
# color (#elem)
# 1 (blue)
# 2 (green)
# ...
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
mapfile -t colo < $colo_file

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
for i in $(seq 0 $((${#elem[@]}-1))); do 
 echo "${colo[i]}" | awk 'BEGIN {colo[0]="blue";colo[1]="green"}{printf("\\draw [fill=%s!50] ", colo[$1-1])}'
 echo "${elem[i]}" | awk '{for (i=0;i<NF;i++) printf("(%d) -- %s",$(i+1),(i<NF-1)?" ":"cycle;\n")}'
done

# circles in nodes
for i in "${!coor[@]}"; do 
 echo "\node [fill=black, draw=none, circle, inner sep=0pt, minimum size=0.1cm,scale=0.3] at ($i) {h};"
done

echo "\end{tikzpicture}"
echo "\end{document}"

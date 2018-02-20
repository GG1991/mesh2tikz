#!/bin/bash
#
# Gives a tiks file that represents a mesh
#

if [ $# -ne 3 ]; then
  echo "Usage: mesh2tikz <elements.dat> <coordinates.dat> <colors.dat>"
  exit 1
fi

elem_file=$1
coor_file=$2
colo_file=$3

if [ ! -e $elem_file ]; then echo "file $elem_file not exist"; exit 2; fi
if [ ! -e $coor_file ]; then echo "file $coor_file not exist"; exit 3; fi
if [ ! -e $colo_file ]; then echo "file $colo_file not exist"; exit 4; fi

echo "\documentclass[tikz,border=5]{standalone}"
echo "\begin{document}"
echo "\begin{tikzpicture}"
#echo "\coordinate [shift={(0,0)}] (n-\i-\j) at (rand*180:1/4+rnd/8);"
#echo "\draw [help lines] (n-\i-\j) -- (n-\i-\jj);"
echo "\draw [opacity=0.5,blue] (0,0) -- (1,0) -- (1,1) -- (0,1) -- cycle;"
echo "\end{tikzpicture}"
echo "\end{document}"

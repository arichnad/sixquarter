#!/bin/bash

#DEPS:  sudo apt-get install libgnustep-base-dev

gcc="gcc -O3 -fconstant-string-class=NSConstantString -I/usr/include/GNUstep -Inococoa"

$gcc -c Position.m PuzzleModel.m PuzzleSolver.m &&
$gcc -o solver solverMain.m *.o -lobjc -lgnustep-base


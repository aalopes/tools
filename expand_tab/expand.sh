#!/bin/bash
#
# converts tabs in c and h files to 4 spaces
#
# Alexandre Lopes
# 22.04.2015

for file in ./*.c ./*.h; do
    expand -t 4 $file > tmp.txt
    cp tmp.txt $file
done
rm tmp.txt

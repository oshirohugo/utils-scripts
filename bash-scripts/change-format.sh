#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage:"
    printf "\t $0 <img-dir> <from-extension> <to-extension>\n"
    exit 1
fi

FILES=$1/*.$2

FORMAT=$3
for f in $FILES; do

    filename=$(basename "$f")
    filename="${filename%.*}"   

    
    convert $f "$1/$filename.$FORMAT"
    rm $f

done

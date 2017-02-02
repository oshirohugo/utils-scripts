#!/usr/bin/env bash

DEPENDENCY_IS_PRESENT=true

type id3 >/dev/null 2>&1 || DEPENDENCY_IS_PRESENT=false

if [ ! $DEPENDENCY_IS_PRESENT ]; then
    printf "id3 is not present. Please install it before.\n"
    exit 1
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

ARTISTS=($(ls -d */))

for artist in "${ARTISTS[@]}"
do
    cd "$artist"
    ALBUNS=($(ls -d */))
    for album in "${ALBUNS[@]}"
    do
        cd "$album"
        FILES=($(ls))
        for file in "${FILES[@]}"
        do
            TITLE="${file%%.*}"
            id3 -t "$TITLE" -A "${album%/}" -a "${artist%/}" "$file"
        done
        cd ..
    done
    cd ..
done

IFS=$SAVEIFS

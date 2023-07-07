#!/usr/bin/env bash
#\ Usage: change-config.sh <key> <value> <conf-file>
#\
#\ Change value of a key in config file with the following format
#\ KEY=VALUE
#\
# Autor: oshirohugo

if [ "$#" -ne 3 ];then
    echo "Usage:"
    printf "\t%s <key> <value> <conf-file>\n" $0
    exit 1
fi

TARGET_KEY=$1
REPLACEMENT_VALUE=$2
CONFIG_FILE=$3

sed -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE

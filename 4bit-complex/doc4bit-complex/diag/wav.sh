#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "usage: $0 <name>"
    exit 1
fi


wavedrom-cli -i $1.json -s $1.svg

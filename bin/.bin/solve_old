#!/bin/bash

if [[ $# == 0 ]]
then
    echo no input file
    exit 1
fi

if ! options=$(getopt -o ro -- "$@")
then
    exit 1
fi

eval set -- "$options"

while true; do
    case "$1" in
        -o)
            echo Output Synchro Mode
            OUTPUT=1
            shift ;;
        -r)
            echo Runtime Mode
            RUNTIME=1
            shift ;;
        --)
            shift
            break ;;
    esac
done

echo Run $1

if [[ $1 =~ \.(cpp|cc)$ ]]
then
    g++ "$1" -o run -O2 -Wall -static -std=gnu++17
elif [[ $1 == *.py ]]
then
    echo '#!/usr/bin/python3' > run
    cat "$1" >> run
else
    echo "not supported file."
    exit 1
fi

if [[ $? != 0 ]]
then
    exit 1
fi

if [[ $RUNTIME != 1 ]]
then
echo =====input=====
cat input.txt
fi

ts=$(date +%s%N)
if [[ $RUNTIME == 1 ]]
then
    ./run
elif [[ $OUTPUT == 1 ]]
then
    echo =====output====
    cat input.txt | stdbuf -o 0 ./run | tee output.txt
else
    # /usr/bin/time -f "Memory usage: %M KB" ./run < input.txt > output.txt
    MEM_STRING=$( { /usr/bin/time -f "Memory usage: %M KB" ./run < input.txt > output.txt; } 2>&1 )
fi

if [[ $? != 0 ]]
then
    echo "Runtime Error!"
    exit 1
fi
tt=$((($(date +%s%N) - $ts)/1000000))

if [[ $OUTPUT != 1 && $RUNTIME != 1 ]]
then
    echo =====output====
    cat output.txt
fi

echo $MEM_STRING
echo "Time taken: $tt milliseconds"

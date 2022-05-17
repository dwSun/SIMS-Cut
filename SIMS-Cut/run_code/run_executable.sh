#!/usr/bin/env bash

if [ $# -eq 0 ];
then
    echo "Usage: $0 <run_run_config.sh> <path_to_matlab_runtime>"
    return 0
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo "Configs:"
for cfg in $(ls config*|sort); do
    echo "will run $cfg"
done

read -p "proceed(Y/N)" choice

if [ "$choice" == "Y" ]; then
    for cfg in $(ls config*|sort); do
        bash -c "export RUN_CONFIG_FILE='$cfg' && source $1 $2"
    done
fi


IFS=$SAVEIFS

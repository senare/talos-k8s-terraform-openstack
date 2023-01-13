#!/usr/bin/env bash

find . -type d -name ".terragrunt-cache"

read -n 1 -p "Do you wish to remove (y/n) ?" answer
case ${answer:0:1} in
    y|Y )
        find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
        exit;;
    No|* )
        exit;;
esac

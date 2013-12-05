#!/bin/sh

if [ -e autogitlist ]; then
    for dir in $(cat $1)
    do
        cd $dir
        if [ "$2" = "push" ]; then
            git add -A
            git commit -m "commit `hostname`"
            git push
        elif [ "$2" = "pull" ]; then
            git pull
        fi
    done
fi

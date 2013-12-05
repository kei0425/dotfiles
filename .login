if [ -e autogitlist ]; then
    for dir in $(cat autogitlist)
    do
        cd $dir
        git pull
    done
fi

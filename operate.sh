#!/bin/bash
HOME_FOLDER_FULL_RESTORE="
.vscode
"
HOME_FOLDER_SYNC_RESTORE="
code
"
if [ "$1" = "backup" ]; then

    target=/Volumes/Guangwei/backup
    mkdir -p $target
    # backup applications
    rsync -avrdl /Applications $target/Applications
    # backup home folder
    rsync -avrdl $HOME $target/userhome/
elif [ "$1" = "restore" ]; then
    # for app, only fully restore the individual apps
    for app in $(ls /Volumes/Guangwei/backup/Applications); do
        if ls /Applications/$app; then
            echo "ignoring existing app: $app"
        else
            echo "restoring $app"
            cp -r /Volumes/Guangwei/backup/Applications/$app /Applications/$app
        fi
    done
    for item in $HOME_FOLDER_SYNC_RESTORE; do
        echo "restoring $item"
        if [ -d "$HOME/$item" ]; then
            cp -r /Volumes/Guangwei/backup/userhome/$item $HOME/$item
        else
            rsync -avrdl /Volumes/Guangwei/backup/userhome/$item $HOME/$item
        fi
    done
    for item in $HOME_FOLDER_FULL_RESTORE; do
        echo "restoring $item"
        if [ -d "$HOME/$item" ]; then
            rm -rf $HOME/item
        fi
        cp -r /Volumes/Guangwei/backup/userhome/$item $HOME/$item
    done
else
    echo "unknown operation: $1. Must be backup or restore"
fi
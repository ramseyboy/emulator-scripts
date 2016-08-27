#!/bin/bash

function token() {
    local authToken=`cat ~/.emulator_console_auth_token`
    echo $authToken
}

function killDevice() {
    local authCmd="auth $1"
    local killCmd="kill"

    nc localhost $2 <<END
    $authCmd
    $killCmd
END
}

function main() {
    local devices=$($ANDROID_HOME/platform-tools/adb devices | awk 'NR>1 {print $1}')

    echo $devices

    if [ ! "$devices" ];then
       echo "No devices attached, exiting..."
       exit
    fi

    local deviceIds="$( cut -d '-' -f 2- <<< "$devices" )"

    local authToken=$(token)

    for id in $deviceIds; do
        if [ ! "$authToken" ];then
           # just to regenerate the auth token
           echo "quit" | nc localhost $id
           authToken=$(token)
        fi

        echo $id

        killDevice $authToken $id
    done
}

main
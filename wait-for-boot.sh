#!/bin/bash

adb wait-for-device

readonly BOOT_COMPLETE_CODE="1"

DEVICE_BOOT_STATUS=$(adb shell getprop sys.boot_completed | tr -d '\r')

while [ "$DEVICE_BOOT_STATUS" != "$BOOT_COMPLETE_CODE" ]
do
        echo "Device not ready"
        sleep 10
        DEVICE_BOOT_STATUS=$(adb shell getprop sys.boot_completed | tr -d '\r')
done

echo "Device boot complete"

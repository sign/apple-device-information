#!/bin/bash

set -e
set -x

BUNDLE_ID="mt.sign.DeviceInformation"
APP_FILE="DeviceInformation/Build/Build/Products/Debug-iphonesimulator/DeviceInformation.app"

[ ! -d "$APP_FILE" ] &&
xcodebuild \
  -project DeviceInformation/DeviceInformation.xcodeproj \
  -scheme DeviceInformation \
  -sdk iphonesimulator \
  -configuration Debug \
  -derivedDataPath './DeviceInformation/Build'

# Get a list of available simulators
available_simulators=$(xcrun simctl list devices available | grep -E -o '([A-Z]|[a-z]|[0-9]|-)+ \(([0-9A-F-]+)\)' | awk -F '[()]' '{print $2}')

# Iterate through each simulator
for udid in $available_simulators; do
    echo "Processing simulator with UDID: $udid"

    # Boot the simulator
    xcrun simctl boot "$udid" || true

    # Check if the simulator is fully booted
    while true; do
        if xcrun simctl list devices | grep "$udid" | grep "(Booted)"; then
            break
        fi
        sleep 1
    done

    # Install the app
    xcrun simctl install booted "$APP_FILE"

    # TODO: Iterate over orientations: portrait, landscape-left,
    # TODO: Currently, the script only runs for portrait, and couldn't find a way to set the orientation

    # Open your app
    xcrun simctl launch booted "$BUNDLE_ID"

    # Wait for the app to record the information
    sleep 10

    # Close the app
    xcrun simctl terminate booted "$BUNDLE_ID"

    # Shut down the simulator
    xcrun simctl shutdown "$udid" || true
done

echo "All simulators processed."

cp -r /Users/Shared/devices/ devices/
git add -A devices/
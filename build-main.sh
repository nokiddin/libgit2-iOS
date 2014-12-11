#!/bin/bash

mytarget="$1";
configs="${2:-Both}";

if [ "${configs}" = "Both" ]; then
configs="Debug Release";
fi

for evar in CPATH INCLUDE ; do
./envvar2xcconfig $evar > from-$evar.xcconfig
done;

for CONFIGURATION in ${configs}; do
xcodebuild -target "$mytarget" -configuration "${CONFIGURATION}";
done


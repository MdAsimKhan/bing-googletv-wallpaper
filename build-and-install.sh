#!/bin/sh
set -e
pkg="com.gathin.bingwallpaper"
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1

if [ -n "$1" ]; then
    adb connect "$1" || true
fi

if [ "$2" = "--uninstall" ] || [ "$1" = "--uninstall" ]; then
    adb uninstall "$pkg"
    echo "Uninstalled $pkg"
    exit 0
fi

(cd "$here" && ./gradlew assembleRelease -q)
apk="$here/app/build/outputs/apk/release/app-release.apk"
adb install -r "$apk"
adb shell "pm grant $pkg android.permission.WRITE_SECURE_SETTINGS 2>/dev/null; true"
adb shell "appops set $pkg AUTO_START allow 2>/dev/null; appops set $pkg APP_AUTO_START allow 2>/dev/null; appops write-settings 2>/dev/null; true"
echo "Installed $pkg and granted permissions."

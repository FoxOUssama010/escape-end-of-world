#!/usr/bin/env bash
set -e
npm install
[ -d android ] || npx cap add android
npx cap sync android
npx @capacitor/assets generate --android --iconBackgroundColor '#08030f' --splashBackgroundColor '#08030f' || true
M=android/app/src/main/AndroidManifest.xml
grep -q 'screenOrientation' $M || sed -i 's|<activity|<activity android:screenOrientation="sensorLandscape"|' $M
S=android/app/src/main/res/values/styles.xml
grep -q windowFullscreen $S || sed -i 's|<style name="AppTheme.NoActionBar"[^>]*>|&\n        <item name="android:windowFullscreen">true</item>\n        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>|' $S
cd android && chmod +x gradlew && ./gradlew assembleDebug --no-daemon
cp app/build/outputs/apk/debug/app-debug.apk ../escape-end-of-world.apk

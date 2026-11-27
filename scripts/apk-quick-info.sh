#!/usr/bin/env bash
# apk-quick-info.sh — quick first look at an APK.
# Usage: ./apk-quick-info.sh app.apk
# Needs: aapt2 on PATH (Android SDK build-tools), or set AAPT2=/path/to/aapt2
set -euo pipefail
APK="${1:-}"
if [ -z "$APK" ]; then echo "usage: $0 app.apk"; exit 1; fi
if [ ! -f "$APK" ]; then echo "not found: $APK"; exit 1; fi
AAPT2="${AAPT2:-$(command -v aapt2 || true)}"
echo "== $APK =="
ls -lh "$APK" | awk '{print "size:", $5}'
file "$APK"
if [ -n "$AAPT2" ]; then
  "$AAPT2" dump badging "$APK" | grep -E "^(package|sdkVersion|targetSdkVersion|launchable-activity|uses-permission|application-label)" || true
else
  echo "(aapt2 not found — set AAPT2=/path/to/aapt2 for package details)"
  unzip -l "$APK" | head -30
fi

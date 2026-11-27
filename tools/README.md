# Tools

The reverse engineering toolbox. Install only what the current target needs.

## Android / APK

- **apktool** — decode APK resources + smali (`apktool d app.apk`)
- **jadx** — APK to Java source (`jadx -d out app.apk`)
- **aapt2** — dump APK info: `aapt2 dump badging app.apk`
- **dex2jar + JD-GUI** — alternative dex-to-java route
- **Frida** — dynamic instrumentation (needs a rooted device or emulator)
- **adb** — pull APKs from a device: `adb shell pm path <package>`

## Native / binaries

- **Ghidra** — free decompiler (NSA), Java-based, runs anywhere
- **IDA Free / Binary Ninja** — disassemblers
- **radare2 / rizin** — CLI disassembly + analysis
- **strings / xxd / file** — first look at any unknown binary

## Web / JS

- Browser DevTools (Sources/Network) — first stop for any web game/app
- **js-beautify** — un-minify JavaScript
- **mitmproxy / Burp** — inspect network traffic (only your own traffic)

## General

- **7-Zip / unzip** — most files (APK, DOCX, etc.) are just ZIPs
- **HxD / hexdump** — raw hex view
- **Wireshark** — packet capture

Install notes for each tool live in `tools/<tool>.md` as they get used.

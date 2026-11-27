# First-pass checklist (new target)

1. What is it? File type, size, source, version.
2. `file` + `strings` — quick first look.
3. If APK: `aapt2 dump badging`, then apktool + jadx.
4. If ZIP-based: unzip and list contents.
5. Find the interesting parts: manifest/config, main code, assets, keys.
6. Write findings in `targets/<name>/notes.md` as you go — not at the end.
7. Never commit secrets, keys or someone else's full proprietary code.

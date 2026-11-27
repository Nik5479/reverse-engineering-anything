# reverse-engineering-anything

Reverse engineering workspace. Take things apart, learn how they work, rebuild.

## What goes here

- `tools/` — the RE toolbox: what each tool does, how to install/run it.
- `targets/` — one folder per thing being reversed (APK, game, app, file format).
  Each target gets its own `notes.md` with findings.
- `scripts/` — small helper scripts (APK info, decompile helpers, diff helpers).
- `notes/` — general RE notes, checklists and write-ups.

## Rules

1. Only reverse things you have a right to look at — your own apps/games,
   open-source projects, files you own, or targets with permission.
   Never publish someone else's proprietary code, keys or assets.
2. Every target folder records: what it is, where it came from, what was
   found, and what was done with the findings.
3. No secrets in the repo — no API keys, passwords, keystores or tokens.
4. Large files stay out: GitHub blocks files over 100 MB. Keep APKs/binaries
   small or link them from elsewhere.

## Quick start

Pick a target, make `targets/<name>/`, copy `targets/TEMPLATE.md` to
`targets/<name>/notes.md`, and fill it in as you go.

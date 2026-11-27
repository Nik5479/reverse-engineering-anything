# Sheru Bhai Life Simulator Game — Reverse-Engineering Notes

- **Target:** Sheru Bhai Life Simulator Game v9, com.Skorax.SheruBhaiGame, by Skorax
- **Source:** 251,834,002-byte XAPK from APKPure, decompiled with REA + jadx on 2026-11-27
- **Purpose:** Engineering reference only — original content, NOT a copy; nothing from this target was reused in any game

---

# How Sheru Bhai Life Simulator Game Was Built — Unity 6 Setup Guide

**Purpose:** Use this as a build spec to create a NEW original open-world game in Unity 6, using the same engineering setup and architecture as Sheru Bhai Life Simulator Game (com.Skorax.SheruBhaiGame, v9, by Skorax). This is a technical replication guide, NOT a copy: do not reuse Sheru Bhai's assets, models, sounds, code, package name, AdMob ID, or Firebase project. Build original content on the same engineering foundation.

All facts below were verified by decompiling the real v9 release (240 MB XAPK from APKPure) with REA + jadx on 2026-11-27.

## 1. Engine and version
- **Unity 6, version 6000.3.23f1** (6000.3.x LTS line). Install through Unity Hub.
- Modules to install: **Android Build Support** (Android SDK + NDK + the OpenJDK Unity ships).
- Scripting backend: **IL2CPP** — C# compiles to native ARM64 code (`libil2cpp.so`, 62 MB). No .NET DLLs ship in the game.
- The original was built on a Mac; the editor runs on Windows/Linux too.

## 2. Player / build settings
- Orientation: **Landscape**, fullscreen.
- Target architectures: **ARM64** only.
- Managed code stripping: **enabled** (engine code stripping on).
- Multithreaded rendering: **on** (`gfx-threading-mode=4`).
- **minSdk 32 (Android 12+), targetSdk 36.**
- Build as an **Android App Bundle (AAB)** with **Google Play Asset Delivery**: a small base APK (~27.6 MB) + install-time asset packs. Split types: `base__abi, base__density`.

## 3. Rendering and graphics
- **URP (Universal Render Pipeline)** — the standard mobile pipeline. Post-processing package for the final look.
- **ASTC texture compression** for Android textures.
- Models in **FBX** format.
- The smooth look does NOT come from the engine alone. It comes from: quality 3D models + PBR materials + lighting + post-processing. Budget time for assets, not just setup.

## 4. Unity packages and modules in use
Install/enable these (from the game's own assembly list):
- Physics — **PhysX backend**
- **AI Navigation (NavMesh)**
- Animation Rigging
- **Input System** (new)
- Post Processing
- **TextMeshPro**
- Timeline, Terrain, Visual Effect Graph
- **Vehicles module**
- **Burst Compiler** + Mathematics
- Unity Analytics, **Unity Services Core 1.18.0**
- FBX importer (`Autodesk.Fbx`)
- AR module was present but unused — skip it.
Third-party assets:
- **Behavior Designer** — behavior trees for NPC and police AI.
- **CarKit** — vehicle engine sounds (`CarKitEngineSound`).

## 5. Code architecture (the pattern to copy)
- **All game logic in C#.** The Java/Kotlin layer is only Unity's player bridge (`com/unity3d/player`) plus plugin wrappers — put **zero game logic in Java**. The game's own package contains only `R.java`.
- Organize code **by feature, one namespace per system**. Sheru Bhai has 19, all under one root (theirs is `Skorax.*`). Mirror the pattern with your own root name: `AI, Bodyguards, Gates, HomeScreen, Insta, LivingWorld, Mansion, Minimap, Phone, Powers, School, SheruBhai, Showroom, Stadium, UI, Vehicles, Wardrobe, WeaponShop, Weather`, plus a map root.
- **Singleton player** (`Player.Instance`).
- **Vehicles loaded by name** (a `VehicleLoader` that loads a vehicle when its name is requested).
- **Showroom:** display models referenced by path (`ShowroomCars/...`).
- **Mansion/house interactions driven by Animator layers** (sit on sofa, sleep in bed, play piano) — interactions are animation states, not separate scripts per object.
- **Animal spawning system**, **swimming support** (enter/exit water events).
- **Release logging: errors only** in release builds (`OnlyErrorsInRelease`).

## 6. AI, traffic, and police
- **NavMesh** for all character/vehicle movement.
- **Behavior Designer behavior trees** for NPC and police AI (chase, patrol, react).
- Keep per-system log tags while developing (theirs: `[NavMeshChecker]`, `[Road Rage]`, `[SpawnAnimals]`) — strip to errors-only for release.

## 7. Ads — two networks, no mediation
- **Google AdMob** (`GoogleMobileAds` + **UMP consent SDK** for GDPR consent).
- **Meta Audience Network** (separate SDK, `assets/audience_network/classes.dex`).
- There is **no mediation platform** (no Unity Ads, AppLovin, ironSource, Chartboost, or Vungle). The two SDKs are integrated directly, side by side.
- **Create your own AdMob account and App ID, and your own Meta app. Do NOT reuse Sheru Bhai's IDs.**
- **ANR guard (copy this idea):** a watchdog that ticks every ~100 ms and watches for ad-caused freezes; if an ad freezes the game, it disables ads (writes a flag file) instead of letting Android kill the app for ANR. This protects the Play Store rating.

## 8. Analytics and backend
- **Firebase Analytics** (C++ SDK 14.1.0) + **Unity Analytics**.
- **No game server. No in-app purchases.** The game is fully offline.
- **Create a new Firebase project for the new game. Do NOT reuse Sheru Bhai's Firebase project.**
- Lesson: analytics first, server later (or never).

## 9. Assets and size budget
Total release size ~240 MB, split like this:
| Part | Size | Contents |
|---|---|---|
| Main Unity data pack | ~188 MB | `datapack.unity3d` ~174 MB (main data), `sharedassets1.resource` ~10.5 MB, `resources.resource` ~4.3 MB |
| ARM64 native split | ~29 MB | `libil2cpp.so` 62 MB + `libunity.so` 22.7 MB + Firebase libs (uncompressed sizes) |
| Base APK | ~27.6 MB | `global-metadata.dat` 9.6 MB, dex files ~25 MB total (mostly ad/analytics SDKs), Unity default resources 3.75 MB |
| Texture pack | ~6.6 MB | `data.unity3d` (ASTC textures) |
- Assets ship as **UnityFS asset bundles, LZ4-compressed** (`.unity3d`).
- Content structure: multiple areas (beach world, stadium, airport, old village, private island, mansion), vehicles, characters, buildings — all under one consistent asset prefix (theirs is `SKX_`).
- Deliver through **Play Asset Delivery install-time packs**, not one giant APK.

## 10. Protection (optional)
- **Google Play license verification** at app start (before anything else loads).
- **C# obfuscation** (they used GUPS Obfuscator) — note: it did not rename their feature namespaces, so structure stayed readable.
- Unity's Java bridge is minified. These steps are optional for a new game; the license check is the one worth keeping.

## 11. Build order (checklist)
1. Unity Hub → install **Unity 6000.3.x + Android Build Support (IL2CPP)**.
2. Create a **3D (URP)** project.
3. Set Player Settings: landscape, ARM64, IL2CPP, stripping on, multithreaded rendering, minSdk 32, targetSdk 36.
4. Add the packages from section 4 (NavMesh, Behavior Designer, Post Processing, TextMeshPro, Burst, Vehicles).
5. Build the world: terrain/map, buildings, roads — FBX models, ASTC textures, PBR materials, lighting + post-processing.
6. Build systems one namespace at a time: Player → Vehicles → Phone → AI (NavMesh + behavior trees) → Shops/Mansion → Weather → UI/Minimap.
7. Add **AdMob + UMP consent** and **Meta Audience Network** (own IDs), plus the ANR-guard idea.
8. Add **Firebase Analytics** (own project) + Unity Analytics.
9. Set up **Play Asset Delivery** (base APK + install-time asset packs).
10. Build AAB → test on a real phone (target: Moto G85 5G, stable 30 FPS) → Play Store.

## 12. What NOT to copy
- Sheru Bhai's models, textures, sounds, maps, or code.
- Its package name (`com.Skorax.SheruBhaiGame`), AdMob App ID, or Firebase project.
- Its characters, story, or brand (white lion in a white-gold suit, "Sheru Bhai", mansion on Royal Hill).
**What to copy:** the engine version, the build settings, the package list, the feature-namespace code structure, the two-network ad setup, the analytics-only backend, and the asset-delivery split. That is the whole recipe.
---
*Source: REA + jadx analysis of Sheru Bhai Life Simulator Game v9 (251,834,002-byte XAPK, APKPure, 2026-11-27). Engine Unity 6000.3.23f1 confirmed three ways: manifest meta-data, `libunity.so` strings, and the UnityFS header of `datapack.unity3d`.*

---

Applied subset: the engineering foundation was adopted into Nik5479/unity6-game — see ENGINEERING_SETUP.md there. No Sheru assets, code, IDs or brand were copied.

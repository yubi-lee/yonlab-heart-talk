# HeartTalk MVP RC1 Handoff Summary

## RC1 Tag Information

- Release tag: `v0.1.0-rc1`
- Tag type: annotated tag
- Tag message: `HeartTalk MVP v0.1.0-rc1`
- Tag target commit: `39cfb9f docs: prepare HeartTalk MVP release candidate`
- Branch at handoff: `main`
- Remote sync state: `origin/main` matched the tag target at the time of tagging

## Current MVP Snapshot

HeartTalk MVP at RC1 includes:

- first-run onboarding
- local memory consent
- role selection
- role-aware companion tone
- today record
- local memory save / edit / delete
- growth level
- today insight
- morning brief
- 100-day synthetic growth simulation
- synthetic simulation clear
- full local reset
- simplified single-screen session flow

The product position remains: `나를 기억하는 하루 친구`.

## How to Run

Project root:

```powershell
cd D:\Views\heart_talk
```

Run locally:

```powershell
flutter pub get
flutter run
```

Android debug build:

```powershell
flutter build apk --debug
```

Useful manual Android reset for onboarding QA:

```powershell
C:\Utils\Android\SDK\platform-tools\adb.exe -s R3CX70NHJRN shell pm clear com.example.heart_talk
```

## Verification Commands

Use these commands for a fresh readiness check:

```powershell
.\scripts\verify.ps1
git diff --check
git status -sb
git log --oneline --decorate -5
```

The rc1 readiness review previously validated:

- `.\scripts\verify.ps1` PASS
- `flutter build apk --debug` PASS
- `git diff --check` PASS

## Android QA Status

Physical Android QA is complete for the current MVP slices.

Pass or pass-with-notes evidence exists for:

- first-run onboarding
- session flow
- morning brief
- local memory management
- physical restart restore
- 100-day synthetic growth simulation

Important note:

- the earlier emulator relaunch ANR remains an emulator-specific note
- the physical device restore path is the accepted product gate

## Data and Privacy Policy

Current rc1 policy remains local-only and privacy-first:

- approved memory can be stored on-device only when consent is enabled
- `shared_preferences` is non-encrypted local storage
- no Cloud AI, network transfer, analytics, sync, or account system
- no real PPG, voice, contacts, call, SMS, location, or health-data access
- synthetic simulation data must stay clearly marked as non-real
- QA evidence should avoid personal notifications, contacts, or raw private text

## Known Risks

- `shared_preferences` is not encrypted secure storage
- debug APK evidence is the current release evidence, not store signing
- emulator-specific restart ANR notes remain documented separately
- Windows CRLF / mojibake warnings may still appear in terminal output
- historical Flutter / Gradle cache-root issues have occurred before and should remain on the watchlist

## Recommended Next Milestone

Recommended follow-up milestone after RC1:

- `HT-RC1-POST-001` - small post-rc1 polish, QA follow-up, or backlog triage slice

If the team wants a product milestone instead of a maintenance milestone, keep it small, local-only, and evidence-gated.

## Resume Here

If you are picking this up later, start with:

```powershell
git status -sb
```

Then open:

```powershell
Get-Content docs\releases\HT-MVP-RC1.md
Get-Content docs\releases\HT-MVP-RC1-HANDOFF.md
```

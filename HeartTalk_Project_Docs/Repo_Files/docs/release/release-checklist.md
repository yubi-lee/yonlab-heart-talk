# Release Checklist — HeartTalk

## 1. Pre-release Quality Gate

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
git status -sb
```

## 2. Privacy Gate

```text
[ ] No real PPG data
[ ] No real voice data
[ ] No PII
[ ] No secrets
[ ] No unapproved network calls
[ ] No unapproved permissions
[ ] Logs reviewed
[ ] Non-diagnostic language only
```

## 3. Documentation Gate

```text
[ ] README updated
[ ] AGENTS.md updated if workflow changed
[ ] Relevant spec updated
[ ] Evidence log updated
[ ] Decision log updated if architecture changed
[ ] Known issues documented
```

## 4. Artifact Gate

```text
[ ] APK generated
[ ] Version recorded
[ ] Commit hash recorded
[ ] Build command recorded
[ ] Test result recorded
```

## 5. Release Decision

| Decision | Meaning |
|---|---|
| Go | Release candidate acceptable |
| Go with known issues | Non-blocking issues documented |
| No-Go | Release blocker exists |

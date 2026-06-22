# Data Flow and Retention — HeartTalk

## 1. MVP 001 Data Flow

MVP 001 uses synthetic/demo data only.

```text
Synthetic generator
→ Domain model
→ In-memory repository
→ Dashboard ViewModel
→ Flutter UI
→ Widget/domain tests
```

No real PPG, voice, health, or personally identifiable data is collected.

## 2. Future Data Flow

Future real-data features must use the following boundary.

```text
User consent
→ Local sensor adapter
→ Local preprocessing
→ Local signal quality check
→ Local inference adapter
→ Local encrypted/migration-aware storage
→ User-visible insight
→ Delete/export controls
```

## 3. Default Retention Policy

| Data | MVP 001 | Future policy |
|---|---|---|
| Synthetic heart-rate sample | transient/in-memory | not applicable |
| Real PPG raw data | not collected | minimize or avoid storage |
| Real voice raw data | not collected | minimize or avoid storage |
| Derived features | not collected | local-only, user-controlled |
| Model result | synthetic only | versioned and user-deletable |
| Logs | non-sensitive only | no raw biometric/voice data |

## 4. User Controls Required Before Real Data

- explicit consent screen
- data deletion
- local data export
- permission denial handling
- privacy notice
- local-only processing statement
- non-diagnostic disclaimer

## 5. Cloud Boundary

No real biometric data, voice data, or health-sensitive logs may be sent to cloud AI tools or analytics services unless explicitly approved through a separate privacy review.

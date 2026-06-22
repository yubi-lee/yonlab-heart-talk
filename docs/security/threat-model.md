# Threat Model — HeartTalk

## 1. Scope

Initial scope covers MVP 001 using synthetic PPG data. Future real PPG and voice processing are noted as planned high-risk expansions.

## 2. Assets

| Asset | Sensitivity |
|---|---|
| Synthetic demo data | Low |
| Source code | Internal |
| App architecture | Internal |
| Real PPG data | Sensitive |
| Real voice recordings | Sensitive |
| Derived biometric/voice features | Sensitive |
| API keys/signing keys | Secret |
| Local database | Sensitive when real data begins |

## 3. Threats

| Threat | Impact | Current control |
|---|---|---|
| Accidental upload of real biometric data | High | Explicit upload ban |
| Secret leakage in logs/prompts | High | Redaction rule |
| Over-broad AI code edits | Medium | Allowed-file scope |
| Unapproved permissions | High | Human approval required |
| Dependency risk | Medium | Approval before adding packages |
| Medical claim risk | High | Non-diagnostic language only |
| Local data leakage | Future High | Encryption design required later |

## 4. Required Review Triggers

- Adding network calls
- Adding camera/microphone permissions
- Adding local persistence
- Adding analytics/crash SDK
- Adding model files
- Adding native platform code
- Adding data export/import
- Any real sensor data handling

## 5. Security Review Checklist

```text
[ ] No real PPG data included
[ ] No real voice data included
[ ] No secrets included
[ ] No new permission added without approval
[ ] No network transmission of sensitive data
[ ] Logs do not include sensitive values
[ ] Tests use synthetic data only
[ ] No medical diagnosis or treatment claim
```

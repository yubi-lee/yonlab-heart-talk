# HeartTalk Constitution Seed

Use this as the initial content source when creating the Spec Kit constitution.

## Core Principles

### I. Privacy-First Local Processing

Raw PPG data, raw voice recordings, personally identifiable information, health-sensitive logs, API keys, and signing keys must not be uploaded to cloud AI tools or external services by default.

### II. Evidence-Gated Development

AI-generated code is accepted only when it passes the same quality gates as human-written code.

Required default gates:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

### III. Spec-First Implementation

Every feature must have:

- feature specification
- acceptance criteria
- technical plan
- atomic tasks
- test strategy
- verification evidence

### IV. Feature-First Layered Architecture

Use presentation, application, domain, data, and infrastructure/adapters layers. Domain logic must be independent from Flutter widgets and platform APIs.

### V. Adapter-Based Sensor and Inference Boundaries

Real sensors and model runtimes must be hidden behind interfaces such as `PpgCaptureAdapter`, `VoiceCaptureAdapter`, and `InferenceAdapter`.

### VI. Synthetic Data First

The first MVP uses synthetic/demo PPG-derived data only. Real sensor capture is out of scope until privacy, permission, and validation documents are approved.

### VII. Human Approval for High-Risk Changes

Human approval is required for:

- dependency additions
- destructive file operations
- database schema/migration changes
- permissions
- native platform code
- real data handling
- signing/release configuration

### VIII. Non-Diagnostic Product Language

No medical diagnosis, treatment recommendation, disease prediction, or high-risk health claim may be introduced without separate review.

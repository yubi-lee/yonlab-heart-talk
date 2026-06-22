# SPEC_KIT_PROMPTS.md

## Constitution Prompt

```text
Create the project constitution for HeartTalk using the constitution seed in docs/spec-kit/constitution_seed.md.
```

## Feature 001 Prompt

```text
Define feature 001: Synthetic PPG Heart Rate Dashboard.

Goal:
Create a Flutter dashboard that visualizes synthetic PPG-derived heart-rate samples without using real user biometric data.

Requirements:
- show current heart rate
- show 24-hour trend
- show signal quality
- show last updated time
- mark all data as synthetic/demo
- use feature-first layered architecture
- do not request camera/microphone/health/network permissions
- include domain and widget tests
```

## Technical Plan Prompt

```text
Create a technical plan for feature 001.

Constraints:
- Flutter Android-first
- synthetic in-memory repository only
- no real sensors
- no network
- no database yet
- prepare repository interfaces for later real data
- quality gates: dart format, flutter analyze, flutter test
```

## Task Prompt

```text
Generate atomic tasks for feature 001.

Each task must include:
- task id
- objective
- allowed files
- implementation notes
- acceptance criteria
- verification commands

Order:
1. domain model
2. synthetic generator
3. repository contract
4. presentation state
5. dashboard widget
6. tests
7. final verification
```

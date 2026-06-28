# HT-DESIGN-ALIGN-001 - Design Alignment Report

**Date**: 2026-06-28
**Target project**: `D:\Views\heart_talk`
**Related implementation**: `HT-COMPANION-001`
**Design source**: `Design.md` / `DESIGN.md`

## 1. Design.md Core Summary

Current `Design.md` content is short and directive rather than a complete HeartTalk product design specification. It asks the project to set up a Goorm-style design system for a Korean B2B AI operations dashboard, use oh-my-design skills if available, avoid copying Toss exactly, adapt the direction to YOnLab as trustworthy, technical, calm, and enterprise-ready, update `AGENTS.md` if needed, and avoid UI implementation.

### Product Concept

- Design.md concept: Korean B2B AI operations dashboard.
- HeartTalk concept: privacy-first Flutter daily reflection companion.
- Alignment: trustworthy, calm, and technical restraint can transfer to HeartTalk; B2B operations dashboard positioning conflicts with HeartTalk's consumer companion direction.

### User Flow

- Design.md user flow: not specified beyond design system setup.
- HeartTalk current flow: privacy notice -> demo/manual reflection input -> local deterministic reflection -> local memory consent/role/profile/todo/person memory -> keep for morning -> `내 기억` view -> clear all memory.

### Screen/UX Direction

- Design.md direction: Goorm-style, Korean, trustworthy, technical, calm, enterprise-ready; do not copy Toss exactly.
- HeartTalk current UI: functional single-screen Flutter MVP with form controls and cards; not yet a formal design system.

### Companion Role Direction

- Design.md: no companion role details.
- HeartTalk current implementation: friend, lover, family, parent, coach, teacher, listener, custom roles as companion tone/persona only.

### Memory/Growth Direction

- Design.md: no concrete memory/growth model.
- HeartTalk current implementation: local consent-gated snapshot, `shared_preferences`, deterministic growth level 0-5.

### Privacy/Security Criteria

- Design.md: no explicit privacy/security policy.
- HeartTalk current policy: local-only, consent-based storage, no server/cloud AI/analytics/sync/account/sensitive permissions, no diagnosis/treatment/risk classification.

### Follow-up Development Hints

- Build a HeartTalk-specific design system brief before major UI redesign.
- Add Design.md-based Android manual QA once the design direction is translated to HeartTalk.
- Keep enterprise-trust visual language only as a tone reference, not as a product pivot.

## 2. Gap Matrix

| Item | Design.md 기준 | 현재 구현 상태 | Status | 후속 조치 |
|---|---|---|---|---|
| 제품 콘셉트 | Korean B2B AI operations dashboard | Privacy-first daily reflection companion | Conflict | Design.md를 HeartTalk-specific companion design brief로 재작성하거나 제한 채택으로 유지 |
| 사용자 흐름 | 미정의 | Daily reflection + local memory + role + reset flow 구현 | Partial | 후속 UX spec에서 end-to-end companion journey 정의 |
| 화면/UX 방향 | Goorm-style, calm, technical, enterprise-ready | 단일 Flutter MVP 화면, 기능 중심 UI | Partial | HT-DESIGN-QA-001 또는 HT-ROLE-UX-001에서 visual hierarchy와 copy QA 정의 |
| 역할/페르소나 | 미정의 | 8개 역할 구현 | Done | 연인/부모 역할 안전 문구와 금지 표현을 docs/spec에 명시 |
| 로컬 메모리 | 미정의 | ConsentSettings + LocalMemorySnapshot + shared_preferences 구현 | Done | MEMORY-MANAGE milestone에서 category-level view/delete 강화 |
| 성장 모델 | 미정의 | deterministic level 0-5 구현 | Done | 인사이트/가이드 확장 시 진단/예측 오해 방지 문구 강화 |
| 입력 데이터 범위 | 미정의 | manual text, profile/person/todo, generated reflection, recurring keywords | Partial | 입력 가능한/금지되는 정보 범위를 UI와 manual QA에 더 명확히 표시 |
| 개인정보/보안 | 미정의 | local-only, no cloud/network/analytics/sync/account/sensitive permission | Done | shared_preferences non-encrypted risk와 encrypted storage future review 유지 |
| UI/UX | design system setup 지시 | 구현은 functional MVP, formal design system 없음 | Missing | HeartTalk-specific DESIGN.md 또는 docs/design-system.md 작성 필요 |
| 테스트/검증 | UI 구현 금지, 보고 요구 | unit/widget/verify PASS 기록 있음 | Partial | Design.md 기준 Android manual QA checklist 필요 |
| 후속 milestone | Design system setup | HT-COMPANION-001 완료 | Partial | HT-DESIGN-QA-001 우선 추천 |

## 3. Conflict Notes

- `Design.md` currently names a B2B AI operations dashboard, which is not HeartTalk's current product category.
- `Design.md` does not describe companion roles, daily reflection, local memory, growth, privacy, or emotional-safety constraints.
- Treat `Design.md` as a design-input document with transferable qualities: calm, trustworthy, technical restraint, Korean product polish.
- Do not treat `Design.md` as permission to pivot HeartTalk into an enterprise dashboard without a separate product decision.

## 4. Safety Rules For Role-Based Companion UX

- Roles are companion tone/persona only and must not claim to replace real human relationships.
- Lover and parent roles must not use dependency-inducing, obsessive, sexual, controlling, shaming, or blaming language.
- Coach/teacher roles must avoid diagnosis, treatment, risk scoring, or prescriptive mental-health judgment.
- Listener role should emphasize non-judgmental reflection without therapy claims.

## 5. Recommended Milestone Priority

1. `HT-DESIGN-QA-001`: Design.md 기준 Android manual QA checklist and HeartTalk-specific design interpretation.
2. `HT-MEMORY-MANAGE-001`: 저장 데이터 보기/삭제/카테고리 관리 강화.
3. `HT-ROLE-UX-001`: 역할별 UI/말투 경험 강화 with safety copy constraints.
4. `HT-MORNING-001`: 아침 브리프/오늘 시작 가이드.
5. `HT-INSIGHT-001`: 누적 데이터 기반 로컬 인사이트/예측/가이드, only after safety language is stricter.

## 6. Recommendation

Use `HT-DESIGN-QA-001` next. It is the safest bridge from the current ambiguous Design.md to HeartTalk-specific UX standards because it can define manual QA, design interpretation, and safety copy expectations without changing app behavior or storage.

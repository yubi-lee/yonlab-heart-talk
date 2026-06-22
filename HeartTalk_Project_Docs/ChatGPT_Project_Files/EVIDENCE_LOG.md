# EVIDENCE_LOG.md — 검증 증거 기록

이 문서는 작업 완료 증거를 기록하기 위한 템플릿이다. AI의 설명만으로는 완료 처리하지 않는다.

## Evidence Entry Template

```markdown
## EVT-YYYYMMDD-001 — [작업명]

### 1. 작업 요약
- 목표:
- 수행자:
- 관련 spec:
- 관련 task:

### 2. 변경 파일
- `path/to/file.dart`
- `path/to/test.dart`

### 3. 실행 명령과 결과

```powershell
dart format --output=none --set-exit-if-changed .
```

결과:

```text
[출력 붙여넣기]
```

```powershell
flutter analyze
```

결과:

```text
[출력 붙여넣기]
```

```powershell
flutter test
```

결과:

```text
[출력 붙여넣기]
```

### 4. Git 상태

```powershell
git status -sb
```

결과:

```text
[출력 붙여넣기]
```

### 5. 판정
- [ ] Pass
- [ ] Pass with known issues
- [ ] Fail

### 6. 남은 리스크
- 

### 7. 다음 작업
- 
```

## 현재 상태 기록

| ID | 날짜 | 작업 | 판정 | 비고 |
|---|---|---|---|---|
| EVT-000 | 2026-06-22 | 문서 세트 생성 | Pending | 로컬 적용 후 확인 필요 |

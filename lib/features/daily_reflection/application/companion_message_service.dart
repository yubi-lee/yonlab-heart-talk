import '../domain/companion_models.dart';

class CompanionMessageService {
  const CompanionMessageService();

  String generateMessage({
    required CompanionPreference preference,
    required CompanionGrowthState growthState,
    required String reflectionSummary,
  }) {
    final roleLine = _roleLine(preference);
    final growthLine = _growthLine(growthState.level);
    final lengthLine = _lengthLine(preference.responseLength);
    final customHint =
        preference.defaultRole == CompanionRole.custom &&
            preference.customToneHint.trim().isNotEmpty
        ? ' ${preference.customToneHint.trim()}'
        : '';

    return '$roleLine $growthLine 오늘 기억할 부분은 "$reflectionSummary"예요. '
        '$lengthLine$customHint';
  }

  String _roleLine(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '친구처럼 곁에서 말해볼게요.';
      case CompanionRole.lover:
        return '연인처럼 다정하지만 부담 없이 말해볼게요.';
      case CompanionRole.family:
        return '가족처럼 편안한 온도로 말해볼게요.';
      case CompanionRole.parent:
        return '부모처럼 든든하고 조심스럽게 말해볼게요.';
      case CompanionRole.coach:
        return '코치처럼 다음 한 걸음을 작게 잡아볼게요.';
      case CompanionRole.teacher:
        return '선생님처럼 차분히 정리해서 말해볼게요.';
      case CompanionRole.listener:
        return '경청자처럼 판단하지 않고 먼저 들어볼게요.';
      case CompanionRole.custom:
        final label = preference.customRoleName.trim().isEmpty
            ? '사용자 지정 companion'
            : preference.customRoleName.trim();
        return '$label 역할로 맞춰 말해볼게요.';
    }
  }

  String _growthLine(int level) {
    if (level <= 0) {
      return '아직 저장된 기억은 없어서 지금 적어준 내용만 볼게요.';
    }
    if (level <= 2) {
      return '조금씩 쌓인 기억을 바탕으로 오늘의 흐름을 살펴볼게요.';
    }
    if (level <= 4) {
      return '며칠간 쌓인 기억을 참고해서 더 익숙한 톤으로 정리할게요.';
    }
    return '충분히 쌓인 기억을 바탕으로 익숙한 하루 리듬을 함께 볼게요.';
  }

  String _lengthLine(CompanionResponseLength length) {
    switch (length) {
      case CompanionResponseLength.short:
        return '한 문장만 남기면, 내일은 아주 작은 시작이면 충분해요.';
      case CompanionResponseLength.medium:
        return '오늘은 여기서 멈춰도 괜찮고, 내일은 아주 작은 시작이면 충분해요.';
      case CompanionResponseLength.long:
        return '오늘의 흐름을 전부 해결하려 하지 않아도 괜찮아요. 내일은 가장 작은 한 걸음만 다시 보이면 충분해요.';
    }
  }
}

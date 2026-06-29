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

    return '$roleLine $growthLine 오늘 남긴 기억에는 "$reflectionSummary" 같은 흐름이 보여요. '
        '$lengthLine$customHint';
  }

  String _roleLine(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '친구처럼 부담 없이 같이 돌아볼게요.';
      case CompanionRole.lover:
        return '연인처럼 다정하되 기대게 만들지 않는 톤으로 말해볼게요.';
      case CompanionRole.family:
        return '가족처럼 편안하고 익숙한 말투로 함께 볼게요.';
      case CompanionRole.parent:
        return '부모처럼 챙기되 통제하지 않는 말투로 함께할게요.';
      case CompanionRole.coach:
        return '코치처럼 다음 첫 걸음을 작게 잡아볼게요.';
      case CompanionRole.teacher:
        return '선생님처럼 차분하게 흐름을 정리해볼게요.';
      case CompanionRole.listener:
        return '경청자처럼 판단보다 듣는 쪽에 더 가까이 있을게요.';
      case CompanionRole.custom:
        final label = preference.customRoleName.trim().isEmpty
            ? '사용자 지정 companion'
            : preference.customRoleName.trim();
        return '$label 톤에 맞춰 조심스럽게 말해볼게요.';
    }
  }

  String _growthLine(int level) {
    if (level <= 0) {
      return '아직 쌓인 기억이 많지 않아서 지금 적어준 내용부터 볼게요.';
    }
    if (level <= 2) {
      return '조금씩 쌓인 기억을 바탕으로 오늘의 흐름을 함께 짚어볼게요.';
    }
    if (level <= 4) {
      return '며칠간 쌓인 기억을 참고해서 더 이어지는 말로 정리해볼게요.';
    }
    return '충분히 쌓인 기억을 바탕으로 익숙한 하루 리듬까지 함께 볼게요.';
  }

  String _lengthLine(CompanionResponseLength length) {
    switch (length) {
      case CompanionResponseLength.short:
        return '한 문장만 남겨도 내일은 아주 작은 시작이면 충분해요.';
      case CompanionResponseLength.medium:
        return '오늘은 여기까지만 붙잡고, 내일은 아주 작은 시작으로 이어가면 충분해요.';
      case CompanionResponseLength.long:
        return '오늘의 흐름을 다 해결하려 하기보다, 내일 다시 보일 가장 작은 한 걸음만 남겨두면 충분해요.';
    }
  }
}

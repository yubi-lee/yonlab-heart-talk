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
    final customHint = preference.defaultRole == CompanionRole.custom
        ? ' ${preference.customToneDescriptor} 정리해볼게요.'
        : '';

    return '$roleLine $growthLine 오늘 남긴 기억에는 "$reflectionSummary" 같은 흐름이 보여요. '
        '$lengthLine$customHint';
  }

  String _roleLine(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '친구처럼 편하게 얘기를 이어가볼게요.';
      case CompanionRole.lover:
        return '연인처럼 다정하게 응원하되 기대거나 조급해지지 않게 곁에서 볼게요.';
      case CompanionRole.family:
        return '가족처럼 익숙하고 편안한 말투로 오늘을 함께 볼게요.';
      case CompanionRole.parent:
        return '부모처럼 생활을 챙기되 통제하지 않는 말투로 함께할게요.';
      case CompanionRole.coach:
        return '코치처럼 다음 첫 걸음이 보이게 시작점을 같이 잡아볼게요.';
      case CompanionRole.teacher:
        return '선생님처럼 차근차근 흐름을 정리해볼게요.';
      case CompanionRole.listener:
        return '경청자처럼 판단보다 짧은 반응과 질문으로 곁에 있을게요.';
      case CompanionRole.custom:
        return '${preference.roleDisplayName} 톤에 맞춰 ${preference.customToneDescriptor} 도와드릴게요.';
    }
  }

  String _growthLine(int level) {
    if (level <= 0) {
      return '아직 쌓인 기억이 많지 않아도 지금 적어준 내용부터 가볍게 볼게요.';
    }
    if (level <= 2) {
      return '조금씩 쌓인 기억을 바탕으로 오늘의 흐름을 함께 짚어볼게요.';
    }
    if (level <= 4) {
      return '며칠간 쌓인 기억을 참고해서 오늘과 내일이 이어지는 지점을 정리해볼게요.';
    }
    return '충분히 쌓인 기억을 바탕으로 익숙한 하루 흐름까지 함께 볼게요.';
  }

  String _lengthLine(CompanionResponseLength length) {
    switch (length) {
      case CompanionResponseLength.short:
        return '한 문장만 붙잡고, 내일은 아주 작은 시작 하나만 떠올리면 충분해요.';
      case CompanionResponseLength.medium:
        return '오늘은 여기까지만 붙잡고, 내일은 아주 작은 시작으로 이어가면 충분해요.';
      case CompanionResponseLength.long:
        return '오늘의 흐름을 다 해결하려 하기보다, 내일 다시 꺼내볼 수 있는 가장 작은 첫걸음만 남겨두면 충분해요.';
    }
  }
}

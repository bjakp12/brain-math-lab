// Adaptive engine sesuai PRD Fase 4:
// - nextLevel = clamp(current ± 1) berdasar p(correct) > .75 / < .55
// - mastery: 3x benar beruntun -> unlock + badge
// - SM-2 sederhana untuk review soal salah (interval hari).
import 'dart:math';

class AdaptiveState {
  final Map<String, int> levelByCategory;
  final Map<String, int> streakByCategory;
  final Map<String, List<String>> reviewQueue;
  const AdaptiveState({this.levelByCategory = const {}, this.streakByCategory = const {}, this.reviewQueue = const {}});

  int levelOf(String cat, int fallback) => levelByCategory[cat] ?? fallback;
}

int nextLevel({required int current, required int maxLevel, required double pCorrect}) {
  if (pCorrect > 0.75) return min(maxLevel, current + 1);
  if (pCorrect < 0.55) return max(current - 1, 1);
  return current;
}

bool isMastery(List<bool> lastThree) =>
    lastThree.length >= 3 && lastThree.sublist(lastThree.length - 3).every((e) => e);

/// Interval SM-2 (hari) yang disederhanakan.
int sm2Interval({required int repetition, required double easiness}) {
  if (repetition <= 0) return 1;
  if (repetition == 1) return 1;
  if (repetition == 2) return 6;
  return max(1, (sm2Interval(repetition: repetition - 1, easiness: easiness) * easiness).round());
}

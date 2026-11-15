/// Амьсгалын үе шат.
enum BreathPhase { inhale, hold, exhale, holdOut }

/// Нэг үе шат: төрөл + үргэлжлэх секунд.
class BreathStep {
  const BreathStep(this.phase, this.seconds);

  final BreathPhase phase;
  final int seconds;
}

/// Амьсгалын арга: давтагдах мөчлөгийн үе шатуудын дараалал.
///
/// Анимацийн бүх тооцоолол (аль үе шат, хэр том тойрог) энд цэвэр функцээр
/// хийгдэх тул UI-гүйгээр тестлэнэ.
class BreathTechnique {
  const BreathTechnique({
    required this.id,
    required this.pattern,
    required this.steps,
  });

  /// l10n түлхүүр: `breath.<id>` ба `breath.<id>.d`.
  final String id;

  /// Хүнд ойлгомжтой тэмдэглэгээ, жишээ нь "4-6".
  final String pattern;
  final List<BreathStep> steps;

  String get titleKey => 'breath.$id';
  String get descKey => 'breath.$id.d';

  /// Нэг мөчлөгийн нийт секунд.
  int get cycleSeconds => steps.fold<int>(0, (sum, s) => sum + s.seconds);

  /// [minutes] минутад багтах мөчлөгийн тоо (дээш бөөрөнхийлнө).
  int cyclesFor(int minutes) => (minutes * 60 / cycleSeconds).ceil();

  /// Мөчлөгийн [sec]-р секундэд аль үе шат явж байгааг буцаана.
  int stepIndexAt(double sec) {
    var end = 0;
    for (var i = 0; i < steps.length; i++) {
      end += steps[i].seconds;
      if (sec < end) return i;
    }
    return steps.length - 1;
  }

  /// Одоогийн үе шат дуустал үлдсэн секунд.
  double stepRemainingAt(double sec) {
    var start = 0;
    for (var i = 0; i < steps.length; i++) {
      final end = start + steps[i].seconds;
      if (sec < end) return end - sec;
      start = end;
    }
    return 0;
  }

  /// Тойргийн харьцангуй хэмжээ ([minScale]..1). Амьсгал авахад томорч,
  /// гаргахад жижгэрнэ.
  double scaleAt(double sec, {double minScale = .55}) {
    var start = 0;
    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final end = start + step.seconds;
      final isLast = i == steps.length - 1;
      if (sec < end || isLast) {
        final t = ((sec - start) / step.seconds).clamp(0.0, 1.0).toDouble();
        final eased = t * t * (3 - 2 * t); // smoothstep
        switch (step.phase) {
          case BreathPhase.inhale:
            return minScale + (1 - minScale) * eased;
          case BreathPhase.hold:
            return 1.0;
          case BreathPhase.exhale:
            return 1 - (1 - minScale) * eased;
          case BreathPhase.holdOut:
            return minScale;
        }
      }
      start = end;
    }
    return minScale;
  }
}

const BreathTechnique relaxBreathing = BreathTechnique(
  id: 'relax',
  pattern: '4-6',
  steps: [
    BreathStep(BreathPhase.inhale, 4),
    BreathStep(BreathPhase.exhale, 6),
  ],
);

const BreathTechnique boxBreathing = BreathTechnique(
  id: 'box',
  pattern: '4-4-4-4',
  steps: [
    BreathStep(BreathPhase.inhale, 4),
    BreathStep(BreathPhase.hold, 4),
    BreathStep(BreathPhase.exhale, 4),
    BreathStep(BreathPhase.holdOut, 4),
  ],
);

const BreathTechnique calmBreathing = BreathTechnique(
  id: 'calm',
  pattern: '4-7-8',
  steps: [
    BreathStep(BreathPhase.inhale, 4),
    BreathStep(BreathPhase.hold, 7),
    BreathStep(BreathPhase.exhale, 8),
  ],
);

const List<BreathTechnique> breathTechniques = [
  relaxBreathing,
  boxBreathing,
  calmBreathing,
];

/// Сонгож болох хугацаанууд (минут).
const List<int> breathDurations = [1, 3, 5];

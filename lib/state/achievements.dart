import '../core/dates.dart';
import '../models/models.dart';

/// Нэг тэмдгийн (badge) одоогийн явц.
class AchievementStatus {
  const AchievementStatus({
    required this.id,
    required this.emoji,
    required this.progress,
    required this.target,
  });

  final String id;
  final String emoji;
  final int progress;
  final int target;

  bool get achieved => progress >= target;

  /// 0.0 - 1.0
  double get ratio =>
      target <= 0 ? 1.0 : (progress / target).clamp(0.0, 1.0).toDouble();

  String get titleKey => 'ach.$id';
  String get descKey => 'ach.$id.d';
}

/// Тэмдгүүдийн жагсаалт (харуулах дараалал). Текстийг l10n-ээс
/// `ach.<id>` ба `ach.<id>.d` түлхүүрээр авна.
const List<String> achievementIds = [
  'first',
  'streak3',
  'streak7',
  'streak14',
  'streak30',
  'total10',
  'total50',
  'total100',
  'notes10',
  'moods5',
  'tags6',
  'breath5',
  'challenge30',
];

/// Хамгийн урт дараалсан өдрийн тоо (одоогийн дараалал биш, түүхэн дээд).
int longestStreak(Iterable<MoodEntry> entries) {
  final days = entries.map((e) => dateOnly(e.date)).toSet().toList()..sort();
  var best = 0;
  var run = 0;
  DateTime? prev;
  for (final d in days) {
    if (prev != null && daysBetween(prev, d) == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    prev = d;
  }
  return best;
}

/// Бүх тэмдгийн явцыг тооцоолно. Цэвэр функц тул тестлэхэд хялбар.
///
/// [challengeLogged] - 30 өдрийн сорилтод одоогоор тэмдэглэсэн өдрийн тоо,
/// [breathingSessions] - дуусгасан амьсгалын дасгалын тоо.
List<AchievementStatus> computeAchievements({
  required Iterable<MoodEntry> entries,
  required int challengeLogged,
  required int breathingSessions,
}) {
  final list = entries.toList();
  final total = list.length;
  final best = longestStreak(list);
  final withNotes = list.where((e) => e.note.trim().isNotEmpty).length;
  final moods = list.map((e) => e.mood).toSet().length;
  final tags = <String>{};
  for (final e in list) {
    tags.addAll(e.tags.where(moodTags.contains));
  }

  AchievementStatus make(String id, String emoji, int progress, int target) {
    return AchievementStatus(
      id: id,
      emoji: emoji,
      progress: progress < target ? progress : target,
      target: target,
    );
  }

  return [
    make('first', '🌱', total, 1),
    make('streak3', '🌿', best, 3),
    make('streak7', '🔥', best, 7),
    make('streak14', '💪', best, 14),
    make('streak30', '🏆', best, 30),
    make('total10', '📖', total, 10),
    make('total50', '📚', total, 50),
    make('total100', '💯', total, 100),
    make('notes10', '✍️', withNotes, 10),
    make('moods5', '🌈', moods, 5),
    make('tags6', '🏷️', tags.length, moodTags.length),
    make('breath5', '🌬️', breathingSessions, 5),
    make('challenge30', '🎯', challengeLogged, Challenge.length),
  ];
}

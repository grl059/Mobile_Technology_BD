import '../core/dates.dart';
import '../core/l10n.dart';
import '../models/models.dart';
import 'app_state.dart';

enum StatsRange { week, month, year }

/// Диаграммын нэг багана.
class StatsBucket {
  const StatsBucket({required this.label, required this.avg, required this.count});

  final String label;
  final double? avg;
  final int count;
}

class StatsResult {
  const StatsResult({
    required this.buckets,
    required this.count,
    required this.avg,
    required this.prevAvg,
    required this.topMood,
    required this.topTag,
  });

  final List<StatsBucket> buckets;
  final int count;
  final double? avg;
  final double? prevAvg;
  final MoodType? topMood;
  final String? topTag;

  /// Өмнөх үетэй харьцуулсан өөрчлөлт (хувиар). Харьцуулах өгөгдөл байхгүй бол null.
  int? get changePct {
    final a = avg;
    final b = prevAvg;
    if (a == null || b == null || b <= 0) return null;
    return (((a - b) / b) * 100).round();
  }
}

StatsResult computeStats(AppState app, StatsRange range, S s, DateTime now) {
  final today = dateOnly(now);
  late final DateTime start;
  late final DateTime end;
  late final DateTime prevStart;
  late final DateTime prevEnd;

  switch (range) {
    case StatsRange.week:
      end = today;
      start = addDays(today, -6);
      prevEnd = addDays(start, -1);
      prevStart = addDays(prevEnd, -6);
    case StatsRange.month:
      start = DateTime(today.year, today.month, 1);
      end = DateTime(today.year, today.month + 1, 0);
      prevStart = DateTime(today.year, today.month - 1, 1);
      prevEnd = addDays(start, -1);
    case StatsRange.year:
      start = DateTime(today.year, 1, 1);
      end = DateTime(today.year, 12, 31);
      prevStart = DateTime(today.year - 1, 1, 1);
      prevEnd = DateTime(today.year - 1, 12, 31);
  }

  final entries = app.entriesInRange(start, end);
  final prevEntries = app.entriesInRange(prevStart, prevEnd);

  final buckets = <StatsBucket>[];
  switch (range) {
    case StatsRange.week:
      for (var i = 0; i < 7; i++) {
        final day = addDays(start, i);
        final list = entries.where((e) => sameDay(e.date, day)).toList();
        buckets.add(StatsBucket(
          label: s.weekdayMin(day.weekday),
          avg: AppState.averageScore(list),
          count: list.length,
        ));
      }
    case StatsRange.month:
      final total = daysInMonth(today.year, today.month);
      for (var from = 1; from <= total; from += 7) {
        final to = (from + 6 > total) ? total : from + 6;
        final list =
            entries.where((e) => e.date.day >= from && e.date.day <= to).toList();
        buckets.add(StatsBucket(
          label: from == to ? '$from' : '$from-$to',
          avg: AppState.averageScore(list),
          count: list.length,
        ));
      }
    case StatsRange.year:
      for (var m = 1; m <= 12; m++) {
        final list = entries.where((e) => e.date.month == m).toList();
        buckets.add(StatsBucket(
          label: s.monthShort(m),
          avg: AppState.averageScore(list),
          count: list.length,
        ));
      }
  }

  // Хамгийн их тохиолдсон мэдрэмж ба шошго
  final moodCounts = <MoodType, int>{};
  final tagCounts = <String, int>{};
  for (final e in entries) {
    moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
    for (final t in e.tags) {
      tagCounts[t] = (tagCounts[t] ?? 0) + 1;
    }
  }
  MoodType? topMood;
  var topMoodCount = 0;
  for (final m in MoodType.values) {
    final c = moodCounts[m] ?? 0;
    if (c > topMoodCount) {
      topMood = m;
      topMoodCount = c;
    }
  }
  String? topTag;
  var topTagCount = 0;
  for (final t in moodTags) {
    final c = tagCounts[t] ?? 0;
    if (c > topTagCount) {
      topTag = t;
      topTagCount = c;
    }
  }

  return StatsResult(
    buckets: buckets,
    count: entries.length,
    avg: AppState.averageScore(entries),
    prevAvg: AppState.averageScore(prevEntries),
    topMood: topMood,
    topTag: topTag,
  );
}

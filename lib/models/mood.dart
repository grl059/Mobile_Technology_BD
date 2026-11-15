import 'package:flutter/material.dart';

import '../core/dates.dart';

/// Таван төрлийн мэдрэмж. Дараалал нь мэдрэмж сонгох хэсэгт харагдах дараалал.
enum MoodType { joyful, happy, calm, sad, angry }

extension MoodTypeX on MoodType {
  String get emoji {
    switch (this) {
      case MoodType.joyful:
        return '😄';
      case MoodType.happy:
        return '😊';
      case MoodType.calm:
        return '😌';
      case MoodType.sad:
        return '😔';
      case MoodType.angry:
        return '😠';
    }
  }

  /// Статистикт ашиглагдах оноо (1-5).
  int get score {
    switch (this) {
      case MoodType.joyful:
        return 5;
      case MoodType.happy:
        return 4;
      case MoodType.calm:
        return 3;
      case MoodType.sad:
        return 2;
      case MoodType.angry:
        return 1;
    }
  }

  Color get color {
    switch (this) {
      case MoodType.joyful:
        return const Color(0xFFF5B83D);
      case MoodType.happy:
        return const Color(0xFF79C9A5);
      case MoodType.calm:
        return const Color(0xFF78A8DE);
      case MoodType.sad:
        return const Color(0xFF8E8AC8);
      case MoodType.angry:
        return const Color(0xFFE8806F);
    }
  }

  String get labelKey => 'mood.$name';

  /// Дундаж оноог хамгийн ойр мэдрэмж болгон хөрвүүлнэ.
  static MoodType fromScore(double score) {
    final rounded = score.round().clamp(1, 5);
    return MoodType.values.firstWhere((m) => m.score == rounded);
  }

  static MoodType? parse(String? name) {
    for (final m in MoodType.values) {
      if (m.name == name) return m;
    }
    return null;
  }
}

/// Тэмдэглэлд хавсаргах боломжтой шошгууд.
const List<String> moodTags = [
  'family',
  'work',
  'health',
  'friends',
  'rest',
  'sport',
];

/// Нэг өдрийн мэдрэмжийн бүртгэл.
class MoodEntry {
  const MoodEntry({
    required this.date,
    required this.mood,
    required this.updatedAt,
    this.note = '',
    this.tags = const <String>[],
  });

  final DateTime date;
  final MoodType mood;
  final String note;
  final List<String> tags;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'date': dateKey(date),
        'mood': mood.name,
        'note': note,
        'tags': tags,
        'updated': updatedAt.millisecondsSinceEpoch,
      };

  static MoodEntry? tryParse(Map<String, dynamic> json) {
    final rawDate = json['date'];
    final rawMood = json['mood'];
    final date = parseDateKey(rawDate is String ? rawDate : null);
    final mood = MoodTypeX.parse(rawMood is String ? rawMood : null);
    if (date == null || mood == null) return null;
    final rawNote = json['note'];
    final rawTags = json['tags'];
    final tags = rawTags is List
        ? rawTags.whereType<String>().toList()
        : <String>[];
    final updated = json['updated'];
    return MoodEntry(
      date: date,
      mood: mood,
      note: rawNote is String ? rawNote : '',
      tags: tags,
      updatedAt: updated is int
          ? DateTime.fromMillisecondsSinceEpoch(updated)
          : date,
    );
  }
}

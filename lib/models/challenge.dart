import '../core/dates.dart';

/// 30 өдрийн сорилтын төлөв.
enum ChallengeStatus {
  /// Сорилт эхлээгүй.
  none,

  /// Үргэлжилж байна.
  active,

  /// 30 өдрийг бүгдийг нь тэмдэглэж дуусгасан.
  completed,

  /// 30 хоног өнгөрсөн боловч бүх өдрийг тэмдэглээгүй.
  ended,
}

/// Хэрэглэгчийн эхлүүлсэн 30 өдрийн сорилт. Зөвхөн эхлэх өдрийг хадгална;
/// явц нь тэмдэглэлүүдээс шууд тооцогдоно.
class Challenge {
  const Challenge({required this.start});

  static const int length = 30;

  final DateTime start;

  /// Сорилтын сүүлийн өдөр (оруулаад).
  DateTime get end => addDays(start, length - 1);

  Map<String, dynamic> toJson() => {'start': dateKey(start)};

  static Challenge? tryParse(Map<String, dynamic> json) {
    final raw = json['start'];
    final start = parseDateKey(raw is String ? raw : null);
    if (start == null) return null;
    return Challenge(start: start);
  }
}

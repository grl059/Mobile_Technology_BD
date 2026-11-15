/// Огнооны туслах функцууд. Бүх функц өдрийн нарийвчлалтай (цаг хасагдсан)
/// ажилладаг бөгөөд DST-ийн алдаанаас сэргийлж DateTime-ийн constructor-оор
/// тооцоолно.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Даваа гарагийг долоо хоногийн эхлэл гэж үзнэ.
DateTime startOfWeek(DateTime d) => addDays(dateOnly(d), 1 - d.weekday);

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// a-аас b хүртэлх бүтэн өдрийн тоо (b - a).
int daysBetween(DateTime a, DateTime b) {
  final ua = DateTime.utc(a.year, a.month, a.day);
  final ub = DateTime.utc(b.year, b.month, b.day);
  return ub.difference(ua).inDays;
}

String dateKey(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

DateTime? parseDateKey(String? value) {
  if (value == null) return null;
  final parts = value.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

import 'dates.dart';
import 'l10n_strings.dart';

/// Олон хэлний туслах. `S('mn')('key')` хэлбэрээр ашиглана.
/// Хэл: mn (Монгол), en (English).
class S {
  const S(this.lang);

  final String lang;

  int get _i => lang == 'en' ? 1 : 0;

  /// Хэлний өөрийн нэр (хэл сонгох жагсаалтад).
  static String nativeName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      default:
        return 'Монгол';
    }
  }

  /// Түлхүүрээр текст авна. Олдохгүй бол түлхүүрийг өөрийг нь буцаана.
  String call(String key) {
    final value = kStrings[key];
    if (value == null) return key;
    return value[_i];
  }

  /// `{name}` хэлбэрийн орлуулагчтай текст.
  String f(String key, Map<String, String> args) {
    var out = call(key);
    args.forEach((k, v) {
      out = out.replaceAll('{$k}', v);
    });
    return out;
  }

  // ---------------------------------------------------------- Огноо, цаг

  static const _weekdayFull = [
    ['Даваа', 'Мягмар', 'Лхагва', 'Пүрэв', 'Баасан', 'Бямба', 'Ням'],
    [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
  ];

  static const _weekdayShort = [
    ['Дав', 'Мяг', 'Лха', 'Пүр', 'Баа', 'Бям', 'Ням'],
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  ];

  static const _weekdayMin = [
    ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'],
    ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  ];

  static const _monthsEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _monthsEnShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// weekday: 1 = Даваа ... 7 = Ням
  String weekdayFull(int weekday) => _weekdayFull[_i][weekday - 1];
  String weekdayShort(int weekday) => _weekdayShort[_i][weekday - 1];
  String weekdayMin(int weekday) => _weekdayMin[_i][weekday - 1];

  /// Жилийн диаграммын сарын шошго.
  String monthShort(int month) {
    switch (_i) {
      case 1:
        return _monthsEnShort[month - 1];
      default:
        return '$month';
    }
  }

  String monthTitle(int year, int month) {
    switch (_i) {
      case 1:
        return '${_monthsEn[month - 1]} $year';
      default:
        return '$year оны $month сар';
    }
  }

  String shortDate(DateTime d) {
    switch (_i) {
      case 1:
        return '${_monthsEnShort[d.month - 1]} ${d.day}';
      default:
        return '${d.month} сарын ${d.day}';
    }
  }

  /// "МЯГМАР • 10 САРЫН 22"
  String dateLine(DateTime d) =>
      '${weekdayFull(d.weekday)} • ${shortDate(d)}'.toUpperCase();

  /// "2026.06.14"
  String ymd(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}.$m.$day';
  }

  /// "12 минутын өмнө", "Өчигдөр" гэх мэт.
  String relTime(DateTime time, DateTime now) {
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return call('time.now');
    if (diff.inMinutes < 60) {
      return f('time.minAgo', {'n': '${diff.inMinutes}'});
    }
    if (sameDay(now, time)) {
      return f('time.hourAgo', {'n': '${diff.inHours}'});
    }
    final days = daysBetween(time, now);
    if (days == 1) return call('time.yesterday');
    if (days < 7) return f('time.dayAgo', {'n': '$days'});
    return shortDate(time);
  }
}

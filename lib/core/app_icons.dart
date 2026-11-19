import 'package:flutter/widgets.dart';

/// Аппын бүх icon нэг дор. Phosphor Icons (https://phosphoricons.com, MIT)
/// фонтыг `assets/fonts/`-оос ачаална.
///
/// Шинэ icon нэмэх: phosphoricons.com дээр icon-оо сонгоод code point-ыг нь
/// (жишээ нь `e2c2`) хуулж, доорх загвараар нэмнэ:
/// `static const IconData house = IconData(0xe2c2, fontFamily: _regular);`
/// Шугаман (`_regular`) ба дүүргэлттэй (`_fill`) хувилбар ижил code point-той.
abstract final class AppIcons {
  static const String _regular = 'Phosphor';
  static const String _fill = 'PhosphorFill';

  // Navigation
  static const IconData house = IconData(0xe2c2, fontFamily: _regular);
  static const IconData houseFill = IconData(0xe2c2, fontFamily: _fill);
  static const IconData calendar = IconData(0xe10a, fontFamily: _regular);
  static const IconData calendarFill = IconData(0xe10a, fontFamily: _fill);
  static const IconData chart = IconData(0xe150, fontFamily: _regular);
  static const IconData chartFill = IconData(0xe150, fontFamily: _fill);
  static const IconData gear = IconData(0xe272, fontFamily: _regular);
  static const IconData gearFill = IconData(0xe272, fontFamily: _fill);

  // Ерөнхий үйлдэл
  static const IconData bell = IconData(0xe0ce, fontFamily: _regular);
  static const IconData bellRinging = IconData(0xe5e8, fontFamily: _fill);
  static const IconData back = IconData(0xe138, fontFamily: _regular);
  static const IconData forward = IconData(0xe13a, fontFamily: _regular);
  static const IconData expandMore = IconData(0xe136, fontFamily: _regular);
  static const IconData expandLess = IconData(0xe13c, fontFamily: _regular);
  static const IconData close = IconData(0xe4f6, fontFamily: _regular);
  static const IconData check = IconData(0xe182, fontFamily: _regular);
  static const IconData checkCircleFill = IconData(0xe184, fontFamily: _fill);
  static const IconData checks = IconData(0xe53a, fontFamily: _regular);
  static const IconData plus = IconData(0xe3d4, fontFamily: _regular);
  static const IconData minus = IconData(0xe32a, fontFamily: _regular);
  static const IconData edit = IconData(0xe3b4, fontFamily: _regular);
  static const IconData trash = IconData(0xe4a6, fontFamily: _regular);
  static const IconData broom = IconData(0xec54, fontFamily: _regular);
  static const IconData refresh = IconData(0xe036, fontFamily: _regular);
  static const IconData playFill = IconData(0xe3d0, fontFamily: _fill);
  static const IconData pauseFill = IconData(0xe39e, fontFamily: _fill);
  static const IconData arrowRight = IconData(0xe06c, fontFamily: _regular);
  static const IconData send = IconData(0xe398, fontFamily: _regular);
  static const IconData trendUp = IconData(0xe4ae, fontFamily: _regular);
  static const IconData trendDown = IconData(0xe4ac, fontFamily: _regular);

  // Бүртгэл, профайл
  static const IconData user = IconData(0xe4c2, fontFamily: _regular);
  static const IconData userPlus = IconData(0xe4d0, fontFamily: _regular);
  static const IconData mail = IconData(0xe218, fontFamily: _regular);
  static const IconData lock = IconData(0xe308, fontFamily: _regular);
  static const IconData eye = IconData(0xe220, fontFamily: _regular);
  static const IconData eyeSlash = IconData(0xe224, fontFamily: _regular);
  static const IconData signIn = IconData(0xe428, fontFamily: _regular);
  static const IconData signOut = IconData(0xe42a, fontFamily: _regular);
  static const IconData warning = IconData(0xe4e2, fontFamily: _regular);
  static const IconData calendarBlank = IconData(0xe108, fontFamily: _regular);

  // Тохиргоо
  static const IconData palette = IconData(0xe6c8, fontFamily: _regular);
  static const IconData smiley = IconData(0xe436, fontFamily: _regular);
  static const IconData translate = IconData(0xe4a2, fontFamily: _regular);
  static const IconData question = IconData(0xe3e8, fontFamily: _regular);
  static const IconData questionMark = IconData(0xe3e9, fontFamily: _regular);
  static const IconData info = IconData(0xe2ce, fontFamily: _regular);
  static const IconData vibrate = IconData(0xe4d8, fontFamily: _regular);
  static const IconData flag = IconData(0xe244, fontFamily: _regular);
  static const IconData sun = IconData(0xe472, fontFamily: _fill);
  static const IconData moon = IconData(0xe330, fontFamily: _fill);
  static const IconData leaf = IconData(0xe2da, fontFamily: _fill);

  // Чимэглэл, карт (дүүргэлттэй)
  static const IconData lotus = IconData(0xe6cc, fontFamily: _fill);
  static const IconData sparkle = IconData(0xe6a2, fontFamily: _fill);
  static const IconData quotes = IconData(0xe660, fontFamily: _fill);
  static const IconData flame = IconData(0xe624, fontFamily: _fill);
  static const IconData medal = IconData(0xe320, fontFamily: _fill);
  static const IconData wind = IconData(0xe5d2, fontFamily: _regular);
  static const IconData target = IconData(0xe47c, fontFamily: _fill);
  static const IconData handWaving = IconData(0xe580, fontFamily: _fill);
  static const IconData chartLineUp = IconData(0xe156, fontFamily: _fill);
  static const IconData lifebuoy = IconData(0xe63a, fontFamily: _fill);

  // Тэмдгүүд (badge)
  static const IconData plant = IconData(0xebae, fontFamily: _fill);
  static const IconData barbell = IconData(0xe0b6, fontFamily: _fill);
  static const IconData trophy = IconData(0xe67e, fontFamily: _fill);
  static const IconData bookOpen = IconData(0xe0e6, fontFamily: _fill);
  static const IconData books = IconData(0xe758, fontFamily: _fill);
  static const IconData crown = IconData(0xe614, fontFamily: _fill);
  static const IconData notePencil = IconData(0xe34c, fontFamily: _fill);
  static const IconData rainbow = IconData(0xe598, fontFamily: _fill);
  static const IconData tag = IconData(0xe478, fontFamily: _fill);
}

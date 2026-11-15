import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeMode { light, dark, nature }

/// Аппын бүх өнгийг нэг дор хадгалдаг тема өргөтгөл.
/// Widget бүр `context.pal`-аар дамжуулан өнгөө авна.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.page,
    required this.card,
    required this.ink,
    required this.muted,
    required this.mint,
    required this.mintInk,
    required this.forest,
    required this.onForest,
    required this.accent,
    required this.soft,
    required this.line,
    required this.highlight,
    required this.warm,
    required this.warmInk,
    required this.insight,
    required this.shadow,
  });

  final Color canvas;
  final Color page;
  final Color card;
  final Color ink;
  final Color muted;
  final Color mint;
  final Color mintInk;
  final Color forest;
  final Color onForest;
  final Color accent;
  final Color soft;
  final Color line;
  final Color highlight;
  final Color warm;
  final Color warmInk;
  final Color insight;
  final Color shadow;

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return t < 0.5 ? this : other;
  }
}

const AppPalette _nature = AppPalette(
  canvas: Color(0xFFE9EFEB),
  page: Color(0xFFF8FAF7),
  card: Color(0xFFFFFFFF),
  ink: Color(0xFF24332E),
  muted: Color(0xFF82928B),
  mint: Color(0xFFCFDFD6),
  mintInk: Color(0xFF5E7169),
  forest: Color(0xFF2D463C),
  onForest: Color(0xFFFFFFFF),
  accent: Color(0xFF5F8E79),
  soft: Color(0xFFEDF1EE),
  line: Color(0xFFE1E7E3),
  highlight: Color(0xFFE1EEE7),
  warm: Color(0xFFF3E9DE),
  warmInk: Color(0xFF615B54),
  insight: Color(0xFF303F53),
  shadow: Color(0x0F394B44),
);

const AppPalette _light = AppPalette(
  canvas: Color(0xFFF2F3F2),
  page: Color(0xFFFFFFFF),
  card: Color(0xFFFFFFFF),
  ink: Color(0xFF1F2A26),
  muted: Color(0xFF7B8782),
  mint: Color(0xFFE6F0EB),
  mintInk: Color(0xFF5C6F66),
  forest: Color(0xFF2F4A3F),
  onForest: Color(0xFFFFFFFF),
  accent: Color(0xFF4E8B6F),
  soft: Color(0xFFF1F4F2),
  line: Color(0xFFE8EBE9),
  highlight: Color(0xFFE6F1EB),
  warm: Color(0xFFF7F1E8),
  warmInk: Color(0xFF6A645C),
  insight: Color(0xFF303F53),
  shadow: Color(0x14394B44),
);

const AppPalette _dark = AppPalette(
  canvas: Color(0xFF0E1412),
  page: Color(0xFF151D1A),
  card: Color(0xFF1E2824),
  ink: Color(0xFFE8EFEB),
  muted: Color(0xFF8E9C95),
  mint: Color(0xFF24352E),
  mintInk: Color(0xFFA9BBB2),
  forest: Color(0xFF6FA78C),
  onForest: Color(0xFF0E1412),
  accent: Color(0xFF7FB89C),
  soft: Color(0xFF26322D),
  line: Color(0xFF2D3A35),
  highlight: Color(0xFF2B4238),
  warm: Color(0xFF2B2822),
  warmInk: Color(0xFFC9C2B8),
  insight: Color(0xFF25303F),
  shadow: Color(0x33000000),
);

AppPalette paletteFor(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return _light;
    case AppThemeMode.dark:
      return _dark;
    case AppThemeMode.nature:
      return _nature;
  }
}

ThemeData buildTheme(AppThemeMode mode, {bool googleFonts = true}) {
  final p = paletteFor(mode);
  final brightness =
      mode == AppThemeMode.dark ? Brightness.dark : Brightness.light;
  final base = ThemeData(brightness: brightness, useMaterial3: true);
  final TextTheme baseText =
      googleFonts ? GoogleFonts.manropeTextTheme(base.textTheme) : base.textTheme;

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: p.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.accent,
      brightness: brightness,
      surface: p.page,
    ),
    textTheme: baseText.apply(bodyColor: p.ink, displayColor: p.ink),
    extensions: <ThemeExtension<dynamic>>[p],
    dividerColor: p.line,
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: p.highlight,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.forest,
      contentTextStyle: TextStyle(color: p.onForest, fontSize: 13),
    ),
  );
}

/// Профайлын аватарын өнгөнүүд.
const List<Color> avatarColors = [
  Color(0xFF587B6B),
  Color(0xFF6C8FB5),
  Color(0xFF8E7BB5),
  Color(0xFFC08B6B),
  Color(0xFFB5738A),
  Color(0xFF7A8C99),
];

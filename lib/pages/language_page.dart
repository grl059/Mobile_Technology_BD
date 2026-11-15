import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';

/// Аппын хэл сонгох (Монгол, English, 한국어).
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('lang.title'), eyebrow: s('lang.eyebrow')),
          Center(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.highlight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '文',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: p.accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            s('lang.intro'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: p.muted, height: 1.55),
          ),
          const SizedBox(height: 22),
          SettingsCard(
            children: [
              for (final code in AppState.supportedLanguages)
                ChoiceTile(
                  key: Key('lang_$code'),
                  title: S.nativeName(code),
                  subtitle: s('lang.$code'),
                  selected: app.language == code,
                  onTap: () => app.setLanguage(code),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            s('lang.note'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: p.muted),
          ),
        ],
      ),
    );
  }
}

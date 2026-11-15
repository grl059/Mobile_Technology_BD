import 'package:flutter/material.dart';

import '../core/core.dart';
import '../widgets/widgets.dart';

/// Сэдэв сонгох: гэрэлтэй, бараан, байгалийн + төхөөрөмжийн сэдвийг дагах.
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;

    Widget choice(AppThemeMode mode, String symbol) {
      return ThemeChoice(
        mode: mode,
        title: s('theme.${mode.name}'),
        subtitle: s('theme.${mode.name}Hint'),
        symbol: symbol,
        selected: app.themeMode == mode,
        onTap: () => app.setThemeMode(mode),
      );
    }

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('theme.title'), eyebrow: s('theme.eyebrow')),
          Text(
            s('theme.intro'),
            style: TextStyle(fontSize: 13, color: p.muted, height: 1.6),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              choice(AppThemeMode.light, '☀'),
              const SizedBox(width: 8),
              choice(AppThemeMode.dark, '☾'),
              const SizedBox(width: 8),
              choice(AppThemeMode.nature, '❧'),
            ],
          ),
          GroupLabel(s('theme.colorGroup')),
          SettingsCard(
            children: [
              SettingTile(
                key: const Key('theme_follow_system'),
                title: s('theme.system'),
                subtitle: s('theme.systemHint'),
                trailing: SwitchPill(
                  value: app.followSystem,
                  onChanged: app.setFollowSystem,
                ),
                onTap: () => app.setFollowSystem(!app.followSystem),
              ),
            ],
          ),
          if (app.followSystem) ...[
            const SizedBox(height: 10),
            Text(
              s('theme.systemNote'),
              style: TextStyle(fontSize: 11, color: p.muted, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

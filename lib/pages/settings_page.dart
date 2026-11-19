import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import '../widgets/widgets.dart';
import 'about_page.dart';
import 'companion_sheet.dart';
import 'help_page.dart';
import 'language_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'reminder_page.dart';
import 'theme_page.dart';

/// Тохиргоо: профайл, сануулга, сэдэв, хэл, тусламж, бүртгэл.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final user = app.user;
    final reminder = app.reminder;
    final time = '${reminder.hour.toString().padLeft(2, '0')}:00';

    String reminderSubtitle() {
      if (!reminder.enabled) return s('settings.off');
      if (reminder.days.length >= 7) return s.f('settings.everyDay', {'time': time});
      return s.f('settings.someDays', {'n': '${reminder.days.length}', 'time': time});
    }

    final themeName =
        app.followSystem ? s('theme.system') : s('theme.${app.themeMode.name}');

    return ScreenPage(
      children: [
        PageHeader(
          eyebrow: s('settings.eyebrow'),
          title: s('settings.title'),
          onNotifications: () => openNotifications(context),
        ),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: p.mint,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Avatar(
                size: 54,
                name: user?.name ?? '',
                colorIndex: user?.avatar ?? 0,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      user?.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: p.mintInk),
                    ),
                  ],
                ),
              ),
              RoundButton(
                icon: AppIcons.edit,
                size: 40,
                tooltip: s('profile.title'),
                onTap: () => pushPage<void>(context, const ProfilePage()),
              ),
            ],
          ),
        ),
        GroupLabel(s('settings.general')),
        SettingsCard(
          children: [
            SettingTile(
              icon: AppIcons.bell,
              iconColor: const Color(0xFFB87955),
              iconBackground: const Color(0xFFFAE7DB),
              title: s('settings.notifications'),
              subtitle: reminderSubtitle(),
              trailing: SwitchPill(
                value: reminder.enabled,
                onChanged: (v) => app.setReminder(reminder.copyWith(enabled: v)),
              ),
              onTap: () => pushPage<void>(context, const ReminderPage()),
            ),
            SettingTile(
              icon: AppIcons.palette,
              iconColor: const Color(0xFF77649A),
              iconBackground: const Color(0xFFEAE4F3),
              title: s('settings.theme'),
              subtitle: themeName,
              onTap: () => pushPage<void>(context, const ThemePage()),
            ),
            SettingTile(
              key: const Key('settings_companion'),
              icon: AppIcons.smiley,
              iconColor: const Color(0xFFB8892F),
              iconBackground: const Color(0xFFFBEFD0),
              title: s('settings.companion'),
              subtitle:
                  '${s(app.companion.nameKey)} · ${s('comp.${app.companion.size.name}')}',
              onTap: () => showCompanionSheet(context),
            ),
            SettingTile(
              icon: AppIcons.translate,
              iconColor: const Color(0xFF4D806C),
              iconBackground: const Color(0xFFDFEFE8),
              title: s('settings.language'),
              subtitle: S.nativeName(app.language),
              onTap: () => pushPage<void>(context, const LanguagePage()),
            ),
          ],
        ),
        GroupLabel(s('settings.helpGroup')),
        SettingsCard(
          children: [
            SettingTile(
              icon: AppIcons.question,
              iconColor: const Color(0xFF587C98),
              iconBackground: const Color(0xFFE1EBF3),
              title: s('settings.help'),
              onTap: () => pushPage<void>(context, const HelpPage()),
            ),
            SettingTile(
              icon: AppIcons.info,
              iconColor: const Color(0xFF967B4F),
              iconBackground: const Color(0xFFF2EAD9),
              title: s('settings.about'),
              subtitle: s.f('about.version', {'v': AboutPage.version}),
              onTap: () => pushPage<void>(context, const AboutPage()),
            ),
          ],
        ),
        GroupLabel(s('settings.account')),
        SettingsCard(
          children: [
            SettingTile(
              icon: AppIcons.broom,
              iconColor: const Color(0xFFB5604F),
              iconBackground: const Color(0xFFF7E1DC),
              title: s('settings.clearData'),
              subtitle: s('settings.clearDataHint'),
              onTap: () async {
                final ok = await confirmDialog(
                  context,
                  title: s('settings.clearTitle'),
                  message: s('settings.clearMessage'),
                  confirmLabel: s('settings.clearConfirm'),
                  danger: true,
                );
                if (!ok) return;
                app.clearAllData();
                if (context.mounted) showSnack(context, s('settings.cleared'));
              },
            ),
            SettingTile(
              key: const Key('settings_logout'),
              icon: AppIcons.signOut,
              iconColor: const Color(0xFF5E6E78),
              iconBackground: const Color(0xFFE7ECEF),
              title: s('settings.logout'),
              onTap: () async {
                final ok = await confirmDialog(
                  context,
                  title: s('settings.logoutTitle'),
                  message: s('settings.logoutMessage'),
                  confirmLabel: s('settings.logout'),
                );
                if (!ok || !context.mounted) return;
                Navigator.of(context).popUntil((route) => route.isFirst);
                AppScope.read(context).logout();
              },
            ),
          ],
        ),
      ],
    );
  }
}

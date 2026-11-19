import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../widgets/widgets.dart';

/// Өдөр тутмын сануулгын тохиргоо: асаах/унтраах, цаг, давтах өдрүүд.
class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late bool _enabled;
  late int _hour;
  late Set<int> _days;

  @override
  void initState() {
    super.initState();
    final r = AppScope.read(context).reminder;
    _enabled = r.enabled;
    _hour = r.hour;
    _days = Set<int>.of(r.days);
  }

  void _save() {
    final s = context.s;
    if (_enabled && _days.isEmpty) {
      showSnack(context, s('reminder.needDay'));
      return;
    }
    AppScope.read(context).setReminder(
      ReminderSettings(enabled: _enabled, hour: _hour, days: Set<int>.of(_days)),
    );
    showSnack(context, s('reminder.saved'));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('reminder.title'), eyebrow: s('reminder.eyebrow')),
          SoftCard(
            color: p.warm,
            child: Row(
              children: [
                IconBox(
                  icon: AppIcons.bellRinging,
                  color: const Color(0xFFB87955),
                  background: p.card,
                  size: 50,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s('reminder.banner'),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s('reminder.bannerBody'),
                        style: TextStyle(fontSize: 12, height: 1.5, color: p.warmInk),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SettingsCard(
            children: [
              SettingTile(
                key: const Key('reminder_toggle'),
                title: s('reminder.daily'),
                subtitle: s('reminder.dailyHint'),
                trailing: SwitchPill(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
                onTap: () => setState(() => _enabled = !_enabled),
              ),
            ],
          ),
          Opacity(
            opacity: _enabled ? 1 : .45,
            child: IgnorePointer(
              ignoring: !_enabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GroupLabel(s('reminder.time')),
                  SoftCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MiniButton(
                          icon: AppIcons.minus,
                          onTap: () => setState(() => _hour = (_hour + 23) % 24),
                        ),
                        Column(
                          children: [
                            Text(
                              '${_hour.toString().padLeft(2, '0')}:00',
                              key: const Key('reminder_time'),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _hour < 12 ? s('reminder.am') : s('reminder.pm'),
                              style: TextStyle(fontSize: 12, color: p.muted),
                            ),
                          ],
                        ),
                        MiniButton(
                          icon: AppIcons.plus,
                          onTap: () => setState(() => _hour = (_hour + 1) % 24),
                        ),
                      ],
                    ),
                  ),
                  GroupLabel(s('reminder.days')),
                  Row(
                    children: [
                      for (var i = 0; i < 7; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              if (_days.contains(i)) {
                                _days.remove(i);
                              } else {
                                _days.add(i);
                              }
                            }),
                            child: Container(
                              height: 44,
                              margin: EdgeInsets.only(right: i == 6 ? 0 : 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _days.contains(i) ? p.accent : p.soft,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Text(
                                s.weekdayMin(i + 1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _days.contains(i) ? Colors.white : p.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            s('reminder.note'),
            style: TextStyle(fontSize: 11, color: p.muted, height: 1.5),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            key: const Key('reminder_save'),
            icon: AppIcons.check,
            label: s('reminder.save'),
            onTap: _save,
          ),
        ],
      ),
    );
  }
}

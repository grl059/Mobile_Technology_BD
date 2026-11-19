import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'achievements_page.dart';
import 'mood_entry_sheet.dart';

void openNotifications(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const NotificationsPage()),
  );
}

/// Мэдэгдлийн төв.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static IconData _icon(String type) {
    switch (type) {
      case 'weekly':
        return AppIcons.chartLineUp;
      case 'reminder':
        return AppIcons.bellRinging;
      case 'streak':
        return AppIcons.flame;
      case 'badge':
        return AppIcons.medal;
      default:
        return AppIcons.handWaving;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final now = DateTime.now();
    final all = app.notifications;
    final unread = app.unreadCount;
    final todayItems = all.where((n) => sameDay(n.time, now)).toList();
    final olderItems = all.where((n) => !sameDay(n.time, now)).toList();

    Widget buildItem(AppNotification n) {
      final args = Map<String, String>.from(n.args);
      final moodArg = args['mood'];
      if (moodArg != null) args['mood'] = s('mood.$moodArg');
      final badgeArg = args['badge'];
      if (badgeArg != null) args['name'] = s('ach.$badgeArg');
      return Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Dismissible(
          key: ValueKey(n.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => app.removeNotification(n.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 22),
            decoration: BoxDecoration(
              color: const Color(0x26D9534F),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(AppIcons.trash, color: Color(0xFFD9534F)),
          ),
          child: NoticeCard(
            icon: _icon(n.type),
            title: s.f('notif.${n.type}.title', args),
            copy: s.f('notif.${n.type}.body', args),
            time: s.relTime(n.time, now),
            unread: !n.read,
            onTap: () {
              app.markRead(n.id);
              if (n.type == 'reminder') showMoodSheet(context);
              if (n.type == 'badge') pushPage<void>(context, const AchievementsPage());
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('notif.title'), eyebrow: s('notif.eyebrow')),
          if (all.isEmpty)
            EmptyState(
              icon: AppIcons.bell,
              title: s('notif.emptyTitle'),
              message: s('notif.emptyBody'),
            )
          else ...[
            SoftCard(
              color: p.highlight,
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.accent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: unread > 0
                        ? Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : const Icon(AppIcons.checks, color: Colors.white),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unread > 0 ? s('notif.new') : s('notif.allRead'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          unread > 0
                              ? s.f('notif.unreadHint', {'n': '$unread'})
                              : s('notif.allReadHint'),
                          style: TextStyle(fontSize: 12, color: p.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (todayItems.isNotEmpty) ...[
              GroupLabel(s('notif.today')),
              for (final n in todayItems) buildItem(n),
            ],
            if (olderItems.isNotEmpty) ...[
              GroupLabel(s('notif.earlier')),
              for (final n in olderItems) buildItem(n),
            ],
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: unread > 0 ? app.markAllRead : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: p.ink,
                side: BorderSide(color: p.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                s('notif.markAll'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () async {
                final ok = await confirmDialog(
                  context,
                  title: s('notif.clearTitle'),
                  message: s('notif.clearMessage'),
                  confirmLabel: s('notif.clear'),
                  danger: true,
                );
                if (ok) app.clearNotifications();
              },
              child: Text(
                s('notif.clear'),
                style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

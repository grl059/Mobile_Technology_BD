import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'mood_entry_sheet.dart';
import 'notifications_page.dart';

const int _quoteCount = 7;

/// Нүүр хуудас: өнөөдрийн мэдрэмж, долоо хоногийн тойм, өдрийн сануулга.
class HomePage extends StatelessWidget {
  const HomePage({required this.onSeeAll, super.key});

  /// "Бүгдийг харах" дарахад хуанли руу шилжүүлнэ.
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final now = DateTime.now();
    final today = dateOnly(now);
    final todayEntry = app.entryFor(today);
    final weekStart = startOfWeek(today);
    final streak = app.streak;
    final name = app.user?.firstName ?? '';
    final quoteIndex = daysBetween(DateTime(today.year, 1, 1), today) % _quoteCount;

    return ScreenPage(
      children: [
        PageHeader(
          eyebrow: s.dateLine(now),
          title: s.f('home.greeting', {'name': name}),
          onNotifications: () => openNotifications(context),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: p.mint,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(s('home.eyebrow'), color: p.mintInk),
              const SizedBox(height: 8),
              if (todayEntry == null) ...[
                Text(
                  s('home.question'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s('home.subtitle'),
                  style: TextStyle(fontSize: 14, height: 1.55, color: p.mintInk),
                ),
              ] else ...[
                Row(
                  children: [
                    Text(todayEntry.mood.emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.f('home.todayMood', {'mood': s(todayEntry.mood.labelKey)}),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  s('home.recorded'),
                  style: TextStyle(fontSize: 14, height: 1.55, color: p.mintInk),
                ),
              ],
              if (streak > 0) ...[
                const SizedBox(height: 12),
                Text(
                  '🔥 ${s.f('home.streak', {'n': '$streak'})}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: p.mintInk,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                key: const Key('home_add_mood'),
                onPressed: () => showMoodSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: p.forest,
                  foregroundColor: p.onForest,
                  minimumSize: const Size(0, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(todayEntry == null ? Icons.add_rounded : Icons.edit_rounded),
                label: Text(
                  todayEntry == null ? s('home.add') : s('home.edit'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        SectionHeading(
          eyebrow: s('home.weekEyebrow'),
          title: s('home.weekTitle'),
          action: s('home.seeAll'),
          onAction: onSeeAll,
        ),
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: _WeekDayCell(
                  day: addDays(weekStart, i),
                  today: today,
                  entry: app.entryFor(addDays(weekStart, i)),
                ),
              ),
          ],
        ),
        if (todayEntry != null &&
            (todayEntry.note.isNotEmpty || todayEntry.tags.isNotEmpty)) ...[
          const SizedBox(height: 22),
          SoftCard(
            onTap: () => showMoodSheet(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(s('home.todayNote')),
                if (todayEntry.note.isNotEmpty)
                  Text(
                    todayEntry.note,
                    style: const TextStyle(fontSize: 14, height: 1.55),
                  ),
                if (todayEntry.tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tag in todayEntry.tags) TagPill(s('tag.$tag')),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 22),
        SoftCard(
          color: p.warm,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '“',
                style: TextStyle(
                  fontSize: 38,
                  color: Color(0xFFBD8F69),
                  height: .9,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s('quote.$quoteIndex'),
                      style: TextStyle(fontSize: 13.5, color: p.warmInk, height: 1.55),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s('home.quoteLabel'),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFA77B5A),
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekDayCell extends StatelessWidget {
  const _WeekDayCell({
    required this.day,
    required this.today,
    required this.entry,
  });

  final DateTime day;
  final DateTime today;
  final MoodEntry? entry;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    final isToday = sameDay(day, today);
    final isFuture = day.isAfter(today);
    final showPlus = entry == null && !isFuture;
    final filled = isToday && entry == null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isFuture ? null : () => showMoodSheet(context, date: day),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isToday ? p.soft : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              s.weekdayShort(day.weekday),
              style: TextStyle(
                fontSize: 10,
                color: p.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.day}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 17,
              backgroundColor: filled ? p.forest : Colors.transparent,
              child: entry != null
                  ? Text(entry!.mood.emoji, style: const TextStyle(fontSize: 21))
                  : Text(
                      showPlus ? '+' : '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: filled ? p.onForest : p.muted,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

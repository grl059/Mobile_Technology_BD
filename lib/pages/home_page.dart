import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'achievements_page.dart';
import 'breathing_page.dart';
import 'companion_sheet.dart';
import 'mood_entry_sheet.dart';
import 'notifications_page.dart';

const int _quoteCount = 7;

/// Дарааллын (streak) галын өнгө.
const Color _flameColor = Color(0xFFE98A45);

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
        if (app.companion.size != CompanionSize.hidden) ...[
          _CompanionCard(entry: todayEntry, streak: streak),
          const SizedBox(height: 16),
        ],
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
                    fontWeight: FontWeight.w700,
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
                    MoodFace(todayEntry.mood, size: 46),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        s.f('home.todayMood', {'mood': s(todayEntry.mood.labelKey)}),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
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
                Row(
                  children: [
                    const Icon(AppIcons.flame, size: 15, color: _flameColor),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        s.f('home.streak', {'n': '$streak'}),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: p.mintInk,
                        ),
                      ),
                    ),
                  ],
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
                icon: Icon(
                  todayEntry == null ? AppIcons.plus : AppIcons.edit,
                  size: 19,
                ),
                label: Text(
                  todayEntry == null ? s('home.add') : s('home.edit'),
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                key: const Key('home_achievements'),
                icon: AppIcons.medal,
                color: const Color(0xFFD39B2C),
                title: s('home.achievements'),
                subtitle: s.f('home.achievementsSub', {
                  'n': '${app.unlockedCount}',
                  'total': '${app.achievements.length}',
                }),
                onTap: () => pushPage<void>(context, const AchievementsPage()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickCard(
                key: const Key('home_breathing'),
                icon: AppIcons.wind,
                color: p.accent,
                title: s('home.breathing'),
                subtitle: s('home.breathingSub'),
                onTap: () => pushPage<void>(context, const BreathingPage()),
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
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(AppIcons.quotes, size: 24, color: Color(0xFFBD8F69)),
              ),
              const SizedBox(width: 12),
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
                        fontWeight: FontWeight.w700,
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

/// Нүүр хуудсан дээрх найз: өнөөдрийн мэдрэмж, дарааллаас хамаарч үг хэлнэ.
class _CompanionCard extends StatelessWidget {
  const _CompanionCard({required this.entry, required this.streak});

  final MoodEntry? entry;
  final int streak;

  String _say(S s) {
    final e = entry;
    if (e == null) {
      return streak >= 3
          ? s.f('comp.say.streakAsk', {'n': '$streak'})
          : s('comp.say.ask');
    }
    switch (e.mood) {
      case MoodType.joyful:
      case MoodType.happy:
        return s('comp.say.good');
      case MoodType.calm:
        return s('comp.say.calm');
      case MoodType.sad:
        return s('comp.say.sad');
      case MoodType.angry:
        return s('comp.say.angry');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final settings = app.companion;
    final large = settings.size == CompanionSize.large;
    final mood = entry?.mood;
    final needsCalm = mood == MoodType.sad || mood == MoodType.angry;

    return SoftCard(
      key: const Key('home_companion'),
      padding: EdgeInsets.all(large ? 16 : 12),
      onTap: () => showCompanionSheet(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CompanionAvatar(
            kind: settings.kind,
            mood: mood,
            size: large ? 104 : 56,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(s('comp.my')),
                Text(
                  s(settings.nameKey),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: p.soft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _say(s),
                    style: const TextStyle(fontSize: 12.5, height: 1.5),
                  ),
                ),
                if (needsCalm)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => pushPage<void>(context, const BreathingPage()),
                      child: Text(
                        s('breath.suggestAction'),
                        style: TextStyle(color: p.accent, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Нүүр хуудасны богино холбоос карт (амжилт, амьсгал).
class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          IconBox(icon: icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: p.muted),
                ),
              ],
            ),
          ),
        ],
      ),
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
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.day}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            SizedBox.square(
              dimension: 32,
              child: entry != null
                  ? MoodFace(entry!.mood, size: 32)
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled ? p.forest : Colors.transparent,
                        border: showPlus && !filled
                            ? Border.all(color: p.line, width: 1.5)
                            : null,
                      ),
                      child: showPlus
                          ? Icon(
                              AppIcons.plus,
                              size: 15,
                              color: filled ? p.onForest : p.muted,
                            )
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

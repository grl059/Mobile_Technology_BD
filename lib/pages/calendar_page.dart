import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'mood_entry_sheet.dart';
import 'notifications_page.dart';

/// Хуанли: сар бүрийн мэдрэмж, сарын тойм, тэмдэглэлүүд.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, 1);
  }

  void _shiftMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta, 1));
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final today = dateOnly(DateTime.now());
    final isCurrentMonth = _month.year == today.year && _month.month == today.month;
    final total = daysInMonth(_month.year, _month.month);
    final leading = _month.weekday - 1; // Даваа гарагаас эхэлнэ
    final cellCount = ((leading + total + 6) ~/ 7) * 7;
    final entries = app.entriesInRange(
      _month,
      DateTime(_month.year, _month.month, total),
    );
    final byDay = <int, MoodEntry>{for (final e in entries) e.date.day: e};

    final counts = <MoodType, int>{};
    for (final e in entries) {
      counts[e.mood] = (counts[e.mood] ?? 0) + 1;
    }

    final weeks = <Widget>[];
    for (var row = 0; row < cellCount ~/ 7; row++) {
      weeks.add(
        Row(
          children: [
            for (var col = 0; col < 7; col++)
              Expanded(
                child: _buildCell(
                  index: row * 7 + col,
                  leading: leading,
                  total: total,
                  today: today,
                  byDay: byDay,
                ),
              ),
          ],
        ),
      );
    }

    return ScreenPage(
      children: [
        PageHeader(
          eyebrow: s('cal.eyebrow'),
          title: s('cal.title'),
          onNotifications: () => openNotifications(context),
        ),
        SoftCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MiniButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _shiftMonth(-1),
                  ),
                  Text(
                    s.monthTitle(_month.year, _month.month),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  MiniButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: isCurrentMonth ? null : () => _shiftMonth(1),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  for (var d = 1; d <= 7; d++)
                    Expanded(
                      child: Center(
                        child: Text(
                          s.weekdayMin(d),
                          style: TextStyle(
                            fontSize: 11,
                            color: p.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ...weeks,
            ],
          ),
        ),
        const SizedBox(height: 26),
        SectionHeading(
          title: s('cal.summary'),
          action: s.f('cal.days', {'n': '${entries.length}'}),
        ),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              s('cal.empty'),
              style: TextStyle(fontSize: 13, color: p.muted, height: 1.5),
            ),
          )
        else
          for (final mood in MoodType.values)
            _SummaryRow(
              mood: mood,
              label: s(mood.labelKey),
              days: s.f('cal.days', {'n': '${counts[mood] ?? 0}'}),
              fraction: (counts[mood] ?? 0) / entries.length,
            ),
        if (entries.isNotEmpty) ...[
          const SizedBox(height: 14),
          SectionHeading(title: s('cal.notes')),
          for (final e in entries.reversed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EntryTile(entry: e),
            ),
        ],
      ],
    );
  }

  Widget _buildCell({
    required int index,
    required int leading,
    required int total,
    required DateTime today,
    required Map<int, MoodEntry> byDay,
  }) {
    final dayNumber = index - leading + 1;
    if (dayNumber < 1 || dayNumber > total) {
      return const AspectRatio(aspectRatio: .78, child: SizedBox.shrink());
    }
    final date = DateTime(_month.year, _month.month, dayNumber);
    return _DayCell(
      date: date,
      entry: byDay[dayNumber],
      isToday: sameDay(date, today),
      isFuture: date.isAfter(today),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.entry,
    required this.isToday,
    required this.isFuture,
  });

  final DateTime date;
  final MoodEntry? entry;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AspectRatio(
      aspectRatio: .78,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isFuture ? null : () => showMoodSheet(context, date: date),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: isToday ? p.highlight : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            border: isToday ? Border.all(color: p.accent, width: 1.2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isFuture ? p.muted.withAlpha(110) : p.ink,
                ),
              ),
              if (entry != null)
                Text(entry!.mood.emoji, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.mood,
    required this.label,
    required this.days,
    required this.fraction,
  });

  final MoodType mood;
  final String label;
  final String days;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(mood.emoji, style: const TextStyle(fontSize: 25))),
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Text(days, style: TextStyle(fontSize: 11, color: p.muted)),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 7,
                color: mood.color,
                backgroundColor: p.soft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      onTap: () => showMoodSheet(context, date: entry.date),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.mood.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.shortDate(entry.date)} • ${s.weekdayShort(entry.date.weekday)}',
                  style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  s(entry.mood.labelKey),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                if (entry.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: p.muted, height: 1.45),
                  ),
                ],
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final t in entry.tags) TagPill(s('tag.$t'))],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

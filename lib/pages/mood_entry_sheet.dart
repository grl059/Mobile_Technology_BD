import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../widgets/widgets.dart';
import 'breathing_page.dart';

/// Өдрийн мэдрэмж тэмдэглэх (эсвэл засах) доод цонх.
/// [date] өгөхгүй бол өнөөдрийг ашиглана.
Future<void> showMoodSheet(BuildContext context, {DateTime? date}) {
  final target = dateOnly(date ?? DateTime.now());
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => MoodEntrySheet(date: target),
  );
}

class MoodEntrySheet extends StatefulWidget {
  const MoodEntrySheet({required this.date, super.key});

  final DateTime date;

  @override
  State<MoodEntrySheet> createState() => _MoodEntrySheetState();
}

class _MoodEntrySheetState extends State<MoodEntrySheet> {
  MoodType? _selected;
  late final TextEditingController _note;
  final Set<String> _tags = {};
  bool _existing = false;

  @override
  void initState() {
    super.initState();
    final entry = AppScope.read(context).entryFor(widget.date);
    _existing = entry != null;
    _selected = entry?.mood;
    _note = TextEditingController(text: entry?.note ?? '');
    _tags.addAll(entry?.tags ?? const <String>[]);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _save() {
    final mood = _selected;
    if (mood == null) return;
    final app = AppScope.read(context);
    final s = context.s;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final fresh = app.saveEntry(
      date: widget.date,
      mood: mood,
      note: _note.text,
      tags: _tags.toList(),
    );
    // Шинэ тэмдэг нээгдвэл confetti (цонх хаагдахаас өмнө дуудна).
    if (fresh.isNotEmpty) showConfetti(context);
    navigator.pop();

    // Хүнд мэдрэмж бол амьсгалын дасгал санал болгоно; шинэ тэмдэг нээгдвэл
    // түүнийг эхэнд мэдэгдэнэ.
    final hard = mood == MoodType.sad || mood == MoodType.angry;
    final String message;
    if (fresh.isNotEmpty) {
      message = s.f('ach.new', {'name': s('ach.${fresh.first}')});
    } else if (hard) {
      message = s('breath.suggest');
    } else {
      message = s('sheet.saved');
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: hard ? 7 : 4),
          action: hard
              ? SnackBarAction(
                  label: s('breath.suggestAction'),
                  onPressed: () => navigator.push(BreathingPage.route()),
                )
              : null,
        ),
      );
  }

  Future<void> _delete() async {
    final s = context.s;
    final ok = await confirmDialog(
      context,
      title: s('sheet.deleteTitle'),
      message: s('sheet.deleteMessage'),
      confirmLabel: s('common.delete'),
      danger: true,
    );
    if (!ok || !mounted) return;
    AppScope.read(context).deleteEntry(widget.date);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    final isToday = sameDay(widget.date, DateTime.now());
    final eyebrow = isToday
        ? '${s.shortDate(widget.date)} • ${s('sheet.today')}'.toUpperCase()
        : s.dateLine(widget.date);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
        decoration: BoxDecoration(
          color: p.page,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: p.line,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(eyebrow),
                          Text(
                            _existing ? s('sheet.editTitle') : s('sheet.title'),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoundButton(
                      icon: AppIcons.close,
                      size: 40,
                      onTap: () => Navigator.of(context).pop(),
                      tooltip: s('common.close'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  s('sheet.question'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (var i = 0; i < MoodType.values.length; i++)
                      Expanded(
                        child: _MoodOption(
                          mood: MoodType.values[i],
                          label: s(MoodType.values[i].labelKey),
                          selected: _selected == MoodType.values[i],
                          isLast: i == MoodType.values.length - 1,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selected = MoodType.values[i]);
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s('sheet.note'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      s('sheet.optional'),
                      style: TextStyle(fontSize: 11, color: p.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                NoteField(
                  controller: _note,
                  hint: s('sheet.noteHint'),
                  maxLength: 500,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    for (final tag in moodTags)
                      FilterChip(
                        label: Text(s('tag.$tag'), style: const TextStyle(fontSize: 12)),
                        selected: _tags.contains(tag),
                        showCheckmark: false,
                        backgroundColor: p.soft,
                        selectedColor: p.highlight,
                        side: BorderSide(
                          color: _tags.contains(tag) ? p.accent : Colors.transparent,
                        ),
                        onSelected: (on) => setState(() {
                          if (on) {
                            _tags.add(tag);
                          } else {
                            _tags.remove(tag);
                          }
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  key: const Key('mood_save'),
                  icon: AppIcons.check,
                  label: _existing ? s('sheet.update') : s('sheet.save'),
                  onTap: _selected == null ? null : _save,
                ),
                if (_existing) ...[
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton.icon(
                      onPressed: _delete,
                      icon: const Icon(
                        AppIcons.trash,
                        size: 18,
                        color: Color(0xFFD9534F),
                      ),
                      label: Text(
                        s('common.delete'),
                        style: const TextStyle(
                          color: Color(0xFFD9534F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.mood,
    required this.label,
    required this.selected,
    required this.isLast,
    required this.onTap,
  });

  final MoodType mood;
  final String label;
  final bool selected;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(right: isLast ? 0 : 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? p.highlight : p.soft,
          border: Border.all(color: selected ? p.accent : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Bounce(
              active: selected,
              child: MoodFace(mood, size: 32),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

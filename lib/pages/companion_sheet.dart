import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../widgets/widgets.dart';

/// Найзаа сонгох доод цонх: дүр, хэмжээ, урьдчилан харах.
Future<void> showCompanionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CompanionSheet(),
  );
}

class CompanionSheet extends StatefulWidget {
  const CompanionSheet({super.key});

  @override
  State<CompanionSheet> createState() => _CompanionSheetState();
}

class _CompanionSheetState extends State<CompanionSheet> {
  late CompanionSettings _draft;

  @override
  void initState() {
    super.initState();
    _draft = AppScope.read(context).companion;
  }

  void _save() {
    final app = AppScope.read(context);
    final message = context.s('comp.saved');
    final messenger = ScaffoldMessenger.of(context);
    app.setCompanion(_draft);
    Navigator.of(context).pop();
    showSnackOn(messenger, message);
  }

  void showSnackOn(ScaffoldMessengerState messenger, String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    final name = s(_draft.nameKey);
    final hidden = _draft.size == CompanionSize.hidden;
    final avatarSize = _draft.size == CompanionSize.small ? 96.0 : 150.0;

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
                    Text(
                      s('comp.title'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    RoundButton(
                      icon: AppIcons.close,
                      size: 40,
                      onTap: () => Navigator.of(context).pop(),
                      tooltip: s('common.close'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Урьдчилан харах
                Container(
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [p.mint, p.warm],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: p.card,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            s.f('comp.hello', {'name': name}),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: hidden ? .3 : 1,
                            child: CompanionAvatar(
                              kind: _draft.kind,
                              mood: MoodType.happy,
                              size: hidden ? 110 : avatarSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final kind in CompanionKind.values)
                      Expanded(
                        child: _KindTile(
                          key: Key('companion_${kind.name}'),
                          kind: kind,
                          label: s('comp.${kind.name}'),
                          selected: _draft.kind == kind,
                          onTap: () => setState(() => _draft = _draft.copyWith(kind: kind)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  s('comp.sizeQ'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: p.soft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      for (final size in CompanionSize.values)
                        Expanded(
                          child: GestureDetector(
                            key: Key('companion_size_${size.name}'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => _draft = _draft.copyWith(size: size)),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _draft.size == size ? p.card : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: _draft.size == size
                                    ? [BoxShadow(color: p.shadow, blurRadius: 10)]
                                    : null,
                              ),
                              child: Text(
                                s('comp.${size.name}'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _draft.size == size ? p.ink : p.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s('comp.hint.${_draft.size.name}'),
                  style: TextStyle(fontSize: 12, color: p.muted, height: 1.5),
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  key: const Key('companion_save'),
                  label: s('common.save'),
                  onTap: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KindTile extends StatelessWidget {
  const _KindTile({
    required this.kind,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final CompanionKind kind;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
        decoration: BoxDecoration(
          color: p.soft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFE9807A) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            CompanionAvatar(kind: kind, mood: MoodType.happy, size: 48),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? const Color(0xFFD9534F) : p.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

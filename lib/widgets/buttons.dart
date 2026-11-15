import 'package:flutter/material.dart';

import '../core/core.dart';

/// Дугуй булантай жижиг дүрстэй товч (буцах, мэдэгдэл гэх мэт).
class RoundButton extends StatelessWidget {
  const RoundButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
    this.size = 43,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final radius = BorderRadius.circular(size / 2.7);
    Widget button = Opacity(
      opacity: enabled ? 1 : .35,
      child: Material(
        color: p.card,
        borderRadius: radius,
        elevation: 2,
        shadowColor: const Color(0x152A3E36),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: radius,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: size * .52, color: p.ink),
          ),
        ),
      ),
    );
    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

/// Хуанлийн сар солих товч.
class MiniButton extends StatelessWidget {
  const MiniButton({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      style: IconButton.styleFrom(
        backgroundColor: p.soft,
        foregroundColor: p.ink,
        disabledBackgroundColor: p.soft,
        disabledForegroundColor: p.muted.withAlpha(90),
      ),
    );
  }
}

/// Үндсэн, том товч. `onTap` null бол идэвхгүй харагдана.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final style = FilledButton.styleFrom(
      backgroundColor: p.forest,
      foregroundColor: p.onForest,
      disabledBackgroundColor: p.line,
      disabledForegroundColor: p.muted,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
    final text = Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    );
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: icon == null
          ? FilledButton(onPressed: onTap, style: style, child: text)
          : FilledButton.icon(
              onPressed: onTap,
              style: style,
              icon: Icon(icon, size: 19),
              label: text,
            ),
    );
  }
}

/// Асаах/унтраах шилжүүлэгч. Дарахад `onChanged` дуудагдана.
class SwitchPill extends StatelessWidget {
  const SwitchPill({required this.value, this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 26,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? p.accent : p.line,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: const CircleAvatar(radius: 10, backgroundColor: Colors.white),
        ),
      ),
    );
  }
}

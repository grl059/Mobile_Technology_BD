import 'package:flutter/material.dart';

import '../core/core.dart';

/// Зөөлөн сүүдэртэй карт. `color` өгвөл сүүдэргүй, өнгөт карт болно.
class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final radius = BorderRadius.circular(22);
    final content = Padding(padding: padding, child: child);
    return Container(
      decoration: BoxDecoration(
        color: color ?? p.card,
        borderRadius: radius,
        boxShadow: color == null
            ? [BoxShadow(color: p.shadow, blurRadius: 26, offset: const Offset(0, 8))]
            : null,
      ),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(onTap: onTap, child: content),
            ),
    );
  }
}

/// Тохиргооны мөрүүдийг нэг карт дотор жагсаана.
class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(Divider(height: 1, indent: 15, endIndent: 15, color: p.line));
      }
      items.add(children[i]);
    }
    return Material(
      color: p.card,
      borderRadius: BorderRadius.circular(21),
      clipBehavior: Clip.antiAlias,
      child: Column(children: items),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackground,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackground;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 21),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: TextStyle(fontSize: 12, color: p.muted),
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : Icon(AppIcons.forward, size: 20, color: p.muted)),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({required this.size, required this.name, this.colorIndex = 0, super.key});

  final double size;
  final String name;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty
        ? '?'
        : String.fromCharCode(trimmed.runes.first).toUpperCase();
    final color = avatarColors[colorIndex.abs() % avatarColors.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(204), width: 3),
      ),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * .38,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    required this.leading,
    required this.label,
    required this.value,
    super.key,
  });

  /// Зүүн талын дүрс ([IconBox] эсвэл [MoodFace]).
  final Widget leading;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: p.muted)),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Өнгөт дэвсгэр бүхий дөрвөлжин icon (карт, жагсаалтын эхэнд).
/// [background] өгөхгүй бол [color]-ын цайвар өнгийг ашиглана.
class IconBox extends StatelessWidget {
  const IconBox({
    required this.icon,
    required this.color,
    this.background,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final Color color;
  final Color? background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? color.withAlpha(36),
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: Icon(icon, size: size * .5, color: color),
    );
  }
}

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    required this.icon,
    required this.title,
    required this.copy,
    required this.time,
    this.unread = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String copy;
  final String time;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return SoftCard(
      color: unread ? p.highlight : p.card,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(icon: icon, color: p.accent, background: p.mint),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(copy, style: TextStyle(fontSize: 12, height: 1.5, color: p.muted)),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 11, color: p.muted)),
              ],
            ),
          ),
          if (unread)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: CircleAvatar(radius: 4, backgroundColor: p.accent),
            ),
        ],
      ),
    );
  }
}

/// Радио маягийн сонголтын мөр (хэл сонгох).
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? p.accent : p.muted.withAlpha(120),
                  width: 1.6,
                ),
              ),
              child: selected ? CircleAvatar(backgroundColor: p.accent) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: p.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Сэдэв сонгох карт (гэрэлтэй / бараан / байгалийн).
class ThemeChoice extends StatelessWidget {
  const ThemeChoice({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final AppThemeMode mode;
  final String title;
  final String subtitle;
  final IconData symbol;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final preview = paletteFor(mode);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: p.card,
            border: Border.all(
              color: selected ? p.accent : p.line,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 86,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: preview.page,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: preview.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(symbol, size: 20, color: preview.accent),
                    const SizedBox(height: 7),
                    for (final width in const [1.0, .72, .46])
                      FractionallySizedBox(
                        widthFactor: width,
                        child: Container(
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: preview.ink.withAlpha(46),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (selected) Icon(AppIcons.check, size: 16, color: p.accent),
                ],
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: p.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Дарахад нээгддэг асуулт-хариулт.
class FaqTile extends StatefulWidget {
  const FaqTile({required this.question, required this.answer, super.key});

  final String question;
  final String answer;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return InkWell(
      onTap: () => setState(() => open = !open),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    open ? AppIcons.expandLess : AppIcons.expandMore,
                    size: 22,
                    color: p.muted,
                  ),
                ],
              ),
              if (open)
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 24),
                  child: Text(
                    widget.answer,
                    style: TextStyle(fontSize: 12.5, height: 1.6, color: p.muted),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Жижиг шошго (тэмдэглэлийн tag).
class TagPill extends StatelessWidget {
  const TagPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: p.soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w600),
      ),
    );
  }
}

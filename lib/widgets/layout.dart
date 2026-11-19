import 'package:flutter/material.dart';

import '../core/core.dart';
import 'buttons.dart';

/// Хуудасны гүйлгэгддэг үндсэн бүрхүүл.
class ScreenPage extends StatelessWidget {
  const ScreenPage({required this.children, this.paddingBottom = 28, super.key});

  final List<Widget> children;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 24, 20, paddingBottom),
        children: children,
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color ?? context.pal.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: .9,
        ),
      ),
    );
  }
}

/// Үндсэн табуудын толгой хэсэг: гарчиг + мэдэгдлийн хонх.
class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.eyebrow,
    required this.title,
    required this.onNotifications,
    super.key,
  });

  final String eyebrow;
  final String title;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final unread = context.app.unreadCount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(eyebrow),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              RoundButton(
                icon: AppIcons.bell,
                onTap: onNotifications,
                tooltip: context.s('notif.title'),
              ),
              if (unread > 0)
                Positioned(
                  right: 8,
                  top: 7,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF7669),
                      shape: BoxShape.circle,
                      border: Border.all(color: p.card, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Дэд хуудасны толгой хэсэг: буцах товч + гарчиг.
class DetailHeader extends StatelessWidget {
  const DetailHeader({required this.title, required this.eyebrow, super.key});

  final String title;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          RoundButton(
            icon: AppIcons.back,
            onTap: () => Navigator.of(context).maybePop(),
            tooltip: context.s('common.back'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(eyebrow),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.5,
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

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.eyebrow,
    this.action,
    this.onAction,
    super.key,
  });

  final String title;
  final String? eyebrow;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) Eyebrow(eyebrow!),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.2,
                  ),
                ),
              ],
            ),
          ),
          if (action != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  action!,
                  style: TextStyle(
                    fontSize: 12,
                    color: p.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 23, 3, 9),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: context.pal.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: .9,
        ),
      ),
    );
  }
}

/// Хоосон төлөв: дүрс + гарчиг + тайлбар.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: p.highlight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 30, color: p.accent),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

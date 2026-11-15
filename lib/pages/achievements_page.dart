import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../state/achievements.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';
import 'mood_entry_sheet.dart';

/// Амжилт: 30 өдрийн сорилт ба нээсэн тэмдгүүд (badge).
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final items = app.achievements;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('ach.title'), eyebrow: s('ach.eyebrow')),
          const _ChallengeCard(),
          const SizedBox(height: 26),
          SectionHeading(
            eyebrow: s('ach.badges'),
            title: s.f('ach.count', {
              'n': '${app.unlockedCount}',
              'total': '${items.length}',
            }),
          ),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 150,
            ),
            children: [
              for (final a in items) _BadgeTile(status: a),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard();

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final status = app.challengeStatus;
    final challenge = app.challenge;
    final logged = app.challengeLogged;

    final header = Row(
      children: [
        const Text('🎯', style: TextStyle(fontSize: 30)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s('chal.title'),
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              if (status == ChallengeStatus.active)
                Text(
                  s.f('chal.day', {'d': '${app.challengeDay}'}),
                  style: TextStyle(fontSize: 12, color: p.mintInk),
                ),
            ],
          ),
        ),
      ],
    );

    TextStyle bodyStyle() =>
        TextStyle(fontSize: 13, height: 1.55, color: p.mintInk);

    final children = <Widget>[header, const SizedBox(height: 14)];

    if (challenge == null || status == ChallengeStatus.none) {
      children
        ..add(Text(s('chal.intro'), style: bodyStyle()))
        ..add(const SizedBox(height: 16))
        ..add(
          PrimaryButton(
            key: const Key('challenge_start'),
            icon: Icons.flag_rounded,
            label: s('chal.start'),
            onTap: () {
              app.startChallenge();
              showSnack(context, s('chal.started'));
            },
          ),
        );
    } else {
      children
        ..add(
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: logged / Challenge.length,
              minHeight: 8,
              backgroundColor: p.card,
              valueColor: AlwaysStoppedAnimation<Color>(p.forest),
            ),
          ),
        )
        ..add(const SizedBox(height: 8))
        ..add(
          Text(
            s.f('chal.logged', {'n': '$logged'}),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: p.mintInk,
            ),
          ),
        )
        ..add(const SizedBox(height: 14))
        ..add(_ChallengeDots(start: challenge.start))
        ..add(const SizedBox(height: 14));

      switch (status) {
        case ChallengeStatus.completed:
          children.add(Text(s('chal.completed'), style: bodyStyle()));
        case ChallengeStatus.ended:
          children.add(
            Text(s.f('chal.ended', {'n': '$logged'}), style: bodyStyle()),
          );
        case ChallengeStatus.active:
        case ChallengeStatus.none:
          children.add(Text(s('chal.activeHint'), style: bodyStyle()));
      }

      children.add(const SizedBox(height: 12));
      if (status == ChallengeStatus.active) {
        children.add(
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const Key('challenge_stop'),
              onPressed: () async {
                final ok = await confirmDialog(
                  context,
                  title: s('chal.stopTitle'),
                  message: s('chal.stopMessage'),
                  confirmLabel: s('chal.stop'),
                  danger: true,
                );
                if (ok) app.stopChallenge();
              },
              child: Text(
                s('chal.stop'),
                style: TextStyle(color: p.mintInk, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      } else {
        children.add(
          PrimaryButton(
            key: const Key('challenge_restart'),
            icon: Icons.refresh_rounded,
            label: s('chal.restart'),
            onTap: () {
              app.startChallenge();
              showSnack(context, s('chal.started'));
            },
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.mint,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// 30 өдрийг 3x10 цэгээр харуулна. Цэг дээр дарж тэр өдрийг тэмдэглэнэ.
class _ChallengeDots extends StatelessWidget {
  const _ChallengeDots({required this.start});

  final DateTime start;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final p = context.pal;
    final today = dateOnly(DateTime.now());

    return LayoutBuilder(
      builder: (context, constraints) {
        const perRow = 10;
        const gap = 6.0;
        final size = (constraints.maxWidth - gap * (perRow - 1)) / perRow;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < Challenge.length; i++)
              _dot(context, app, p, addDays(start, i), i + 1, today, size),
          ],
        );
      },
    );
  }

  Widget _dot(
    BuildContext context,
    AppState app,
    AppPalette p,
    DateTime day,
    int number,
    DateTime today,
    double size,
  ) {
    final done = app.entryFor(day) != null;
    final isToday = sameDay(day, today);
    final future = day.isAfter(today);
    final Color border;
    if (isToday) {
      border = p.accent;
    } else if (done) {
      border = Colors.transparent;
    } else {
      border = p.mintInk.withAlpha(60);
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: future ? null : () => showMoodSheet(context, date: day),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done
              ? p.forest
              : (future ? Colors.transparent : p.card),
          border: Border.all(color: border, width: isToday ? 2 : 1),
        ),
        child: done
            ? Icon(Icons.check_rounded, size: size * .6, color: p.onForest)
            : Text(
                '$number',
                style: TextStyle(fontSize: size * .38, color: p.mintInk),
              ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.status});

  final AchievementStatus status;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final unlocked = app.isUnlocked(status.id);

    return SoftCard(
      color: unlocked ? p.highlight : null,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
      onTap: () => _showDetail(context, unlocked),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: unlocked ? 1 : .35,
            child: Text(status.emoji, style: const TextStyle(fontSize: 34)),
          ),
          const SizedBox(height: 6),
          Text(
            s(status.titleKey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          if (unlocked)
            Icon(Icons.check_circle_rounded, size: 16, color: p.accent)
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: status.ratio,
                minHeight: 4,
                backgroundColor: p.line,
                valueColor: AlwaysStoppedAnimation<Color>(p.accent),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${status.progress}/${status.target}',
              style: TextStyle(fontSize: 10, color: p.muted),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, bool unlocked) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final date = app.unlockedOn(status.id);

    String? footer;
    if (unlocked) {
      if (date != null) footer = s.f('ach.unlockedOn', {'date': s.ymd(date)});
    } else {
      footer = s.f('ach.lockedHint', {
        'n': '${status.progress}',
        'total': '${status.target}',
      });
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: unlocked ? 1 : .4,
              child: Text(status.emoji, style: const TextStyle(fontSize: 56)),
            ),
            const SizedBox(height: 12),
            Text(
              s(status.titleKey),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              s(status.descKey),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: p.muted, height: 1.5),
            ),
            if (footer != null) ...[
              const SizedBox(height: 14),
              Text(
                footer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: p.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              s('common.close'),
              style: TextStyle(color: p.accent, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

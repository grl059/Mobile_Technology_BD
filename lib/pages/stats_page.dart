import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../state/stats.dart';
import '../widgets/widgets.dart';
import 'notifications_page.dart';

/// Статистик: дундаж мэдрэмж, диаграмм, дүгнэлт.
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsRange _range = StatsRange.week;

  static String _insightTitleKey(double? avg) {
    if (avg == null) return 'stats.t.none';
    if (avg >= 4.2) return 'stats.t.great';
    if (avg >= 3.4) return 'stats.t.good';
    if (avg >= 2.6) return 'stats.t.mixed';
    return 'stats.t.low';
  }

  static String _tipsLevel(double? avg) {
    if (avg == null || avg >= 3.5) return 'high';
    if (avg >= 2.5) return 'mid';
    return 'low';
  }

  String _insightBody(S s, StatsResult r) {
    if (r.count == 0) return s('stats.b.none');
    final parts = <String>[];
    final change = r.changePct;
    if (change == null) {
      parts.add(s('stats.b.noprev'));
    } else if (change > 0) {
      parts.add(s.f('stats.b.up', {'pct': '$change'}));
    } else if (change < 0) {
      parts.add(s.f('stats.b.down', {'pct': '${change.abs()}'}));
    } else {
      parts.add(s('stats.b.flat'));
    }
    final tag = r.topTag;
    if (tag != null) {
      parts.add(s.f('stats.b.tag', {'tag': s('tag.$tag')}));
    }
    return parts.join(' ');
  }

  Future<void> _showTips(double? avg) {
    final s = context.s;
    final p = context.pal;
    final level = _tipsLevel(avg);
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          s('tips.title'),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final n in const [1, 2])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✦  ', style: TextStyle(color: p.accent, fontSize: 14)),
                    Expanded(
                      child: Text(
                        s('tips.$level.$n'),
                        style: TextStyle(fontSize: 13, height: 1.55, color: p.ink),
                      ),
                    ),
                  ],
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final s = context.s;
    final p = context.pal;
    final result = computeStats(app, _range, s, DateTime.now());
    final avg = result.avg;
    final avgMood = avg == null ? null : MoodTypeX.fromScore(avg);
    final change = result.changePct;
    final topMood = result.topMood;
    final barWidth = switch (_range) {
      StatsRange.week => 22.0,
      StatsRange.month => 34.0,
      StatsRange.year => 13.0,
    };

    return ScreenPage(
      children: [
        PageHeader(
          eyebrow: s('stats.eyebrow'),
          title: s('stats.title'),
          onNotifications: () => openNotifications(context),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: p.soft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              for (final r in StatsRange.values)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _range = r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _range == r ? p.card : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          s('stats.${r.name}'),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _range == r ? p.ink : p.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Eyebrow(s('stats.avg')),
                        Text(
                          avgMood == null
                              ? '—'
                              : '${s(avgMood.labelKey)} ${avgMood.emoji}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (change != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: change >= 0
                            ? const Color(0x264D8D68)
                            : const Color(0x26D9534F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        change >= 0 ? '↗ $change%' : '↘ ${change.abs()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: change >= 0
                              ? const Color(0xFF4D8D68)
                              : const Color(0xFFD9534F),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final bucket in result.buckets)
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: _Bar(bucket: bucket, width: barWidth),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                bucket.label,
                                style: TextStyle(fontSize: 10, color: p.muted),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (result.count == 0) ...[
                const SizedBox(height: 14),
                Text(
                  s('stats.noData'),
                  style: TextStyle(fontSize: 12, color: p.muted, height: 1.5),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 17),
        SoftCard(
          color: p.insight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✦',
                  style: TextStyle(color: Color(0xFFE9C986), fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(s('stats.insight.${_range.name}'), color: const Color(0xFFAAB5C1)),
                    Text(
                      s(_insightTitleKey(avg)),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _insightBody(s, result),
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.55,
                        color: Color(0xFFBDC6CE),
                      ),
                    ),
                    if (result.count > 0) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        key: const Key('stats_tips'),
                        onTap: () => _showTips(avg),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${s('stats.tips')}  ›',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE7D4A7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatTile(
                emoji: topMood?.emoji ?? '—',
                label: s('stats.most'),
                value: topMood == null ? '—' : s(topMood.labelKey),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                emoji: '🔥',
                label: s('stats.streak'),
                value: s.f('stats.daysValue', {'n': '${app.streak}'}),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.bucket, required this.width});

  final StatsBucket bucket;
  final double width;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final avg = bucket.avg;
    if (avg == null) {
      return Container(
        width: width,
        height: 6,
        decoration: BoxDecoration(
          color: p.soft,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }
    final factor = (avg / 5).clamp(.22, 1.0).toDouble();
    final mood = MoodTypeX.fromScore(avg);
    return FractionallySizedBox(
      heightFactor: factor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 3),
          Expanded(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [p.accent, p.accent.withAlpha(70)],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

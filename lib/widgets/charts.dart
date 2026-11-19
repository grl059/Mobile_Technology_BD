import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';
import 'mood_face.dart';

bool _reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

// --------------------------------------------------------- Шугаман график

/// Мэдрэмжийн өөрчлөлтийн шугаман график.
///
/// [values] нь цэг бүрийн 1–5 оноо (тэмдэглэлгүй бол null), [labels] нь доод
/// талын тэмдэглэгээ. Босоо тэнхлэг нь мэдрэмжийн нүүрүүд (дээрээс доош:
/// жаргалтай → ууртай). Шугам зүүнээс баруун тийш зурагдаж гарч ирнэ.
class MoodLineChart extends StatelessWidget {
  const MoodLineChart({
    required this.values,
    required this.labels,
    this.height = 190,
    super.key,
  });

  final List<double?> values;
  final List<String> labels;
  final double height;

  static const double _faceSize = 16;
  static const double _top = 10;
  static const double _bottom = 26;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final plotHeight = height - _top - _bottom;
    final labelStyle = DefaultTextStyle.of(context).style.copyWith(
          fontSize: 10,
          color: p.muted,
          fontWeight: FontWeight.w500,
        );

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _faceSize,
            child: Stack(
              children: [
                for (var score = 5; score >= 1; score--)
                  Positioned(
                    left: 0,
                    top: _top + (5 - score) / 4 * plotHeight - _faceSize / 2,
                    child: MoodFace(
                      MoodTypeX.fromScore(score.toDouble()),
                      size: _faceSize,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TweenAnimationBuilder<double>(
              // Өгөгдөл өөрчлөгдөхөд (жишээ нь 7 хоног → сар) дахин зурагдана.
              key: ValueKey(Object.hashAll(values)),
              tween: Tween(begin: 0, end: 1),
              duration: _reduceMotion(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 750),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) => CustomPaint(
                painter: _LinePainter(
                  values: values,
                  labels: labels,
                  progress: t,
                  top: _top,
                  bottom: _bottom,
                  gridColor: p.line,
                  lineColor: p.accent,
                  dotBorder: p.card,
                  labelStyle: labelStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.values,
    required this.labels,
    required this.progress,
    required this.top,
    required this.bottom,
    required this.gridColor,
    required this.lineColor,
    required this.dotBorder,
    required this.labelStyle,
  });

  final List<double?> values;
  final List<String> labels;
  final double progress;
  final double top;
  final double bottom;
  final Color gridColor;
  final Color lineColor;
  final Color dotBorder;
  final TextStyle labelStyle;

  static const double _sidePad = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final plotHeight = size.height - top - bottom;
    final plotBottom = top + plotHeight;

    double yOf(double score) => top + (5 - score) / 4 * plotHeight;
    double xOf(int i) => n == 1
        ? size.width / 2
        : _sidePad + i * (size.width - _sidePad * 2) / (n - 1);

    // Хэвтээ туслах шугамууд (оноо бүрт нэг).
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var score = 1; score <= 5; score++) {
      final y = yOf(score.toDouble());
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Доод тэмдэглэгээ: хэт олон бол (сарын 30 өдөр) 7 орчмыг л харуулна.
    final step = math.max(1, (n / 7).ceil());
    for (var i = 0; i < n && i < labels.length; i += step) {
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final maxX = math.max(0.0, size.width - tp.width);
      final dx = (xOf(i) - tp.width / 2).clamp(0.0, maxX).toDouble();
      tp.paint(canvas, Offset(dx, plotBottom + 8));
    }

    // Тэмдэглэлтэй цэгүүд (хоосон өдрүүдийг алгасаж холбоно).
    final points = <Offset>[];
    final scores = <double>[];
    for (var i = 0; i < n; i++) {
      final v = values[i];
      if (v == null) continue;
      points.add(Offset(xOf(i), yOf(v)));
      scores.add(v);
    }
    if (points.isEmpty) return;

    // Зүүнээс баруун тийш аажмаар гарч ирэх хөдөлгөөн.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress + 6, size.height));

    if (points.length > 1) {
      final line = _smoothPath(points, top, plotBottom);
      final area = Path.from(line)
        ..lineTo(points.last.dx, plotBottom)
        ..lineTo(points.first.dx, plotBottom)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lineColor.withAlpha(70), lineColor.withAlpha(0)],
          ).createShader(Rect.fromLTWH(0, top, size.width, plotHeight)),
      );
      canvas.drawPath(
        line,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Цэг бүр тухайн мэдрэмжийн өнгөтэй. Цэг олон (сарын өдрүүд) бол жижиг.
    final dot = n > 14 ? 3.0 : 4.0;
    final border = Paint()..color = dotBorder;
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], dot + 1.5, border);
      canvas.drawCircle(
        points[i],
        dot,
        Paint()..color = MoodTypeX.fromScore(scores[i]).color,
      );
    }
    canvas.restore();
  }

  /// Цэгүүдийг зөөлөн муруйгаар (Catmull-Rom) холбоно. Муруй нь графикийн
  /// хүрээнээс гарахгүйн тулд хяналтын цэгүүдийг хязгаарлана.
  static Path _smoothPath(List<Offset> p, double minY, double maxY) {
    double clampY(double y) => y.clamp(minY, maxY);
    final path = Path()..moveTo(p.first.dx, p.first.dy);
    for (var i = 0; i < p.length - 1; i++) {
      final p0 = i == 0 ? p[i] : p[i - 1];
      final p1 = p[i];
      final p2 = p[i + 1];
      final p3 = i + 2 < p.length ? p[i + 2] : p2;
      const k = 1 / 6;
      path.cubicTo(
        p1.dx + (p2.dx - p0.dx) * k,
        clampY(p1.dy + (p2.dy - p0.dy) * k),
        p2.dx - (p3.dx - p1.dx) * k,
        clampY(p2.dy - (p3.dy - p1.dy) * k),
        p2.dx,
        p2.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => true;
}

// ---------------------------------------------------------- Дугуй диаграмм

/// Мэдрэмж тус бүрийн эзлэх хувь: дугуй диаграмм + баруун талд тайлбар.
class MoodBreakdown extends StatelessWidget {
  const MoodBreakdown({required this.counts, super.key});

  final Map<MoodType, int> counts;

  static const double _size = 116;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    final total = counts.values.fold<int>(0, (sum, c) => sum + c);
    final percents = _percents(counts, total);

    return Row(
      children: [
        SizedBox.square(
          dimension: _size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey(Object.hashAll([for (final m in MoodType.values) counts[m] ?? 0])),
                tween: Tween(begin: 0, end: 1),
                duration: _reduceMotion(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, t, _) => CustomPaint(
                  size: const Size.square(_size),
                  painter: _DonutPainter(
                    counts: counts,
                    total: total,
                    progress: t,
                    emptyColor: p.soft,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.5,
                    ),
                  ),
                  Text(s('stats.entries'), style: TextStyle(fontSize: 11, color: p.muted)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              for (final mood in MoodType.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      MoodFace(mood, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s(mood.labelKey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: (counts[mood] ?? 0) == 0 ? p.muted : p.ink,
                          ),
                        ),
                      ),
                      Text(
                        '${percents[mood]}%',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: (counts[mood] ?? 0) == 0 ? p.muted : p.ink,
                          fontFeatures: const [FontFeature.tabularFigures()],
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

  /// Хувийг бүхэл тоо болгоно. Нийлбэр нь яг 100 байхаар үлдэгдлийг хамгийн
  /// их бутархайтай мэдрэмжүүдэд хуваарилна (largest remainder арга).
  static Map<MoodType, int> _percents(Map<MoodType, int> counts, int total) {
    final result = {for (final m in MoodType.values) m: 0};
    if (total == 0) return result;
    final remainders = <MoodType, double>{};
    var sum = 0;
    for (final m in MoodType.values) {
      final exact = (counts[m] ?? 0) * 100 / total;
      final whole = exact.floor();
      result[m] = whole;
      remainders[m] = exact - whole;
      sum += whole;
    }
    final order = MoodType.values.toList()
      ..sort((a, b) => remainders[b]!.compareTo(remainders[a]!));
    for (var i = 0; i < 100 - sum; i++) {
      final m = order[i];
      result[m] = result[m]! + 1;
    }
    return result;
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.counts,
    required this.total,
    required this.progress,
    required this.emptyColor,
  });

  final Map<MoodType, int> counts;
  final int total;
  final double progress;
  final Color emptyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * .16;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = emptyColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (total == 0) return;

    final active = [
      for (final m in MoodType.values)
        if ((counts[m] ?? 0) > 0) m,
    ];
    // Хэсгүүдийн хооронд жижиг зай үлдээнэ.
    final gap = active.length > 1 ? .05 : 0.0;
    const begin = -math.pi / 2;
    final visibleEnd = begin + math.pi * 2 * progress;
    var start = begin;

    for (final m in active) {
      final full = math.pi * 2 * counts[m]! / total;
      final end = math.min(start + full, visibleEnd);
      final sweep = end - start - gap;
      if (sweep > 0) {
        canvas.drawArc(
          rect,
          start + gap / 2,
          sweep,
          false,
          Paint()
            ..color = m.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke,
        );
      }
      start += full;
      if (start >= visibleEnd) break;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.total != total ||
      oldDelegate.counts != counts;
}

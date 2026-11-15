import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/models.dart';

/// Найзын дүр. Зургийг кодоор (CustomPaint) зурдаг тул зураг файл хэрэггүй.
/// [mood] өгвөл нүүрний хувирал өөрчлөгдөнө.
class CompanionAvatar extends StatelessWidget {
  const CompanionAvatar({
    required this.kind,
    this.mood,
    this.size = 120,
    super.key,
  });

  final CompanionKind kind;
  final MoodType? mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CompanionPainter(kind, mood)),
    );
  }
}

class _CompanionPainter extends CustomPainter {
  _CompanionPainter(this.kind, this.mood);

  final CompanionKind kind;
  final MoodType? mood;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    // Доорх зөөлөн сүүдэр
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .5, w * .93), width: w * .5, height: w * .07),
      Paint()..color = const Color(0x1A000000),
    );

    Offset face;
    double scale;
    switch (kind) {
      case CompanionKind.sun:
        _sun(canvas, w);
        face = Offset(w * .5, w * .5);
        scale = w;
      case CompanionKind.bubble:
        _bubble(canvas, w);
        face = Offset(w * .5, w * .52);
        scale = w;
      case CompanionKind.mushroom:
        _mushroom(canvas, w);
        face = Offset(w * .5, w * .72);
        scale = w * .8;
      case CompanionKind.star:
        _star(canvas, w);
        face = Offset(w * .5, w * .56);
        scale = w * .85;
      case CompanionKind.leaf:
        _leaf(canvas, w);
        face = Offset(w * .5, w * .62);
        scale = w * .9;
    }
    _face(canvas, face, scale);
  }

  void _sun(Canvas canvas, double w) {
    final ray = Paint()
      ..color = const Color(0xFFFFB84D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * .06
      ..strokeCap = StrokeCap.round;
    final c = Offset(w * .5, w * .5);
    for (var i = 0; i < 10; i++) {
      final a = i * 2 * math.pi / 10;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(c + dir * (w * .36), c + dir * (w * .46), ray);
    }
    canvas.drawCircle(c, w * .31, Paint()..color = const Color(0xFFFFD36B));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .39, w * .3), width: w * .12, height: w * .07),
      Paint()..color = const Color(0x66FFFFFF),
    );
  }

  void _bubble(Canvas canvas, double w) {
    final c = Offset(w * .5, w * .52);
    canvas.drawCircle(c, w * .36, Paint()..color = const Color(0xFFCDEBFF));
    canvas.drawCircle(
      c,
      w * .36,
      Paint()
        ..color = const Color(0xFF9FD3F5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .015,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .35, w * .3), width: w * .13, height: w * .08),
      Paint()..color = const Color(0xAAFFFFFF),
    );
  }

  void _mushroom(Canvas canvas, double w) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .3, w * .5, w * .4, w * .38),
        Radius.circular(w * .14),
      ),
      Paint()..color = const Color(0xFFFFF0DC),
    );
    canvas.drawArc(
      Rect.fromLTWH(w * .08, w * .12, w * .84, w * .8),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFFF28B82),
    );
    final dot = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(w * .3, w * .38), w * .05, dot);
    canvas.drawCircle(Offset(w * .52, w * .26), w * .06, dot);
    canvas.drawCircle(Offset(w * .72, w * .4), w * .045, dot);
  }

  void _star(Canvas canvas, double w) {
    final c = Offset(w * .5, w * .53);
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? w * .36 : w * .19;
      final a = -math.pi / 2 + i * math.pi / 5;
      final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    const color = Color(0xFFC9B6F2);
    canvas.drawPath(path, Paint()..color = color);
    // Булангуудыг бөөрөнхийлнө
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * .07
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _lobe(Canvas canvas, Offset c, double angle, Size lobe, Paint paint) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: lobe.width, height: lobe.height),
      paint,
    );
    canvas.restore();
  }

  void _leaf(Canvas canvas, double w) {
    final sprout = Paint()..color = const Color(0xFF6FBF7B);
    _lobe(canvas, Offset(w * .4, w * .17), -.6, Size(w * .2, w * .1), sprout);
    _lobe(canvas, Offset(w * .6, w * .17), .6, Size(w * .2, w * .1), sprout);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .5, w * .58), width: w * .66, height: w * .72),
      Paint()..color = const Color(0xFF9AD5A1),
    );
  }

  void _face(Canvas canvas, Offset c, double s) {
    const inkColor = Color(0xFF3B2F4A);
    final ink = Paint()
      ..color = inkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * .03
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = inkColor;
    final blush = Paint()..color = const Color(0x66FF8FA3);

    final eyeL = Offset(c.dx - s * .13, c.dy - s * .03);
    final eyeR = Offset(c.dx + s * .13, c.dy - s * .03);

    canvas.drawCircle(Offset(c.dx - s * .21, c.dy + s * .07), s * .045, blush);
    canvas.drawCircle(Offset(c.dx + s * .21, c.dy + s * .07), s * .045, blush);

    final m = mood;
    if (m == MoodType.sad) {
      canvas.drawCircle(eyeL, s * .028, fill);
      canvas.drawCircle(eyeR, s * .028, fill);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(c.dx, c.dy + s * .15), width: s * .12, height: s * .08),
        math.pi,
        math.pi,
        false,
        ink,
      );
    } else if (m == MoodType.angry) {
      canvas.drawCircle(eyeL, s * .028, fill);
      canvas.drawCircle(eyeR, s * .028, fill);
      canvas.drawLine(
        Offset(eyeL.dx - s * .05, eyeL.dy - s * .09),
        Offset(eyeL.dx + s * .04, eyeL.dy - s * .06),
        ink,
      );
      canvas.drawLine(
        Offset(eyeR.dx + s * .05, eyeR.dy - s * .09),
        Offset(eyeR.dx - s * .04, eyeR.dy - s * .06),
        ink,
      );
      canvas.drawLine(
        Offset(c.dx - s * .05, c.dy + s * .13),
        Offset(c.dx + s * .05, c.dy + s * .13),
        ink,
      );
    } else if (m == MoodType.calm) {
      for (final eye in [eyeL, eyeR]) {
        canvas.drawArc(
          Rect.fromCenter(center: eye, width: s * .09, height: s * .06),
          0,
          math.pi,
          false,
          ink,
        );
      }
      canvas.drawArc(
        Rect.fromCenter(center: Offset(c.dx, c.dy + s * .09), width: s * .09, height: s * .06),
        0,
        math.pi,
        false,
        ink,
      );
    } else {
      for (final eye in [eyeL, eyeR]) {
        canvas.drawArc(
          Rect.fromCenter(center: eye, width: s * .09, height: s * .09),
          math.pi,
          math.pi,
          false,
          ink,
        );
      }
      if (m == MoodType.joyful) {
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, c.dy + s * .08), width: s * .16, height: s * .16),
          0,
          math.pi,
          true,
          Paint()..color = const Color(0xFF5A3A55),
        );
      } else {
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, c.dy + s * .09), width: s * .14, height: s * .1),
          0,
          math.pi,
          false,
          ink,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CompanionPainter old) =>
      old.kind != kind || old.mood != mood;
}

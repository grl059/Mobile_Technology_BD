import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/models.dart';

/// Мэдрэмжийн дүрс. Emoji нь утас, Windows, веб дээр өөр өөр харагддаг тул
/// оронд нь кодоор зурсан энгийн нүүр ашиглана. Өнгө нь [MoodTypeX.color].
class MoodFace extends StatelessWidget {
  const MoodFace(this.mood, {this.size = 28, super.key});

  final MoodType mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MoodFacePainter(mood)),
    );
  }
}

class _MoodFacePainter extends CustomPainter {
  _MoodFacePainter(this.mood);

  final MoodType mood;

  static const Color _ink = Color(0xEB302A2E);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    const pi = math.pi;

    canvas.drawCircle(Offset(s / 2, s / 2), s / 2, Paint()..color = mood.color);

    final stroke = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(s * .07, 1.0)
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _ink;

    final eyeL = Offset(s * .35, s * .43);
    final eyeR = Offset(s * .65, s * .43);

    // Төв, өргөн, өндөр, эхлэх ба дуусах өнцгөөр (радиан) нум зурна.
    void arc(Offset c, double w, double h, double start, double end) {
      canvas.drawArc(
        Rect.fromCenter(center: c, width: w, height: h),
        start,
        end - start,
        false,
        stroke,
      );
    }

    void dotEyes([double dy = 0]) {
      for (final eye in [eyeL, eyeR]) {
        canvas.drawCircle(eye.translate(0, dy), s * .05, fill);
      }
    }

    switch (mood) {
      case MoodType.joyful:
        for (final eye in [eyeL, eyeR]) {
          arc(eye.translate(0, s * .02), s * .15, s * .13, pi, 2 * pi);
        }
        canvas.drawArc(
          Rect.fromCenter(center: Offset(s * .5, s * .58), width: s * .36, height: s * .32),
          0,
          pi,
          true,
          fill,
        );
      case MoodType.happy:
        dotEyes();
        arc(Offset(s * .5, s * .56), s * .34, s * .26, .18 * pi, .82 * pi);
      case MoodType.calm:
        for (final eye in [eyeL, eyeR]) {
          arc(eye, s * .15, s * .10, 0, pi);
        }
        arc(Offset(s * .5, s * .62), s * .20, s * .12, .15 * pi, .85 * pi);
      case MoodType.sad:
        dotEyes(s * .01);
        arc(Offset(s * .5, s * .76), s * .28, s * .20, 1.2 * pi, 1.8 * pi);
      case MoodType.angry:
        dotEyes(s * .03);
        canvas.drawLine(Offset(s * .24, s * .31), Offset(s * .42, s * .38), stroke);
        canvas.drawLine(Offset(s * .76, s * .31), Offset(s * .58, s * .38), stroke);
        arc(Offset(s * .5, s * .76), s * .26, s * .16, 1.2 * pi, 1.8 * pi);
    }
  }

  @override
  bool shouldRepaint(_MoodFacePainter old) => old.mood != mood;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Аппын жижиг хөдөлгөөнүүд: үсрэх ([Bounce]), лугших ([Pulse]) ба
/// confetti ([showConfetti]). Төхөөрөмж дээр "хөдөлгөөн багасгах"
/// (reduce motion) тохиргоо асаалттай бол бүгд автоматаар унтарна.
bool _reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

// ------------------------------------------------------------------- Үсрэх

/// [active] нь false-оос true болох бүрт [child]-ийг нэг удаа "үсрүүлнэ".
/// Жишээ нь мэдрэмж сонгоход нүүр нь томроод буцна.
class Bounce extends StatefulWidget {
  const Bounce({required this.active, required this.child, super.key});

  final bool active;
  final Widget child;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  // 1 → 1.3 (томрох) → 0.92 (бага зэрэг шахагдах) → 1 (тогтох)
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
      weight: 30,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.3, end: .92).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 30,
    ),
    TweenSequenceItem(
      tween: Tween(begin: .92, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
  ]).animate(_ctrl);

  @override
  void didUpdateWidget(Bounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active && !_reduceMotion(context)) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// ----------------------------------------------------------------- Лугших

/// [value] өсөх бүрт [child]-ийг 3 удаа лугшуулна (жишээ нь streak нэмэгдэхэд
/// гал). Анх харагдахад [value] 0-ээс их бол нэг удаа зөөлөн лугшина.
class Pulse extends StatefulWidget {
  const Pulse({required this.value, required this.child, super.key});

  final int value;
  final Widget child;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with TickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.35).chain(CurveTween(curve: Curves.easeOut)),
      weight: 45,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.35, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 55,
    ),
  ]).animate(_ctrl);

  /// Мэдрэмж хадгалах цонх хаагдаж дуусахыг хүлээх хугацаа. Timer биш
  /// AnimationController ашигласан тул widget устахад хамт зогсоно.
  late final AnimationController _delay = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  /// Үлдсэн лугшилтын тоо.
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && _remaining > 1) {
        _remaining--;
        _ctrl.forward(from: 0);
      }
    });
    _delay.addStatusListener((status) {
      if (status == AnimationStatus.completed) _play(3);
    });
    if (widget.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play(1));
    }
  }

  @override
  void didUpdateWidget(Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value > oldWidget.value && !_reduceMotion(context)) {
      // Мэдрэмж хадгалах цонх хаагдаж дуусахыг хүлээгээд лугшина.
      _delay.forward(from: 0);
    }
  }

  void _play(int times) {
    if (!mounted || _reduceMotion(context)) return;
    _remaining = times;
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _delay.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// ---------------------------------------------------------------- Confetti

/// Дэлгэцийн дээд талаас confetti буулгана (жишээ нь шинэ тэмдэг нээгдэхэд).
/// Хамгийн дээд давхаргад гарч ирэх тул доод цонх хаагдаж байхад ч харагдана.
void showConfetti(BuildContext context) {
  if (_reduceMotion(context)) return;
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _ConfettiBurst(onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _ConfettiBurst extends StatefulWidget {
  const _ConfettiBurst({required this.onDone});

  final VoidCallback onDone;

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  /// Мэдрэмжийн 5 өнгө + алтан шар.
  static const _colors = [
    Color(0xFFF5B83D),
    Color(0xFF79C9A5),
    Color(0xFF78A8DE),
    Color(0xFF8E8AC8),
    Color(0xFFE8806F),
    Color(0xFFE9C986),
  ];

  late final AnimationController _ctrl;
  late final List<_Piece> _pieces;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _pieces = List.generate(
      90,
      (i) => _Piece(random, _colors[i % _colors.length]),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onDone();
      })
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _ConfettiPainter(_pieces, _ctrl)),
      ),
    );
  }
}

/// Нэг ширхэг цаас: байрлал, хурд, эргэлт, хэлбэр нь санамсаргүй.
class _Piece {
  _Piece(math.Random r, this.color)
      : x = r.nextDouble(),
        delay = r.nextDouble() * .3,
        speed = .75 + r.nextDouble() * .55,
        sway = 8 + r.nextDouble() * 24,
        swaySpeed = 2 + r.nextDouble() * 3,
        phase = r.nextDouble() * math.pi * 2,
        spin = (r.nextDouble() - .5) * 12,
        width = 6 + r.nextDouble() * 5,
        height = 10 + r.nextDouble() * 8,
        round = r.nextDouble() < .3;

  final Color color;
  final double x;
  final double delay;
  final double speed;
  final double sway;
  final double swaySpeed;
  final double phase;
  final double spin;
  final double width;
  final double height;
  final bool round;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.progress) : super(repaint: progress);

  final List<_Piece> pieces;
  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    final paint = Paint();
    for (final piece in pieces) {
      // Цаас бүр өөр өөр хугацаанд унаж эхэлнэ.
      final local = ((t - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;

      final y = -30 + (size.height + 60) * piece.speed * local;
      final x = piece.x * size.width +
          math.sin(piece.phase + local * piece.swaySpeed * math.pi * 2) * piece.sway;
      final opacity = local > .8 ? (1 - (local - .8) / .2) : 1.0;
      paint.color = piece.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.phase + piece.spin * local);
      // Хажуу тийш эргэлдэж байгаа мэт харагдуулахын тулд өргөнийг нь өөрчилнө.
      final flip = math.cos(piece.phase + local * 9).abs().clamp(.25, 1.0);
      canvas.scale(flip, 1);
      if (piece.round) {
        canvas.drawCircle(Offset.zero, piece.width / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: piece.width, height: piece.height),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => false;
}

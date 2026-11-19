import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import '../state/breathing.dart';
import '../widgets/widgets.dart';

enum _Run { idle, running, paused, done }

/// Амьсгалын дасгал: томорч жижгэрэх тойргоор амьсгалыг удирдана.
/// Үе шат солигдох бүрт зөөлөн чичиргээ өгнө (идэвхтэй бол).
class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const BreathingPage());

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _ctrl;

  BreathTechnique _tech = relaxBreathing;
  int _minutes = 1;
  bool _haptic = true;
  _Run _run = _Run.idle;
  int _cycle = 0;
  int _step = 0;
  List<String> _newBadges = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: _tech.cycleSeconds),
    );
    _ctrl.addListener(_onTick);
    _ctrl.addStatusListener(_onStatus);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _run == _Run.running) _pause();
  }

  int get _totalCycles => _tech.cyclesFor(_minutes);

  void _onTick() {
    if (_run != _Run.running) return;
    final idx = _tech.stepIndexAt(_ctrl.value * _tech.cycleSeconds);
    if (idx != _step) {
      _step = idx;
      if (_haptic) HapticFeedback.lightImpact();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _run != _Run.running) return;
    _cycle++;
    if (_cycle >= _totalCycles) {
      _finish();
    } else {
      _ctrl.forward(from: 0);
    }
  }

  void _start() {
    _ctrl.duration = Duration(seconds: _tech.cycleSeconds);
    _cycle = 0;
    _step = 0;
    _newBadges = const [];
    setState(() => _run = _Run.running);
    if (_haptic) HapticFeedback.lightImpact();
    _ctrl.forward(from: 0);
  }

  void _pause() {
    _ctrl.stop();
    setState(() => _run = _Run.paused);
  }

  void _resume() {
    setState(() => _run = _Run.running);
    _ctrl.forward();
  }

  void _stop() {
    setState(() => _run = _Run.idle);
    _ctrl.stop();
    _ctrl.value = 0;
  }

  void _finish() {
    _ctrl.stop();
    final seconds = _cycle * _tech.cycleSeconds;
    final fresh = AppScope.read(context).recordBreathing(seconds);
    if (_haptic) HapticFeedback.mediumImpact();
    setState(() {
      _run = _Run.done;
      _newBadges = fresh;
    });
  }

  void _reset() {
    setState(() => _run = _Run.idle);
    _ctrl.value = 0;
  }

  String _clock(int totalSeconds) {
    final safe = totalSeconds < 0 ? 0 : totalSeconds;
    final m = safe ~/ 60;
    final sec = (safe % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;
    final reduce = MediaQuery.of(context).disableAnimations;
    final active = _run == _Run.running || _run == _Run.paused;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('breath.title'), eyebrow: s('breath.eyebrow')),
          Center(child: _buildOrb(context, reduce)),
          const SizedBox(height: 20),
          if (active) ..._buildActive(context),
          if (_run == _Run.idle) ..._buildSetup(context),
          if (_run == _Run.done) ..._buildDone(context),
          const SizedBox(height: 20),
          Text(
            s('breath.note'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: p.muted, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(BuildContext context, bool reduce) {
    final s = context.s;
    final p = context.pal;
    const box = 264.0;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final sec = _ctrl.value * _tech.cycleSeconds;
        final step = _tech.steps[_tech.stepIndexAt(sec)];

        double scale;
        String title;
        String? sub;
        switch (_run) {
          case _Run.running:
            scale = reduce ? .8 : _tech.scaleAt(sec);
            title = s('breath.phase.${step.phase.name}');
            sub = '${_tech.stepRemainingAt(sec).ceil()}';
          case _Run.paused:
            scale = reduce ? .8 : _tech.scaleAt(sec);
            title = s('breath.paused');
          case _Run.done:
            scale = .8;
            title = s('breath.done');
          case _Run.idle:
            scale = .7;
            title = s('breath.ready');
        }

        return Semantics(
          liveRegion: true,
          label: sub == null ? title : '$title $sub',
          child: SizedBox(
            width: box,
            height: box,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: box,
                  height: box,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: p.line, width: 1.5),
                  ),
                ),
                Container(
                  width: box * scale,
                  height: box * scale,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: p.mint),
                ),
                Container(
                  width: box * scale * .7,
                  height: box * scale * .7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.highlight,
                  ),
                ),
                ExcludeSemantics(
                  child: SizedBox(
                    width: 170,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        if (sub != null)
                          Text(
                            sub,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: p.accent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSetup(BuildContext context) {
    final s = context.s;
    final p = context.pal;
    final app = context.app;

    return [
      GroupLabel(s('breath.technique')),
      SettingsCard(
        children: [
          for (final t in breathTechniques)
            ChoiceTile(
              title: '${s(t.titleKey)} · ${t.pattern}',
              subtitle: s(t.descKey),
              selected: _tech == t,
              onTap: () => setState(() => _tech = t),
            ),
        ],
      ),
      GroupLabel(s('breath.duration')),
      Wrap(
        spacing: 8,
        children: [
          for (final m in breathDurations)
            ChoiceChip(
              label: Text(s.f('breath.minutes', {'n': '$m'})),
              selected: _minutes == m,
              showCheckmark: false,
              backgroundColor: p.soft,
              selectedColor: p.highlight,
              side: BorderSide(
                color: _minutes == m ? p.accent : Colors.transparent,
              ),
              onSelected: (_) => setState(() => _minutes = m),
            ),
        ],
      ),
      const SizedBox(height: 16),
      SettingsCard(
        children: [
          SettingTile(
            icon: AppIcons.vibrate,
            iconColor: p.accent,
            iconBackground: p.highlight,
            title: s('breath.haptic'),
            subtitle: s('breath.hapticHint'),
            trailing: SwitchPill(
              value: _haptic,
              onChanged: (v) => setState(() => _haptic = v),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      PrimaryButton(
        key: const Key('breath_start'),
        icon: AppIcons.playFill,
        label: s('breath.start'),
        onTap: _start,
      ),
      if (app.breathingSessions > 0) ...[
        const SizedBox(height: 12),
        Text(
          s.f('breath.total', {'n': '${app.breathingSessions}'}),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: p.muted),
        ),
      ],
    ];
  }

  List<Widget> _buildActive(BuildContext context) {
    final s = context.s;
    final p = context.pal;
    final cycleSec = _tech.cycleSeconds;
    final totalSec = _totalCycles * cycleSec;

    return [
      AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final elapsed = _cycle * cycleSec + _ctrl.value * cycleSec;
          final remaining = (totalSec - elapsed).ceil();
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (elapsed / totalSec).clamp(0.0, 1.0).toDouble(),
                  minHeight: 8,
                  backgroundColor: p.line,
                  valueColor: AlwaysStoppedAnimation<Color>(p.accent),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.f('breath.remaining', {'time': _clock(remaining)}),
                style: TextStyle(fontSize: 12, color: p.muted),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              key: const Key('breath_pause'),
              onPressed: _run == _Run.running ? _pause : _resume,
              icon: Icon(
                _run == _Run.running
                    ? AppIcons.pauseFill
                    : AppIcons.playFill,
              ),
              label: Text(
                _run == _Run.running ? s('breath.pause') : s('breath.resume'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: p.ink,
                side: BorderSide(color: p.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            key: const Key('breath_stop'),
            onPressed: _stop,
            child: Text(
              s('breath.stop'),
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildDone(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return [
      SoftCard(
        color: p.mint,
        child: Column(
          children: [
            IconBox(icon: AppIcons.lotus, color: p.forest, background: p.card, size: 56),
            const SizedBox(height: 10),
            Text(
              s.f('breath.doneBody', {'n': '$_minutes'}),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.55, color: p.mintInk),
            ),
            for (final id in _newBadges) ...[
              const SizedBox(height: 10),
              Text(
                s.f('ach.new', {'name': s('ach.$id')}),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: p.forest,
                ),
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 16),
      PrimaryButton(
        key: const Key('breath_again'),
        icon: AppIcons.refresh,
        label: s('breath.again'),
        onTap: _reset,
      ),
      const SizedBox(height: 4),
      Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(
            s('common.close'),
            style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ];
  }
}

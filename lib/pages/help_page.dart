import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import '../widgets/widgets.dart';

/// Тусламж: түгээмэл асуулт, санал хүсэлт илгээх.
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _feedback = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  void _send() {
    final text = _feedback.text.trim();
    if (text.isEmpty) {
      showSnack(context, context.s('help.empty'));
      return;
    }
    FocusScope.of(context).unfocus();
    AppScope.read(context).addFeedback(text);
    _feedback.clear();
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('help.title'), eyebrow: s('help.eyebrow')),
          SoftCard(
            color: p.highlight,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: p.accent,
                  child: const Text(
                    '?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s('help.banner'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  s('help.bannerBody'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: p.muted, height: 1.5),
                ),
              ],
            ),
          ),
          GroupLabel(s('help.faq')),
          SettingsCard(
            children: [
              for (final n in const [1, 2, 3, 4])
                FaqTile(question: s('faq.$n.q'), answer: s('faq.$n.a')),
            ],
          ),
          GroupLabel(s('help.feedback')),
          NoteField(
            controller: _feedback,
            hint: s('help.feedbackHint'),
            maxLength: 600,
            onChanged: (_) {
              if (_sent) setState(() => _sent = false);
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            key: const Key('help_send'),
            icon: _sent ? Icons.check_rounded : Icons.send_outlined,
            label: _sent ? s('help.sent') : s('help.send'),
            onTap: _send,
          ),
          if (_sent) ...[
            const SizedBox(height: 10),
            Text(
              s('help.thanks'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: p.muted),
            ),
          ],
        ],
      ),
    );
  }
}

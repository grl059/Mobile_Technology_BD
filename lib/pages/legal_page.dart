import 'package:flutter/material.dart';

import '../core/core.dart';
import '../widgets/widgets.dart';

enum LegalKind { terms, privacy }

/// Үйлчилгээний нөхцөл / Нууцлалын бодлого.
class LegalPage extends StatelessWidget {
  const LegalPage({required this.kind, super.key});

  final LegalKind kind;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(
            title: s('legal.${kind.name}'),
            eyebrow: s('legal.eyebrow'),
          ),
          for (final n in const [1, 2, 3, 4])
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SoftCard(
                child: Text(
                  s('legal.${kind.name}.$n'),
                  style: TextStyle(fontSize: 13.5, height: 1.65, color: p.ink),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

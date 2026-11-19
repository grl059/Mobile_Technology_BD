import 'package:flutter/material.dart';

import '../core/core.dart';
import '../widgets/widgets.dart';
import 'legal_page.dart';

/// Аппын тухай: хувилбар, зорилго, нөхцөл, нууцлал, лиценз.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String version = '1.1.0';

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: 'Mindful', eyebrow: s('about.eyebrow')),
          Center(
            child: Container(
              width: 76,
              height: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.forest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3038574A),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(AppIcons.lotus, size: 40, color: p.onForest),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mindful',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          Text(
            s('app.tagline'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted),
          ),
          const SizedBox(height: 10),
          Center(
            child: Chip(
              label: Text(
                s.f('about.version', {'v': version}),
                style: const TextStyle(fontSize: 11),
              ),
              side: BorderSide(color: p.line),
              backgroundColor: p.soft,
            ),
          ),
          const SizedBox(height: 18),
          SoftCard(
            color: p.warm,
            child: Column(
              children: [
                Text(
                  s('auth.heroTitle'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  s('about.body'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, height: 1.7, color: p.warmInk),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SettingsCard(
            children: [
              SettingTile(
                title: s('legal.terms'),
                onTap: () => pushPage<void>(
                  context,
                  const LegalPage(kind: LegalKind.terms),
                ),
              ),
              SettingTile(
                title: s('legal.privacy'),
                onTap: () => pushPage<void>(
                  context,
                  const LegalPage(kind: LegalKind.privacy),
                ),
              ),
              SettingTile(
                title: s('about.licenses'),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Mindful',
                  applicationVersion: version,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            s('about.footer'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: p.muted),
          ),
        ],
      ),
    );
  }
}

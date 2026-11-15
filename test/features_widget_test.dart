import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/app.dart';
import 'package:mood_tracker/core/l10n.dart';
import 'package:mood_tracker/models/models.dart';
import 'package:mood_tracker/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const S mn = S('mn');

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Амьсгалын анимаци ажиллаж байхад pumpAndSettle дуусахгүй тул
/// тогтсон хугацаагаар pump хийнэ.
Future<void> tapAndPump(WidgetTester tester, Finder finder, Duration d) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump(d);
}

Future<AppState> startRegistered(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2800);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = (await tester.runAsync(AppState.load))!;
  await tester.pumpWidget(MindfulApp(state: state, useGoogleFonts: false));
  await tester.pumpAndSettle();

  await tapVisible(tester, find.byKey(const Key('tab_register')));
  await tester.enterText(find.byKey(const Key('auth_name')), 'Номин Эрдэнэ');
  await tester.enterText(find.byKey(const Key('auth_email')), 'nomin@email.com');
  await tester.enterText(find.byKey(const Key('auth_password')), 'secret1');
  await tapVisible(tester, find.text(mn('auth.terms')));
  await tapVisible(tester, find.byKey(const Key('auth_submit')));
  expect(find.text('Сайн уу, Номин'), findsOneWidget);
  return state;
}

void main() {
  testWidgets('амжилтын хуудас: сорилт эхлүүлж, зогсооно', (tester) async {
    final state = await startRegistered(tester);

    await tapVisible(tester, find.byKey(const Key('home_achievements')));
    expect(find.text(mn('chal.title')), findsOneWidget);
    expect(state.challengeStatus, ChallengeStatus.none);

    await tapVisible(tester, find.byKey(const Key('challenge_start')));
    expect(state.challengeStatus, ChallengeStatus.active);
    expect(find.byKey(const Key('challenge_stop')), findsOneWidget);

    await tapVisible(tester, find.byKey(const Key('challenge_stop')));
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(mn('chal.stop')),
      ),
    );
    expect(state.challengeStatus, ChallengeStatus.none);
    expect(find.byKey(const Key('challenge_start')), findsOneWidget);
  });

  testWidgets('мэдрэмж хадгалахад тэмдэг нээгдэж, мэдэгдэл ирнэ', (tester) async {
    final state = await startRegistered(tester);

    await tapVisible(tester, find.byKey(const Key('home_add_mood')));
    await tapVisible(tester, find.text(mn('mood.happy')));
    await tapVisible(tester, find.byKey(const Key('mood_save')));

    expect(state.isUnlocked('first'), isTrue);
    expect(state.notifications.any((n) => n.type == 'badge'), isTrue);
  });

  testWidgets('амьсгалын дасгал: эхлүүлж, түр зогсоож, дуусгана', (tester) async {
    await startRegistered(tester);

    await tapVisible(tester, find.byKey(const Key('home_breathing')));
    expect(find.byKey(const Key('breath_start')), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const Key('breath_start')),
      const Duration(seconds: 1),
    );
    expect(find.byKey(const Key('breath_pause')), findsOneWidget);
    expect(find.text(mn('breath.phase.inhale')), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text(mn('breath.phase.exhale')), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const Key('breath_pause')),
      const Duration(milliseconds: 100),
    );
    expect(find.text(mn('breath.paused')), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const Key('breath_stop')),
      const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('breath_start')), findsOneWidget);
  });
}

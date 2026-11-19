import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/app.dart';
import 'package:mood_tracker/core/l10n.dart';
import 'package:mood_tracker/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const S mn = S('mn');

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('бүртгүүлж, мэдрэмж тэмдэглээд, гарна', (tester) async {
    tester.view.physicalSize = const Size(1080, 2800);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues(<String, Object>{});
    final state = (await tester.runAsync(AppState.load))!;

    await tester.pumpWidget(MindfulApp(state: state));
    await tester.pumpAndSettle();

    // 1. Нэвтрэх хуудас харагдана
    expect(find.byKey(const Key('auth_submit')), findsOneWidget);

    // 2. Бүртгүүлэх
    await tapVisible(tester, find.byKey(const Key('tab_register')));
    await tester.enterText(find.byKey(const Key('auth_name')), 'Номин Эрдэнэ');
    await tester.enterText(find.byKey(const Key('auth_email')), 'nomin@email.com');
    await tester.enterText(find.byKey(const Key('auth_password')), 'secret1');
    await tapVisible(tester, find.text(mn('auth.terms')));
    await tapVisible(tester, find.byKey(const Key('auth_submit')));

    // 3. Нүүр хуудас
    expect(find.text('Сайн уу, Номин'), findsOneWidget);

    // 4. Мэдрэмж тэмдэглэх
    await tapVisible(tester, find.byKey(const Key('home_add_mood')));
    await tapVisible(tester, find.text(mn('mood.happy')));
    await tapVisible(tester, find.byKey(const Key('mood_save')));
    expect(find.text('Өнөөдөр: ${mn('mood.happy')}'), findsOneWidget);
    expect(state.entryFor(DateTime.now()), isNotNull);

    // 5. Тохиргоо руу орж гарах
    await tapVisible(tester, find.text(mn('nav.settings')));
    await tapVisible(tester, find.byKey(const Key('settings_logout')));
    await tapVisible(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(mn('settings.logout')),
      ),
    );
    expect(find.byKey(const Key('auth_submit')), findsOneWidget);
    expect(state.isLoggedIn, isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/core/dates.dart';
import 'package:mood_tracker/core/l10n.dart';
import 'package:mood_tracker/core/l10n_strings.dart';
import 'package:mood_tracker/core/palette.dart';
import 'package:mood_tracker/models/models.dart';
import 'package:mood_tracker/state/app_state.dart';
import 'package:mood_tracker/state/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> freshState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return AppState.load();
}

Future<AppState> registeredState() async {
  final state = await freshState();
  final error = state.register(
    name: 'Номин Эрдэнэ',
    email: 'nomin@email.com',
    password: 'secret1',
  );
  expect(error, isNull);
  return state;
}

void main() {
  group('Нэвтрэлт', () {
    test('бүртгүүлж, гарч, дахин нэвтэрнэ', () async {
      final state = await freshState();
      expect(state.isLoggedIn, isFalse);

      final error = state.register(
        name: 'Номин Эрдэнэ',
        email: ' Nomin@Email.com ',
        password: 'secret1',
      );
      expect(error, isNull);
      expect(state.isLoggedIn, isTrue);
      expect(state.user!.email, 'nomin@email.com');
      expect(state.user!.firstName, 'Номин');

      state.logout();
      expect(state.isLoggedIn, isFalse);

      expect(state.login('nomin@email.com', 'wrong'), 'err.wrongPassword');
      expect(state.login('nobody@email.com', 'secret1'), 'err.noAccount');
      expect(state.login('NOMIN@email.com', 'secret1'), isNull);
      expect(state.isLoggedIn, isTrue);
    });

    test('давхар и-мэйлээр бүртгүүлэхийг хориглоно', () async {
      final state = await registeredState();
      state.logout();
      final error = state.register(
        name: 'Өөр хүн',
        email: 'nomin@email.com',
        password: 'another1',
      );
      expect(error, 'err.emailTaken');
      expect(state.isLoggedIn, isFalse);
    });

    test('нууц үг сэргээж, солино', () async {
      final state = await registeredState();
      state.logout();
      expect(state.resetPassword('nobody@email.com', 'newpass1'), 'err.noAccount');
      expect(state.resetPassword('nomin@email.com', 'newpass1'), isNull);
      expect(state.login('nomin@email.com', 'secret1'), 'err.wrongPassword');
      expect(state.login('nomin@email.com', 'newpass1'), isNull);

      expect(state.changePassword('bad', 'third123'), 'err.wrongPassword');
      expect(state.changePassword('newpass1', 'third123'), isNull);
      state.logout();
      expect(state.login('nomin@email.com', 'third123'), isNull);
    });

    test('профайл шинэчилж, и-мэйл давхцахыг шалгана', () async {
      final state = await registeredState();
      state.logout();
      state.register(name: 'Хоёр', email: 'two@email.com', password: 'secret2');

      final taken = state.updateProfile(
        name: 'Хоёр',
        email: 'nomin@email.com',
        birthday: null,
        avatar: 1,
      );
      expect(taken, 'err.emailTaken');

      final ok = state.updateProfile(
        name: 'Хоёр Шинэ',
        email: 'two@email.com',
        birthday: DateTime(1999, 1, 2),
        avatar: 3,
      );
      expect(ok, isNull);
      expect(state.user!.name, 'Хоёр Шинэ');
      expect(state.user!.avatar, 3);
      expect(dateKey(state.user!.birthday!), '1999-01-02');
    });

    test('хэрэглэгч бүрийн өгөгдөл тусдаа хадгалагдана', () async {
      final state = await registeredState();
      final today = dateOnly(DateTime.now());
      state.saveEntry(date: today, mood: MoodType.joyful, note: '', tags: const []);
      expect(state.allEntries.length, 1);

      state.logout();
      state.register(name: 'Хоёр', email: 'two@email.com', password: 'secret2');
      expect(state.allEntries, isEmpty);

      state.logout();
      state.login('nomin@email.com', 'secret1');
      expect(state.allEntries.length, 1);
    });
  });

  group('Мэдрэмжийн бүртгэл', () {
    test('хадгалж, дахин ачаалахад үлдэнэ; дараалал тоологдоно', () async {
      final state = await registeredState();
      final today = dateOnly(DateTime.now());

      state.saveEntry(
        date: today,
        mood: MoodType.happy,
        note: '  Сайхан өдөр  ',
        tags: const ['work'],
      );
      state.saveEntry(
        date: addDays(today, -1),
        mood: MoodType.calm,
        note: '',
        tags: const [],
      );
      state.saveEntry(
        date: addDays(today, -3),
        mood: MoodType.sad,
        note: '',
        tags: const [],
      );

      expect(state.entryFor(today)!.note, 'Сайхан өдөр');
      expect(state.streak, 2);

      final reloaded = await AppState.load();
      expect(reloaded.isLoggedIn, isTrue);
      expect(reloaded.allEntries.length, 3);
      expect(reloaded.entryFor(today)!.mood, MoodType.happy);
      expect(reloaded.entryFor(today)!.tags, ['work']);
    });

    test('засаж, устгана', () async {
      final state = await registeredState();
      final today = dateOnly(DateTime.now());
      state.saveEntry(date: today, mood: MoodType.happy, note: 'a', tags: const []);
      state.saveEntry(date: today, mood: MoodType.angry, note: 'b', tags: const []);
      expect(state.allEntries.length, 1);
      expect(state.entryFor(today)!.mood, MoodType.angry);

      state.deleteEntry(today);
      expect(state.entryFor(today), isNull);
      expect(state.streak, 0);
    });

    test('статистик: 7 хоногийн дундаж', () async {
      final state = await registeredState();
      final today = dateOnly(DateTime.now());
      state.saveEntry(date: today, mood: MoodType.joyful, note: '', tags: const ['work']);
      state.saveEntry(date: addDays(today, -1), mood: MoodType.calm, note: '', tags: const ['work']);
      state.saveEntry(date: addDays(today, -2), mood: MoodType.angry, note: '', tags: const []);

      final stats = computeStats(state, StatsRange.week, const S('en'), DateTime.now());
      expect(stats.buckets.length, 7);
      expect(stats.count, 3);
      expect(stats.avg, closeTo(3.0, 0.0001));
      expect(stats.topTag, 'work');
      expect(stats.buckets.last.avg, 5);
    });

    test('цэвэрлэх', () async {
      final state = await registeredState();
      state.saveEntry(
        date: DateTime.now(),
        mood: MoodType.happy,
        note: '',
        tags: const [],
      );
      state.clearAllData();
      expect(state.allEntries, isEmpty);
      expect(state.notifications.where((n) => n.id == 'welcome'), isEmpty);
    });
  });

  group('Мэдэгдэл', () {
    test('бүртгүүлэхэд угтах мэдэгдэл үүсч, уншсан болгоно', () async {
      final state = await registeredState();
      expect(state.notifications.any((n) => n.id == 'welcome'), isTrue);
      expect(state.unreadCount, greaterThan(0));
      state.markAllRead();
      expect(state.unreadCount, 0);
      state.removeNotification('welcome');
      expect(state.notifications.any((n) => n.id == 'welcome'), isFalse);
    });

    test('3 өдрийн дараалалд шагналын мэдэгдэл үүснэ', () async {
      final state = await registeredState();
      final today = dateOnly(DateTime.now());
      for (var i = 0; i < 3; i++) {
        state.saveEntry(
          date: addDays(today, -i),
          mood: MoodType.happy,
          note: '',
          tags: const [],
        );
      }
      expect(state.notifications.any((n) => n.type == 'streak'), isTrue);
    });
  });

  group('Тохиргоо', () {
    test('сэдэв, хэл, сануулга хадгалагдана', () async {
      final state = await registeredState();
      state.setLanguage('en');
      state.setThemeMode(AppThemeMode.dark);
      state.setFollowSystem(true);
      state.setReminder(const ReminderSettings(enabled: false, hour: 8, days: {0, 2}));

      final reloaded = await AppState.load();
      expect(reloaded.language, 'en');
      expect(reloaded.themeMode, AppThemeMode.dark);
      expect(reloaded.followSystem, isTrue);
      expect(reloaded.reminder.enabled, isFalse);
      expect(reloaded.reminder.hour, 8);
      expect(reloaded.reminder.days, {0, 2});

      state.setLanguage('xx'); // дэмжигдээгүй хэл үл тооно
      expect(state.language, 'en');
    });
  });

  group('Орчуулга', () {
    test('түлхүүр бүр 3 хэлтэй, хоосон биш', () {
      for (final entry in kStrings.entries) {
        expect(entry.value.length, 3, reason: entry.key);
        for (final text in entry.value) {
          expect(text.trim(), isNotEmpty, reason: entry.key);
        }
      }
    });

    test('орлуулагч ажиллана, хэл бүрээр өөр текст буцаана', () {
      const mn = S('mn');
      const en = S('en');
      const ko = S('ko');
      expect(mn.f('cal.days', {'n': '5'}), '5 өдөр');
      expect(en.f('cal.days', {'n': '5'}), '5 days');
      expect(ko.f('cal.days', {'n': '5'}), '5일');
      expect(mn('nav.home'), isNot(en('nav.home')));
      expect(en('missing.key'), 'missing.key');
    });
  });
}

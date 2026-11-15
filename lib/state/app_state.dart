import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/dates.dart';
import '../core/palette.dart';
import '../models/models.dart';

/// Аппын бүх төлөв. Өгөгдөл `shared_preferences`-д төхөөрөмж дээр хадгалагдана.
///
/// Алдааны үед `String?` буцаадаг функцууд l10n түлхүүр (жишээ нь
/// `err.emailTaken`) буцаана; амжилттай бол `null`.
class AppState extends ChangeNotifier {
  AppState._(this._prefs);

  final SharedPreferences _prefs;

  static const supportedLanguages = ['mn', 'en', 'ko'];

  static Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final state = AppState._(prefs);
    state._restore();
    return state;
  }

  // ---------------------------------------------------------------- Төлөв

  AppThemeMode themeMode = AppThemeMode.nature;
  bool followSystem = false;
  String language = 'mn';

  List<UserAccount> _accounts = [];
  UserAccount? user;
  Map<String, MoodEntry> _entries = {};
  List<AppNotification> notifications = [];
  ReminderSettings reminder = const ReminderSettings();

  /// Хэрэглэгчийн устгасан мэдэгдлийн id-ууд. Автомат үүсгэлт дахин нэмэхээс сэргийлнэ.
  Set<String> _dismissed = {};

  bool get isLoggedIn => user != null;

  // ------------------------------------------------------------ Сэргээлт

  void _restore() {
    final theme = _prefs.getString('app.theme');
    for (final m in AppThemeMode.values) {
      if (m.name == theme) themeMode = m;
    }
    followSystem = _prefs.getBool('app.followSystem') ?? false;
    final lang = _prefs.getString('app.lang');
    if (lang != null && supportedLanguages.contains(lang)) language = lang;

    _accounts = _readList('accounts')
        .map(UserAccount.tryParse)
        .whereType<UserAccount>()
        .toList();
    final sessionId = _prefs.getString('session');
    for (final a in _accounts) {
      if (a.id == sessionId) user = a;
    }
    if (user != null) _loadUserData();
  }

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
    } catch (_) {
      // Эвдэрсэн өгөгдлийг алгасна.
    }
    return [];
  }

  String _k(String name) => 'u/${user!.id}/$name';

  void _loadUserData() {
    _entries = {};
    for (final json in _readList(_k('entries'))) {
      final e = MoodEntry.tryParse(json);
      if (e != null) _entries[dateKey(e.date)] = e;
    }
    notifications = _readList(_k('notifs'))
        .map(AppNotification.tryParse)
        .whereType<AppNotification>()
        .toList();
    _dismissed = (_prefs.getStringList(_k('dismissed')) ?? <String>[]).toSet();
    final rawReminder = _prefs.getString(_k('reminder'));
    reminder = const ReminderSettings();
    if (rawReminder != null) {
      try {
        final decoded = jsonDecode(rawReminder);
        if (decoded is Map<String, dynamic>) {
          reminder = ReminderSettings.fromJson(decoded);
        }
      } catch (_) {
        // Анхны тохиргоо хэвээр үлдэнэ.
      }
    }
    refreshNotifications(notify: false);
  }

  // ---------------------------------------------------------- Хадгалалт

  void _saveAccounts() {
    _prefs.setString(
      'accounts',
      jsonEncode(_accounts.map((a) => a.toJson()).toList()),
    );
  }

  void _saveEntries() {
    _prefs.setString(
      _k('entries'),
      jsonEncode(_entries.values.map((e) => e.toJson()).toList()),
    );
  }

  void _saveNotifications() {
    _prefs.setString(
      _k('notifs'),
      jsonEncode(notifications.map((n) => n.toJson()).toList()),
    );
  }

  void _saveDismissed() {
    var list = _dismissed.toList();
    if (list.length > 300) list = list.sublist(list.length - 300);
    _dismissed = list.toSet();
    _prefs.setStringList(_k('dismissed'), list);
  }

  void _saveReminder() {
    _prefs.setString(_k('reminder'), jsonEncode(reminder.toJson()));
  }

  // ------------------------------------------------- Төхөөрөмжийн тохиргоо

  void setThemeMode(AppThemeMode mode) {
    themeMode = mode;
    _prefs.setString('app.theme', mode.name);
    notifyListeners();
  }

  void setFollowSystem(bool value) {
    followSystem = value;
    _prefs.setBool('app.followSystem', value);
    notifyListeners();
  }

  void setLanguage(String code) {
    if (!supportedLanguages.contains(code)) return;
    language = code;
    _prefs.setString('app.lang', code);
    notifyListeners();
  }

  // ------------------------------------------------------------- Нэвтрэлт

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  static const minPasswordLength = 6;

  String _newSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hash(String salt, String password) {
    return sha256.convert(utf8.encode('$salt:$password')).toString();
  }

  UserAccount? _findByEmail(String normalizedEmail) {
    for (final a in _accounts) {
      if (a.email == normalizedEmail) return a;
    }
    return null;
  }

  String? register({
    required String name,
    required String email,
    required String password,
  }) {
    final mail = normalizeEmail(email);
    if (_findByEmail(mail) != null) return 'err.emailTaken';
    final salt = _newSalt();
    final account = UserAccount(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      email: mail,
      salt: salt,
      hash: _hash(salt, password),
    );
    _accounts = [..._accounts, account];
    _saveAccounts();
    _signIn(account, isNew: true);
    return null;
  }

  String? login(String email, String password) {
    final account = _findByEmail(normalizeEmail(email));
    if (account == null) return 'err.noAccount';
    if (account.hash != _hash(account.salt, password)) {
      return 'err.wrongPassword';
    }
    _signIn(account);
    return null;
  }

  void _signIn(UserAccount account, {bool isNew = false}) {
    user = account;
    _prefs.setString('session', account.id);
    _loadUserData();
    if (isNew) {
      _addNotification(
        AppNotification(id: 'welcome', type: 'welcome', time: DateTime.now()),
      );
    }
    notifyListeners();
  }

  void logout() {
    user = null;
    _entries = {};
    notifications = [];
    _dismissed = {};
    reminder = const ReminderSettings();
    _prefs.remove('session');
    notifyListeners();
  }

  /// Бүртгэлгүй (нэвтрээгүй) үед нууц үг сэргээнэ. Аппд сервер байхгүй тул
  /// и-мэйл хаяг төхөөрөмж дээр бүртгэлтэй эсэхийг шалгаад шууд шинэчилнэ.
  String? resetPassword(String email, String newPassword) {
    final account = _findByEmail(normalizeEmail(email));
    if (account == null) return 'err.noAccount';
    final salt = _newSalt();
    _replaceAccount(account.copyWith(salt: salt, hash: _hash(salt, newPassword)));
    return null;
  }

  bool checkPassword(String password) {
    final u = user;
    if (u == null) return false;
    return u.hash == _hash(u.salt, password);
  }

  String? changePassword(String current, String next) {
    final u = user;
    if (u == null) return 'err.noAccount';
    if (!checkPassword(current)) return 'err.wrongPassword';
    final salt = _newSalt();
    _replaceAccount(u.copyWith(salt: salt, hash: _hash(salt, next)));
    notifyListeners();
    return null;
  }

  String? updateProfile({
    required String name,
    required String email,
    required DateTime? birthday,
    required int avatar,
  }) {
    final u = user;
    if (u == null) return 'err.noAccount';
    final mail = normalizeEmail(email);
    final other = _findByEmail(mail);
    if (other != null && other.id != u.id) return 'err.emailTaken';
    _replaceAccount(
      u.copyWith(
        name: name.trim(),
        email: mail,
        birthday: birthday,
        clearBirthday: birthday == null,
        avatar: avatar,
      ),
    );
    notifyListeners();
    return null;
  }

  void _replaceAccount(UserAccount updated) {
    _accounts = [
      for (final a in _accounts) a.id == updated.id ? updated : a,
    ];
    if (user?.id == updated.id) user = updated;
    _saveAccounts();
  }

  // ------------------------------------------------------ Мэдрэмжийн бүртгэл

  MoodEntry? entryFor(DateTime date) => _entries[dateKey(date)];

  List<MoodEntry> get allEntries => _entries.values.toList();

  /// [start]-аас [end] хүртэлх (хоёулаа орно) бүртгэлүүд, хуучнаас шинэ рүү.
  List<MoodEntry> entriesInRange(DateTime start, DateTime end) {
    final s = dateOnly(start);
    final e = dateOnly(end);
    final list = _entries.values
        .where((x) => !x.date.isBefore(s) && !x.date.isAfter(e))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  void saveEntry({
    required DateTime date,
    required MoodType mood,
    required String note,
    required List<String> tags,
  }) {
    final d = dateOnly(date);
    _entries[dateKey(d)] = MoodEntry(
      date: d,
      mood: mood,
      note: note.trim(),
      tags: List<String>.of(tags),
      updatedAt: DateTime.now(),
    );
    _saveEntries();
    refreshNotifications(notify: false);
    notifyListeners();
  }

  void deleteEntry(DateTime date) {
    _entries.remove(dateKey(date));
    _saveEntries();
    refreshNotifications(notify: false);
    notifyListeners();
  }

  /// Өнөөдрөөс (өнөөдөр тэмдэглээгүй бол өчигдрөөс) эхлэн дараалсан өдрийн тоо.
  int get streak {
    var day = dateOnly(DateTime.now());
    if (!_entries.containsKey(dateKey(day))) day = addDays(day, -1);
    var count = 0;
    while (_entries.containsKey(dateKey(day))) {
      count++;
      day = addDays(day, -1);
    }
    return count;
  }

  static double? averageScore(Iterable<MoodEntry> entries) {
    var total = 0;
    var count = 0;
    for (final e in entries) {
      total += e.mood.score;
      count++;
    }
    return count == 0 ? null : total / count;
  }

  void clearAllData() {
    if (user == null) return;
    _entries = {};
    notifications = [];
    _dismissed = {};
    _saveEntries();
    _saveNotifications();
    _saveDismissed();
    refreshNotifications(notify: false);
    notifyListeners();
  }

  // ------------------------------------------------------------- Сануулга

  void setReminder(ReminderSettings value) {
    if (user == null) return;
    reminder = value;
    _saveReminder();
    refreshNotifications(notify: false);
    notifyListeners();
  }

  // ------------------------------------------------------------- Мэдэгдэл

  int get unreadCount => notifications.where((n) => !n.read).length;

  bool _addNotification(AppNotification n) {
    if (notifications.any((x) => x.id == n.id)) return false;
    notifications = [n, ...notifications];
    _sortAndTrimNotifications();
    _saveNotifications();
    return true;
  }

  void _sortAndTrimNotifications() {
    notifications.sort((a, b) => b.time.compareTo(a.time));
    if (notifications.length > 60) {
      notifications = notifications.sublist(0, 60);
    }
  }

  /// Мэдэгдлүүдийг одоогийн төлөвт тулгуурлан шинэчилнэ: өдрийн сануулга,
  /// дараалал (streak)-ын шагнал, өмнөх долоо хоногийн дүгнэлт.
  /// Апп нээгдэх, сэргэх, бүртгэл өөрчлөгдөх бүрт дуудагдана.
  void refreshNotifications({bool notify = true}) {
    if (user == null) return;
    final now = DateTime.now();
    final today = dateOnly(now);
    final todayKey = dateKey(today);
    var changed = false;

    void add(AppNotification n) {
      if (_dismissed.contains(n.id)) return;
      if (notifications.any((x) => x.id == n.id)) return;
      notifications = [n, ...notifications];
      changed = true;
    }

    // 1. Өдрийн сануулга
    final reminderId = 'reminder-$todayKey';
    if (_entries.containsKey(todayKey)) {
      final before = notifications.length;
      notifications.removeWhere((n) => n.id == reminderId);
      if (notifications.length != before) changed = true;
    } else if (reminder.enabled &&
        reminder.days.contains(now.weekday - 1) &&
        now.hour >= reminder.hour) {
      add(
        AppNotification(
          id: reminderId,
          type: 'reminder',
          time: DateTime(today.year, today.month, today.day, reminder.hour),
        ),
      );
    }

    // 2. Дарааллын шагнал (хамгийн өндөр хүрсэн босго)
    final current = streak;
    int? milestone;
    for (final m in const [3, 7, 14, 30, 60, 100]) {
      if (current >= m) milestone = m;
    }
    if (milestone != null) {
      final lastDay =
          _entries.containsKey(todayKey) ? today : addDays(today, -1);
      final firstDay = addDays(lastDay, -(current - 1));
      add(
        AppNotification(
          id: 'streak-$milestone-${dateKey(firstDay)}',
          type: 'streak',
          time: now,
          args: {'n': '$milestone'},
        ),
      );
    }

    // 3. Өмнөх долоо хоногийн дүгнэлт
    final thisMonday = startOfWeek(today);
    final prevMonday = addDays(thisMonday, -7);
    final prevWeek = entriesInRange(prevMonday, addDays(thisMonday, -1));
    final avg = averageScore(prevWeek);
    if (prevWeek.length >= 2 && avg != null) {
      add(
        AppNotification(
          id: 'weekly-${dateKey(thisMonday)}',
          type: 'weekly',
          time: now,
          args: {
            'n': '${prevWeek.length}',
            'mood': MoodTypeX.fromScore(avg).name,
          },
        ),
      );
    }

    if (changed) {
      _sortAndTrimNotifications();
      _saveNotifications();
      if (notify) notifyListeners();
    }
  }

  void markRead(String id) {
    var changed = false;
    for (final n in notifications) {
      if (n.id == id && !n.read) {
        n.read = true;
        changed = true;
      }
    }
    if (changed) {
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    _saveNotifications();
    notifyListeners();
  }

  void removeNotification(String id) {
    notifications = notifications.where((n) => n.id != id).toList();
    _dismissed.add(id);
    _saveDismissed();
    _saveNotifications();
    notifyListeners();
  }

  void clearNotifications() {
    _dismissed.addAll(notifications.map((n) => n.id));
    notifications = [];
    _saveDismissed();
    _saveNotifications();
    notifyListeners();
  }

  // ----------------------------------------------------------- Санал хүсэлт

  void addFeedback(String text) {
    if (user == null) return;
    final list = _readList(_k('feedback'));
    list.add({
      'text': text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    _prefs.setString(_k('feedback'), jsonEncode(list));
  }
}

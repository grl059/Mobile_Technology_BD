/// Өдөр тутмын сануулгын тохиргоо.
/// `days` нь 0 = Даваа ... 6 = Ням.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = true,
    this.hour = 21,
    this.days = const <int>{0, 1, 2, 3, 4, 5, 6},
  });

  final bool enabled;
  final int hour;
  final Set<int> days;

  ReminderSettings copyWith({bool? enabled, int? hour, Set<int>? days}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'hour': hour,
        'days': days.toList()..sort(),
      };

  static ReminderSettings fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'];
    final hour = json['hour'];
    return ReminderSettings(
      enabled: json['enabled'] != false,
      hour: hour is int ? hour.clamp(0, 23).toInt() : 21,
      days: rawDays is List
          ? rawDays.whereType<int>().where((d) => d >= 0 && d <= 6).toSet()
          : const <int>{0, 1, 2, 3, 4, 5, 6},
    );
  }
}

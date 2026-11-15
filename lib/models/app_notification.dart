/// Мэдэгдлийн төвд харагдах нэг мэдэгдэл.
///
/// Текстийг хадгалахгүй, зөвхөн `type` ба `args`-ийг хадгална. Ингэснээр хэл
/// солиход мэдэгдлийн текст шууд орчуулагдана.
class AppNotification {
  AppNotification({
    required this.id,
    required this.type,
    required this.time,
    this.read = false,
    this.args = const <String, String>{},
  });

  final String id;

  /// welcome | reminder | streak | weekly | badge
  final String type;
  final DateTime time;
  bool read;
  final Map<String, String> args;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'time': time.millisecondsSinceEpoch,
        'read': read,
        'args': args,
      };

  static AppNotification? tryParse(Map<String, dynamic> json) {
    final id = json['id'];
    final type = json['type'];
    final time = json['time'];
    if (id is! String || type is! String || time is! int) return null;
    final rawArgs = json['args'];
    final args = <String, String>{};
    if (rawArgs is Map) {
      rawArgs.forEach((key, value) {
        args['$key'] = '$value';
      });
    }
    return AppNotification(
      id: id,
      type: type,
      time: DateTime.fromMillisecondsSinceEpoch(time),
      read: json['read'] == true,
      args: args,
    );
  }
}

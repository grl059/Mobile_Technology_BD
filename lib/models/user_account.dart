import '../core/dates.dart';

/// Төхөөрөмж дээр хадгалагдах хэрэглэгчийн бүртгэл.
class UserAccount {
  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.salt,
    required this.hash,
    this.birthday,
    this.avatar = 0,
  });

  final String id;
  final String name;
  final String email;
  final String salt;
  final String hash;
  final DateTime? birthday;
  final int avatar;

  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  UserAccount copyWith({
    String? name,
    String? email,
    String? salt,
    String? hash,
    DateTime? birthday,
    bool clearBirthday = false,
    int? avatar,
  }) {
    return UserAccount(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      salt: salt ?? this.salt,
      hash: hash ?? this.hash,
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'salt': salt,
        'hash': hash,
        'birthday': birthday == null ? null : dateKey(birthday!),
        'avatar': avatar,
      };

  static UserAccount? tryParse(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    final salt = json['salt'];
    final hash = json['hash'];
    if (id is! String ||
        name is! String ||
        email is! String ||
        salt is! String ||
        hash is! String) {
      return null;
    }
    final avatar = json['avatar'];
    final rawBirthday = json['birthday'];
    return UserAccount(
      id: id,
      name: name,
      email: email,
      salt: salt,
      hash: hash,
      birthday: parseDateKey(rawBirthday is String ? rawBirthday : null),
      avatar: avatar is int ? avatar : 0,
    );
  }
}

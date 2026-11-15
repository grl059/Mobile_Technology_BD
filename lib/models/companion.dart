/// Хэрэглэгчийн сонгох боломжтой найзын төрлүүд (өөрсдийн зурсан дүрүүд).
enum CompanionKind { sun, bubble, mushroom, star, leaf }

/// Нүүр хуудсан дээрх найзын харагдах хэмжээ.
enum CompanionSize { large, small, hidden }

/// Сонгосон найз ба хэмжээ. Хэрэглэгч бүрт тусдаа хадгалагдана.
class CompanionSettings {
  const CompanionSettings({
    this.kind = CompanionKind.sun,
    this.size = CompanionSize.large,
  });

  final CompanionKind kind;
  final CompanionSize size;

  /// l10n түлхүүр: найзын нэр.
  String get nameKey => 'comp.${kind.name}';

  CompanionSettings copyWith({CompanionKind? kind, CompanionSize? size}) {
    return CompanionSettings(kind: kind ?? this.kind, size: size ?? this.size);
  }

  Map<String, dynamic> toJson() => {'kind': kind.name, 'size': size.name};

  /// Эвдэрсэн эсвэл дутуу өгөгдөлд анхны утгыг ашиглана.
  static CompanionSettings fromJson(Map<String, dynamic> json) {
    var kind = CompanionKind.sun;
    var size = CompanionSize.large;
    for (final k in CompanionKind.values) {
      if (k.name == json['kind']) kind = k;
    }
    for (final z in CompanionSize.values) {
      if (z.name == json['size']) size = z;
    }
    return CompanionSettings(kind: kind, size: size);
  }

  @override
  bool operator ==(Object other) =>
      other is CompanionSettings && other.kind == kind && other.size == size;

  @override
  int get hashCode => Object.hash(kind, size);
}

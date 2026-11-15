import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// [AppState]-ийг widget мод руу түгээнэ. Төлөв өөрчлөгдөх бүрт
/// `AppScope.of(context)`-оор дамжуулан хамааралтай widget-ууд дахин бүтнэ.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    required AppState state,
    required super.child,
    super.key,
  }) : super(notifier: state);

  /// Төлөв өөрчлөгдөхөд widget-ийг дахин бүтээнэ.
  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope олдсонгүй');
    return scope!.notifier!;
  }

  /// Хамаарал үүсгэхгүй (initState болон үйлдлийн callback-д).
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope олдсонгүй');
    return scope!.notifier!;
  }
}

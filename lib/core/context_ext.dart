import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../state/app_state.dart';
import 'l10n.dart';
import 'palette.dart';

/// `context.app`, `context.s`, `context.pal` - богино нэрээр хандах extension.
extension AppContext on BuildContext {
  /// Аппын төлөв (өөрчлөгдөхөд widget дахин бүтнэ).
  AppState get app => AppScope.of(this);

  /// Идэвхтэй хэлний орчуулагч.
  S get s => S(AppScope.of(this).language);

  /// Идэвхтэй сэдвийн өнгөнүүд.
  AppPalette get pal => Theme.of(this).extension<AppPalette>()!;
}

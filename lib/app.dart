import 'package:flutter/material.dart';

import 'core/core.dart';
import 'pages/auth_page.dart';
import 'pages/main_shell.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';

/// Аппын үндсэн widget: тема, хэл, нэвтрэлтийн төлвөөс хамаарч хуудсаа сонгоно.
class MindfulApp extends StatelessWidget {
  const MindfulApp({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: Builder(
        builder: (context) {
          final app = AppScope.of(context);
          // Системийн сэдвийг дагах үед гэрэл талдаа сонгосон загвараа (эсвэл
          // байгалийн загвар), харанхуй талдаа бараан загварыг ашиглана.
          final lightMode =
              app.themeMode == AppThemeMode.dark ? AppThemeMode.nature : app.themeMode;
          final ThemeMode materialMode = app.followSystem
              ? ThemeMode.system
              : (app.themeMode == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mindful',
            theme: buildTheme(lightMode),
            darkTheme: buildTheme(AppThemeMode.dark),
            themeMode: materialMode,
            builder: (context, child) {
              // Өргөн дэлгэц (веб, таблет) дээр апп-ыг төвд, гар утасны өргөнтэй харуулна.
              return ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: child,
                  ),
                ),
              );
            },
            home: const _RootGate(),
          );
        },
      ),
    );
  }
}

/// Нэвтэрсэн эсэхээс хамаарч хуудсаа сонгоно. Төлөв өөрчлөгдөхөд өөрөө
/// дахин бүтдэг тул `MaterialApp.home`-ийг динамикаар солих шаардлагагүй.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final user = app.user;
    if (user == null) return const AuthPage();
    return MainShell(key: ValueKey(user.id));
  }
}

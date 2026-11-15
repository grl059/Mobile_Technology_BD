# Mindful - мэдрэмж тэмдэглэгч

Өдөр тутмын мэдрэмжээ тэмдэглэж, хуанли болон статистикаар харах Flutter аппликейшн.
Өгөгдөл бүхэлдээ төхөөрөмж дээр (`shared_preferences`) хадгалагдана; сервер шаардлагагүй.

## Ажиллуулах

```bash
flutter pub get
flutter run            # төхөөрөмж / эмулятор / chrome
flutter test           # unit болон widget тест
```

## Боломжууд

- Бүртгүүлэх, нэвтрэх, нууц үг сэргээх/солих (нууц үг давстай SHA-256 хэшээр хадгалагдана), хэрэглэгч бүрийн өгөгдөл тусдаа
- Өдөр бүрийн мэдрэмж (5 төрөл) + тэмдэглэл + шошго; өмнөх өдрүүдийг нөхөж бичих, засах, устгах
- Хуанли: сар сольж үзэх, сарын тойм, тэмдэглэлүүдийн жагсаалт
- Статистик: 7 хоног / сар / жил, дундаж, өмнөх үетэй харьцуулалт, дүгнэлт, зөвлөгөө, дараалал (streak)
- Мэдэгдлийн төв: өдрийн сануулга, дарааллын шагнал, долоо хоногийн дүгнэлт (уншсан болгох, устгах)
- Сануулгын тохиргоо: цаг, давтах өдрүүд
- Сэдэв: гэрэлтэй / бараан / байгалийн + төхөөрөмжийн сэдвийг дагах
- Хэл: Монгол / English / 한국어
- Профайл (нэр, и-мэйл, төрсөн өдөр, аватарын өнгө), тусламж, санал хүсэлт, аппын тухай

> Сануулга нь апп нээлттэй үед **аппын доторх мэдэгдлийн төвд** нэмэгдэнэ. Утасны
> push мэдэгдэл (апп хаалттай үед) шаардлагатай бол `flutter_local_notifications` нэмж
> холбох хэрэгтэй.

## Бүтэц

```
lib/
  main.dart                 нэвтрэх цэг
  app.dart                  MaterialApp, сэдэв/хэл, нэвтрэлтээс хамаарсан эхний хуудас
  core/
    palette.dart            3 сэдвийн өнгө + ThemeData
    l10n.dart               S класс (хэл, огнооны формат)
    l10n_strings.dart       mn/en/ko орчуулгын сан
    dates.dart              огнооны туслахууд
    context_ext.dart        context.app / context.s / context.pal
  models/                   MoodEntry, AppNotification, UserAccount, ReminderSettings
  state/
    app_state.dart          бүх төлөв + хадгалалт (ChangeNotifier)
    app_scope.dart          InheritedNotifier
    stats.dart              статистикийн тооцоо
  widgets/                  дундын widget-үүд (товч, карт, талбар, толгой)
  pages/                    хуудас бүр тусдаа файл
    auth_page.dart          нэвтрэх / бүртгүүлэх
    main_shell.dart         доод навигаци (4 таб)
    home_page.dart          нүүр
    calendar_page.dart      хуанли
    stats_page.dart         статистик
    settings_page.dart      тохиргоо
    notifications_page.dart мэдэгдлийн төв
    mood_entry_sheet.dart   мэдрэмж тэмдэглэх цонх
    profile_page.dart       профайл засах
    reminder_page.dart      сануулгын тохиргоо
    theme_page.dart         сэдэв сонгох
    language_page.dart      хэл сонгох
    help_page.dart          тусламж, санал хүсэлт
    about_page.dart         аппын тухай
    legal_page.dart         үйлчилгээний нөхцөл / нууцлал
test/
  app_state_test.dart       нэвтрэлт, бүртгэл, статистик, мэдэгдэл, орчуулгын тест
  widget_test.dart          бүртгүүлэх -> мэдрэмж тэмдэглэх -> гарах урсгал
```

Орчуулга нэмэх/засахдаа `lib/core/l10n_strings.dart`-д түлхүүр бүрийн `[mn, en, ko]`
гурван утгыг хамт өгнө.

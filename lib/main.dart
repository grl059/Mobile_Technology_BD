import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MindfulApp());
}

const ink = Color(0xFF24332E);
const mint = Color(0xFFCFDFD6);
const forest = Color(0xFF2D463C);
const canvas = Color(0xFFE9EFEB);
const pageColor = Color(0xFFF8FAF7);
const muted = Color(0xFF82928B);

class MindfulApp extends StatelessWidget {
  const MindfulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindful',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8E79),
          surface: pageColor,
        ),
        textTheme: GoogleFonts.manropeTextTheme().apply(
          bodyColor: ink,
          displayColor: ink,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showApp = false;

  @override
  Widget build(BuildContext context) {
    if (showApp) return const MoodShowcase();
    return AuthScreen(onContinue: () => setState(() => showApp = true));
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool acceptedTerms = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  color: pageColor,
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: Colors.white.withOpacity(.85), width: 5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x25314339),
                      blurRadius: 50,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: forest,
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3038574A),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Text(
                            'M',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'serif',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mindful',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Өдөр бүр өөртөө',
                              style: TextStyle(fontSize: 9, color: muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: mint,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: -22,
                            top: -34,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(.28),
                                  width: 24,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 35,
                            bottom: -42,
                            child: Container(
                              width: 92,
                              height: 92,
                              decoration: const BoxDecoration(
                                color: Color(0x88F4DCC1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('☁', style: TextStyle(fontSize: 31)),
                              SizedBox(height: 5),
                              Text(
                                'Мэдрэмж бүр үнэ цэнтэй',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Өөрийгөө анзаарах жижиг алхмаас эхэлье',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF5E7169),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isLogin ? 'Тавтай морил' : 'Бүртгэл үүсгэх',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isLogin
                          ? 'Өөрийн тайван орон зайдаа нэвтэрнэ үү.'
                          : 'Өдөр тутмын мэдрэмжээ анзаарч эхлээрэй.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF1EE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          AuthTab(
                            label: 'Нэвтрэх',
                            active: isLogin,
                            onTap: () => setState(() => isLogin = true),
                          ),
                          AuthTab(
                            label: 'Бүртгүүлэх',
                            active: !isLogin,
                            onTap: () => setState(() => isLogin = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Column(
                        key: ValueKey(isLogin),
                        children: [
                          if (!isLogin) ...[
                            AuthField(
                              controller: nameController,
                              label: 'Таны нэр',
                              hint: 'Нэрээ оруулна уу',
                              icon: Icons.person_outline_rounded,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                          ],
                          AuthField(
                            controller: emailController,
                            label: 'И-мэйл хаяг',
                            hint: 'name@email.com',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          AuthField(
                            controller: passwordController,
                            label: 'Нууц үг',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: obscurePassword,
                            textInputAction: TextInputAction.done,
                            suffix: IconButton(
                              onPressed: () => setState(
                                () => obscurePassword = !obscurePassword,
                              ),
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _showResetMessage(context),
                                child: const Text(
                                  'Нууц үгээ мартсан уу?',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF5F8E79),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: () => setState(
                                () => acceptedTerms = !acceptedTerms,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: acceptedTerms
                                            ? const Color(0xFF5F8E79)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: acceptedTerms
                                              ? const Color(0xFF5F8E79)
                                              : const Color(0xFFC9D1CD),
                                        ),
                                      ),
                                      child: acceptedTerms
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 9),
                                    const Expanded(
                                      child: Text(
                                        'Үйлчилгээний нөхцөл болон нууцлалын бодлогыг зөвшөөрч байна.',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: muted,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    PrimaryButton(
                      icon: isLogin
                          ? Icons.arrow_forward_rounded
                          : Icons.person_add_alt_1_rounded,
                      label: isLogin ? 'Нэвтрэх' : 'Бүртгэл үүсгэх',
                      enabled: isLogin || acceptedTerms,
                      onTap: widget.onContinue,
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE1E7E3)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            isLogin ? 'эсвэл' : 'аль хэдийн бүртгэлтэй юу?',
                            style: const TextStyle(
                              fontSize: 8,
                              color: muted,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE1E7E3)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: const BorderSide(color: Color(0xFFDCE4DF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        isLogin
                            ? Icons.person_add_alt_1_outlined
                            : Icons.login_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isLogin ? 'Шинэ бүртгэл үүсгэх' : 'Нэвтрэх хэсэг рүү',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showResetMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Нууц үг сэргээх холбоос и-мэйлээр илгээгдэнэ.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class AuthTab extends StatelessWidget {
  const AuthTab({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: active ? forest : muted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontSize: 10, color: muted),
        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFA6B0AB)),
        prefixIcon: Icon(icon, size: 19, color: const Color(0xFF6F8E80)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE1E7E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF83AA98), width: 1.4),
        ),
      ),
    );
  }
}

enum DetailPage { notifications, profile, reminder, theme, language, help, about }

class MoodShowcase extends StatefulWidget {
  const MoodShowcase({super.key});

  @override
  State<MoodShowcase> createState() => _MoodShowcaseState();
}

class _MoodShowcaseState extends State<MoodShowcase> {
  int slide = 0;
  DetailPage? detail;

  static const titles = ['Нүүр хуудас', 'Мэдэгдэл', 'Хуанли', 'Статистик', 'Тохиргоо'];

  void goToSlide(int value) {
    setState(() {
      slide = value.clamp(0, 4).toInt();
      detail = null;
    });
  }

  void openDetail(DetailPage value) {
    setState(() => detail = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow('SCREEN ${('${slide + 1}').padLeft(2, '0')} / 05'),
                          Text(
                            titles[slide],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RoundButton(
                            icon: Icons.chevron_left_rounded,
                            enabled: slide > 0,
                            onTap: () => goToSlide(slide - 1),
                          ),
                          const SizedBox(width: 8),
                          RoundButton(
                            icon: Icons.chevron_right_rounded,
                            enabled: slide < 4,
                            onTap: () => goToSlide(slide + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: pageColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(.8), width: 5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x25314339),
                            blurRadius: 45,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(27),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          child: KeyedSubtree(
                            key: ValueKey('$slide-$detail'),
                            child: _buildScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () => goToSlide(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: slide == index ? 28 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: slide == index ? const Color(0xFF2E5143) : const Color(0xFFC9D2CD),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    if (slide == 4 && detail != null) {
      return DetailScreen(type: detail!, onBack: () => setState(() => detail = null));
    }

    switch (slide) {
      case 0:
        return MainScreenFrame(
          currentTab: 0,
          onTab: _goToTab,
          child: HomeScreen(
            onNotifications: () => goToSlide(1),
            onAddMood: () => showMoodSheet(context),
          ),
        );
      case 1:
        return DetailScreen(type: DetailPage.notifications, onBack: () => goToSlide(0));
      case 2:
        return MainScreenFrame(
          currentTab: 1,
          onTab: _goToTab,
          child: CalendarScreen(onNotifications: () => goToSlide(1)),
        );
      case 3:
        return MainScreenFrame(
          currentTab: 2,
          onTab: _goToTab,
          child: StatsScreen(onNotifications: () => goToSlide(1)),
        );
      default:
        return MainScreenFrame(
          currentTab: 3,
          onTab: _goToTab,
          child: SettingsScreen(onOpen: openDetail),
        );
    }
  }

  void _goToTab(int index) {
    const slidesByTab = [0, 2, 3, 4];
    goToSlide(slidesByTab[index]);
  }
}

class MainScreenFrame extends StatelessWidget {
  const MainScreenFrame({
    required this.currentTab,
    required this.onTab,
    required this.child,
    super.key,
  });

  final int currentTab;
  final ValueChanged<int> onTab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: currentTab,
        onDestinationSelected: onTab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCEBE3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Нүүр'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Хуанли'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Статистик'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Тохиргоо'),
        ],
      ),
    );
  }
}

class ScreenPage extends StatelessWidget {
  const ScreenPage({required this.children, this.paddingBottom = 28, super.key});

  final List<Widget> children;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 24, 20, paddingBottom),
      children: children,
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.eyebrow,
    required this.title,
    required this.onNotifications,
    super.key,
  });

  final String eyebrow;
  final String title;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.7)),
            ],
          ),
          Stack(
            children: [
              RoundButton(icon: Icons.notifications_none_rounded, onTap: onNotifications),
              Positioned(
                right: 7,
                top: 6,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF7669),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onNotifications,
    required this.onAddMood,
    super.key,
  });

  final VoidCallback onNotifications;
  final VoidCallback onAddMood;

  @override
  Widget build(BuildContext context) {
    const week = [
      ['Дав', '16', '😊'],
      ['Мяг', '17', '😌'],
      ['Лха', '18', '😄'],
      ['Пүр', '19', '😔'],
      ['Баа', '20', '😊'],
      ['Бям', '21', '😄'],
      ['Ням', '22', '+'],
    ];
    return ScreenPage(
      children: [
        PageHeader(eyebrow: 'МЯГМАР • 10 САРЫН 22', title: 'Сайн уу, Номин', onNotifications: onNotifications),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(28)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('ӨДРИЙН МЭДРЭМЖ', color: Color(0xFF587568)),
              const SizedBox(height: 8),
              const Text(
                'Өнөөдөр хэр байна даа?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1),
              ),
              const SizedBox(height: 10),
              const Text(
                'Өөртөө хэдхэн хором зарцуулж, мэдрэмжээ тэмдэглээрэй.',
                style: TextStyle(color: Color(0xFF5E7169), fontSize: 13, height: 1.55),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onAddMood,
                style: FilledButton.styleFrom(
                  backgroundColor: forest,
                  minimumSize: const Size(0, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Мэдрэмжээ нэмэх', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 27),
        const SectionHeading(eyebrow: 'ЭНЭ ДОЛОО ХОНОГ', title: 'Таны мэдрэмж', action: 'Бүгдийг харах'),
        Row(
          children: List.generate(
            week.length,
            (index) => Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: index == 6 ? const Color(0xFFEEF2EF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(week[index][0], style: const TextStyle(fontSize: 9, color: Color(0xFF95A19C), fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(week[index][1], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: index == 6 ? forest : Colors.transparent,
                      child: Text(week[index][2], style: TextStyle(fontSize: 19, color: index == 6 ? Colors.white : null)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        SoftCard(
          color: const Color(0xFFF3E9DE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('“', style: TextStyle(fontSize: 36, color: Color(0xFFBD8F69), height: .9, fontFamily: 'serif')),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Мэдрэмж бүр үнэ цэнтэй. Түүнийг анзаарах нь өөрийгөө ойлгох эхлэл юм.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF615B54), height: 1.55),
                    ),
                    const SizedBox(height: 6),
                    Text('ӨНӨӨДРИЙН САНУУЛГА', style: TextStyle(fontSize: 8, color: Colors.brown.shade400, fontWeight: FontWeight.w800, letterSpacing: .5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({required this.onNotifications, super.key});

  final VoidCallback onNotifications;

  static const moodDays = {
    1: '😊', 3: '😄', 4: '😌', 7: '😔', 8: '😊', 10: '😄', 11: '😌',
    12: '😊', 14: '😠', 15: '😔', 16: '😊', 17: '😌', 18: '😄', 19: '😔',
    20: '😊', 21: '😄',
  };

  @override
  Widget build(BuildContext context) {
    final days = List<int?>.generate(35, (index) => index < 2 || index > 32 ? null : index - 1);
    return ScreenPage(
      children: [
        PageHeader(eyebrow: 'ТҮҮХ', title: 'Миний хуанли', onNotifications: onNotifications),
        SoftCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MiniButton(icon: Icons.chevron_left_rounded),
                  const Text('2024 оны 10 сар', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const MiniButton(icon: Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня']
                    .map((day) => Expanded(child: Center(child: Text(day, style: const TextStyle(fontSize: 9, color: muted, fontWeight: FontWeight.w800)))))
                    .toList(),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: .78,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: day == 22 ? const Color(0xFFE1EEE7) : Colors.transparent,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: day == null
                        ? null
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$day', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                              if (moodDays[day] != null) Text(moodDays[day]!, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionHeading(title: 'Сарын тойм', action: '21 өдөр'),
        ...[
          ('😊', 'Баяртай', '8 өдөр', .82, const Color(0xFF79C9A5)),
          ('😄', 'Жаргалтай', '6 өдөр', .62, const Color(0xFFF5B83D)),
          ('😌', 'Тайван', '4 өдөр', .44, const Color(0xFF78A8DE)),
          ('😔', 'Гунигтай', '3 өдөр', .30, const Color(0xFF8E8AC8)),
        ].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                SizedBox(width: 38, child: Text(item.$1, style: const TextStyle(fontSize: 24))),
                SizedBox(
                  width: 78,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      Text(item.$3, style: const TextStyle(fontSize: 9, color: muted)),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: LinearProgressIndicator(
                      value: item.$4,
                      minHeight: 6,
                      color: item.$5,
                      backgroundColor: const Color(0xFFECF0ED),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({required this.onNotifications, super.key});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    const values = [.45, .65, .54, .78, .60, .86, .72];
    const labels = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];
    return ScreenPage(
      children: [
        PageHeader(eyebrow: 'ТАНЫ ХАНДЛАГА', title: 'Статистик', onNotifications: onNotifications),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: const Color(0xFFEDF1EE), borderRadius: BorderRadius.circular(13)),
          child: Row(
            children: ['7 хоног', 'Сар', 'Жил']
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: entry.key == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(entry.value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 17),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow('ДУНДАЖ ҮНЭЛГЭЭ'),
                      Text('Сайн 😊', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                    decoration: BoxDecoration(color: const Color(0xFFE8F4EC), borderRadius: BorderRadius.circular(20)),
                    child: const Text('↗ 12%', style: TextStyle(fontSize: 10, color: Color(0xFF4D8D68), fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 155,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    values.length,
                    (index) => Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: FractionallySizedBox(
                              heightFactor: values[index],
                              child: Container(
                                width: 20,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFF7DB59C), Color(0xFFD9E9E0)],
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(labels[index], style: const TextStyle(fontSize: 9, color: muted)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        SoftCard(
          color: const Color(0xFF303F53),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white.withOpacity(.1), borderRadius: BorderRadius.circular(12)),
                child: const Text('✦', style: TextStyle(color: Color(0xFFE9C986), fontSize: 20)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow('7 ХОНОГИЙН ДҮГНЭЛТ', color: Color(0xFFAAB5C1)),
                    Text('Тайван, тогтвортой долоо хоног', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                    SizedBox(height: 7),
                    Text(
                      'Таны эерэг мэдрэмж өмнөх долоо хоногоос өссөн байна. Амралтын өдрүүдэд гадаа алхсан нь танд сайнаар нөлөөлжээ.',
                      style: TextStyle(fontSize: 10, height: 1.55, color: Color(0xFFBDC6CE)),
                    ),
                    SizedBox(height: 10),
                    Text('Зөвлөгөө харах  ›', style: TextStyle(fontSize: 10, color: Color(0xFFE7D4A7), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: StatTile(emoji: '😊', label: 'Хамгийн их', value: 'Баяртай')),
            const SizedBox(width: 10),
            Expanded(child: StatTile(emoji: '🔥', label: 'Дараалсан', value: '12 өдөр')),
          ],
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.onOpen, super.key});

  final ValueChanged<DetailPage> onOpen;

  @override
  Widget build(BuildContext context) {
    return ScreenPage(
      children: [
        PageHeader(
          eyebrow: 'ТОХИРГОО',
          title: 'Таны орон зай',
          onNotifications: () => onOpen(DetailPage.notifications),
        ),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(color: const Color(0xFFD9E8DF), borderRadius: BorderRadius.circular(22)),
          child: Row(
            children: [
              const Avatar(size: 52),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Номин Эрдэнэ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    Text('nominaa@email.com', style: TextStyle(fontSize: 10, color: Color(0xFF708178))),
                  ],
                ),
              ),
              RoundButton(icon: Icons.edit_outlined, onTap: () => onOpen(DetailPage.profile), size: 38),
            ],
          ),
        ),
        const GroupLabel('ЕРӨНХИЙ'),
        SettingsCard(
          children: [
            SettingTile(
              icon: Icons.notifications_none_rounded,
              iconColor: const Color(0xFFB87955),
              iconBackground: const Color(0xFFFAE7DB),
              title: 'Мэдэгдэл',
              subtitle: 'Орой бүр 21:00',
              trailing: const SwitchPill(value: true),
              onTap: () => onOpen(DetailPage.reminder),
            ),
            SettingTile(
              icon: Icons.contrast_rounded,
              iconColor: const Color(0xFF77649A),
              iconBackground: const Color(0xFFEAE4F3),
              title: 'Сэдэв сонгох',
              subtitle: 'Байгалийн загвар',
              onTap: () => onOpen(DetailPage.theme),
            ),
            SettingTile(
              icon: Icons.translate_rounded,
              iconColor: const Color(0xFF4D806C),
              iconBackground: const Color(0xFFDFEFE8),
              title: 'Хэл',
              subtitle: 'Монгол',
              onTap: () => onOpen(DetailPage.language),
            ),
          ],
        ),
        const GroupLabel('ТУСЛАМЖ'),
        SettingsCard(
          children: [
            SettingTile(
              icon: Icons.question_mark_rounded,
              iconColor: const Color(0xFF587C98),
              iconBackground: const Color(0xFFE1EBF3),
              title: 'Тусламж ба санал хүсэлт',
              onTap: () => onOpen(DetailPage.help),
            ),
            SettingTile(
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFF967B4F),
              iconBackground: const Color(0xFFF2EAD9),
              title: 'Аппын тухай',
              subtitle: 'Хувилбар 1.0.0',
              onTap: () => onOpen(DetailPage.about),
            ),
          ],
        ),
      ],
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.type, required this.onBack, super.key});

  final DetailPage type;
  final VoidCallback onBack;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool enabled = true;
  bool sent = false;
  String themeChoice = 'nature';
  String language = 'mn';
  int hour = 21;
  final repeatDays = <int>{0, 1, 2, 3, 4};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: ScreenPage(children: [DetailHeader(title: _title, eyebrow: _eyebrow, onBack: widget.onBack), ..._content]),
    );
  }

  String get _title => switch (widget.type) {
        DetailPage.notifications => 'Мэдэгдэл',
        DetailPage.profile => 'Профайл засах',
        DetailPage.reminder => 'Мэдэгдэл',
        DetailPage.theme => 'Сэдэв сонгох',
        DetailPage.language => 'Хэл сонгох',
        DetailPage.help => 'Тусламж',
        DetailPage.about => 'Mindful',
      };

  String get _eyebrow => switch (widget.type) {
        DetailPage.notifications => 'МЭДЭГДЛИЙН ТӨВ',
        DetailPage.profile => 'ХУВИЙН МЭДЭЭЛЭЛ',
        DetailPage.reminder => 'ӨДӨР ТУТМЫН САНУУЛГА',
        DetailPage.theme => 'ХАРАГДАХ БАЙДАЛ',
        DetailPage.language => 'АППЫН ХЭЛ',
        DetailPage.help => 'БИД ТУСЛАХАД БЭЛЭН',
        DetailPage.about => 'БИДНИЙ ТУХАЙ',
      };

  List<Widget> get _content {
    switch (widget.type) {
      case DetailPage.notifications:
        return _notifications();
      case DetailPage.profile:
        return _profile();
      case DetailPage.reminder:
        return _reminder();
      case DetailPage.theme:
        return _theme();
      case DetailPage.language:
        return _language();
      case DetailPage.help:
        return _help();
      case DetailPage.about:
        return _about();
    }
  }

  List<Widget> _notifications() => [
        SoftCard(
          color: const Color(0xFFDCEBE3),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: const Color(0xFF527564), borderRadius: BorderRadius.circular(14)),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Шинэ мэдэгдэл', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    Text('Таны долоо хоногийн тойм бэлэн боллоо', style: TextStyle(fontSize: 9, color: Color(0xFF71847B))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const GroupLabel('ӨНӨӨДӨР'),
        NoticeCard(
          icon: '✦',
          title: '7 хоногийн дүгнэлт бэлэн',
          copy: 'Таны эерэг мэдрэмж 12%-иар өсжээ. Дэлгэрэнгүй тоймоо үзээрэй.',
          time: '12 минутын өмнө',
          unread: true,
        ),
        const SizedBox(height: 9),
        NoticeCard(
          icon: '☺',
          title: 'Өдрийн мэдрэмжээ тэмдэглээрэй',
          copy: 'Өөртөө хэдхэн хором зарцуулж, өнөөдрийн мэдрэмжээ хадгалаарай.',
          time: '1 цагийн өмнө',
          unread: true,
        ),
        const SizedBox(height: 9),
        NoticeCard(
          icon: '☾',
          title: '7 өдрийн дараалал',
          copy: 'Та бүтэн долоо хоног өөртөө анхаарал хандууллаа.',
          time: 'Өчигдөр',
        ),
        const SizedBox(height: 16),
        OutlinedButton(onPressed: () {}, child: const Text('Бүгдийг уншсан болгох')),
      ];

  List<Widget> _profile() => [
        const Center(child: Avatar(size: 88)),
        const SizedBox(height: 10),
        const Center(child: Text('Зургаа өөрчлөх', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
        const Center(child: Text('JPG эсвэл PNG, 5MB хүртэл', style: TextStyle(fontSize: 8, color: muted))),
        const SizedBox(height: 22),
        SoftCard(
          child: const Column(
            children: [
              ProfileField(label: 'Таны нэр', value: 'Номин Эрдэнэ'),
              Divider(height: 1),
              ProfileField(label: 'И-мэйл хаяг', value: 'nominaa@email.com'),
              Divider(height: 1),
              ProfileField(label: 'Төрсөн өдөр', value: '1998.06.14'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        PrimaryButton(icon: Icons.send_outlined, label: 'Өөрчлөлт хадгалах', onTap: null),
      ];

  List<Widget> _reminder() => [
        SoftCard(
          color: const Color(0xFFF3E6D9),
          child: const Row(
            children: [
              Text('🔔', style: TextStyle(fontSize: 34)),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Өөртөө цаг гаргаарай', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    Text('Таны сонгосон цагт мэдрэмжээ тэмдэглэхийг зөөлөн сануулна.', style: TextStyle(fontSize: 9, height: 1.5, color: Color(0xFF8D7766))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SettingsCard(
          children: [
            SettingTile(
              title: 'Өдрийн сануулга',
              subtitle: 'Өдөр бүр давтагдана',
              trailing: SwitchPill(value: enabled),
              onTap: () => setState(() => enabled = !enabled),
            ),
          ],
        ),
        const GroupLabel('САНУУЛАХ ЦАГ'),
        SoftCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MiniButton(icon: Icons.remove_rounded, onTap: () => setState(() => hour = (hour + 23) % 24)),
              Column(
                children: [
                  Text('${hour.toString().padLeft(2, '0')}:00', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
                  Text(hour < 12 ? 'Өглөө' : 'Орой', style: const TextStyle(fontSize: 9, color: muted)),
                ],
              ),
              MiniButton(icon: Icons.add_rounded, onTap: () => setState(() => hour = (hour + 1) % 24)),
            ],
          ),
        ),
        const GroupLabel('ДАВТАХ ӨДӨР'),
        Row(
          children: List.generate(
            7,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => repeatDays.contains(index) ? repeatDays.remove(index) : repeatDays.add(index)),
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(right: index == 6 ? 0 : 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: repeatDays.contains(index) ? const Color(0xFF4F7967) : const Color(0xFFEDF1EF),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    ['Д', 'М', 'Л', 'П', 'Б', 'Б', 'Н'][index],
                    style: TextStyle(fontSize: 10, color: repeatDays.contains(index) ? Colors.white : muted, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(label: 'Тохиргоо хадгалах', onTap: null),
      ];

  List<Widget> _theme() => [
        const Text('Танд хамгийн тайван, тухтай санагдах орчноо сонгоорой.', style: TextStyle(fontSize: 11, color: muted, height: 1.6)),
        const SizedBox(height: 20),
        Row(
          children: [
            ThemeChoice(id: 'light', title: 'Гэрэлтэй', subtitle: 'Цэвэр, минимал', symbol: '☀', selected: themeChoice == 'light', onTap: () => setState(() => themeChoice = 'light')),
            const SizedBox(width: 8),
            ThemeChoice(id: 'dark', title: 'Бараан', subtitle: 'Нүдэнд зөөлөн', symbol: '☾', selected: themeChoice == 'dark', onTap: () => setState(() => themeChoice = 'dark')),
            const SizedBox(width: 8),
            ThemeChoice(id: 'nature', title: 'Байгалийн', subtitle: 'Тайван, дулаан', symbol: '❧', selected: themeChoice == 'nature', onTap: () => setState(() => themeChoice = 'nature')),
          ],
        ),
        const GroupLabel('ӨНГӨНИЙ ТОХИРГОО'),
        const SettingsCard(
          children: [
            SettingTile(
              title: 'Системийн тохиргоо дагах',
              subtitle: 'Төхөөрөмжийн theme-ээр солигдоно',
              trailing: SwitchPill(value: false),
            ),
          ],
        ),
      ];

  List<Widget> _language() => [
        Center(
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: const Color(0xFFE0EEE7), borderRadius: BorderRadius.circular(20)),
            child: const Text('文', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF4A7562))),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Аппын цэс, мэдэгдэл болон зөвлөгөөний хэлийг сонгоно уу.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: muted, height: 1.55)),
        const SizedBox(height: 22),
        SettingsCard(
          children: [
            ChoiceTile(title: 'Монгол', subtitle: 'Монгол хэл', selected: language == 'mn', onTap: () => setState(() => language = 'mn')),
            ChoiceTile(title: 'English', subtitle: 'English', selected: language == 'en', onTap: () => setState(() => language = 'en')),
            ChoiceTile(title: '한국어', subtitle: 'Korean', selected: language == 'ko', onTap: () => setState(() => language = 'ko')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Хэл солиход таны хадгалсан тэмдэглэлд өөрчлөлт орохгүй.', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: muted)),
      ];

  List<Widget> _help() => [
        SoftCard(
          color: const Color(0xFFDCEBE3),
          child: const Column(
            children: [
              CircleAvatar(backgroundColor: Color(0xFF527564), child: Text('?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
              SizedBox(height: 10),
              Text('Танд юугаар туслах вэ?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text('Түгээмэл асуултыг харах эсвэл бидэнд шууд бичээрэй.', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Color(0xFF71837A))),
            ],
          ),
        ),
        const GroupLabel('ТҮГЭЭМЭЛ АСУУЛТ'),
        const SettingsCard(
          children: [
            SettingTile(title: 'Мэдрэмжээ хэрхэн засах вэ?'),
            SettingTile(title: 'Миний мэдээлэл аюулгүй юу?'),
            SettingTile(title: 'Мэдэгдлийн цагийг яаж солих вэ?'),
          ],
        ),
        const GroupLabel('САНАЛ ХҮСЭЛТ'),
        TextField(
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Санал хүсэлтээ энд бичээрэй...',
            hintStyle: const TextStyle(fontSize: 11),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          icon: sent ? Icons.check_rounded : Icons.send_outlined,
          label: sent ? 'Илгээгдлээ' : 'Санал хүсэлт илгээх',
          onTap: () => setState(() => sent = true),
        ),
      ];

  List<Widget> _about() => [
        Center(
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF38574A),
              borderRadius: BorderRadius.circular(23),
              boxShadow: const [BoxShadow(color: Color(0x3038574A), blurRadius: 25, offset: Offset(0, 10))],
            ),
            child: const Text('M', style: TextStyle(fontSize: 34, color: Colors.white, fontFamily: 'serif')),
          ),
        ),
        const SizedBox(height: 9),
        const Text('Mindful', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const Text('Өдөр бүр өөртөө', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: muted)),
        const SizedBox(height: 10),
        const Center(child: Chip(label: Text('Хувилбар 1.0.0', style: TextStyle(fontSize: 8)))),
        const SizedBox(height: 20),
        SoftCard(
          color: const Color(0xFFF2E9DE),
          child: const Column(
            children: [
              Text('Мэдрэмж бүр үнэ цэнтэй', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              SizedBox(height: 7),
              Text(
                'Mindful нь өдөр тутмын мэдрэмжээ анзаарч, ойлгож, өөртөө илүү энэрэнгүй хандахад тань туслах хувийн орон зай юм.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, height: 1.7, color: Color(0xFF7D746A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SettingsCard(
          children: [
            SettingTile(title: 'Үйлчилгээний нөхцөл'),
            SettingTile(title: 'Нууцлалын бодлого'),
            SettingTile(title: 'Нээлттэй эхийн лиценз'),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Улаанбаатарт халуун сэтгэлээр бүтээв', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: muted)),
      ];
}

Future<void> showMoodSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const MoodEntrySheet(),
  );
}

class MoodEntrySheet extends StatefulWidget {
  const MoodEntrySheet({super.key});

  @override
  State<MoodEntrySheet> createState() => _MoodEntrySheetState();
}

class _MoodEntrySheetState extends State<MoodEntrySheet> {
  int selected = 1;
  bool saved = false;

  static const moods = [
    ('😄', 'Жаргалтай'),
    ('😊', 'Баяртай'),
    ('😌', 'Тайван'),
    ('😔', 'Гунигтай'),
    ('😠', 'Ууртай'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
        decoration: const BoxDecoration(
          color: Color(0xFFFBFCFA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 42, height: 4, decoration: BoxDecoration(color: const Color(0xFFD7DDDA), borderRadius: BorderRadius.circular(4))),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Eyebrow('10 САРЫН 22 • ӨНӨӨДӨР'),
                        Text('Мэдрэмжээ тэмдэглэх', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    RoundButton(icon: Icons.close_rounded, onTap: () => Navigator.pop(context), size: 38),
                  ],
                ),
                const SizedBox(height: 22),
                const Text('Та яг одоо ямар мэдрэмжтэй байна?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    moods.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selected = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(right: index == 4 ? 0 : 5),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: selected == index ? const Color(0xFFE0EEE6) : const Color(0xFFF0F3F1),
                            border: Border.all(color: selected == index ? const Color(0xFF9EBDAB) : Colors.transparent),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(moods[index].$1, style: const TextStyle(fontSize: 25)),
                              Text(moods[index].$2, style: const TextStyle(fontSize: 8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Өнөөдрийн тэмдэглэл', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    Text('заавал биш', style: TextStyle(fontSize: 9, color: muted)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: 'Өнөөдөр ажлаа эрт дуусгаад, цэцэрлэгт хүрээлэнгээр алхлаа. Тайван сайхан өдөр байв.',
                  minLines: 3,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 11, height: 1.5),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  children: ['+ Гэр бүл', '+ Ажил', '+ Эрүүл мэнд']
                      .map((label) => ActionChip(label: Text(label, style: const TextStyle(fontSize: 9)), onPressed: () {}))
                      .toList(),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  icon: saved ? Icons.check_rounded : Icons.send_outlined,
                  label: saved ? 'Хадгалагдлаа' : 'Тэмдэглэл хадгалах',
                  onTap: () {
                    setState(() => saved = true);
                    Future<void>.delayed(const Duration(milliseconds: 700), () {
                      if (mounted) Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  const DetailHeader({required this.title, required this.eyebrow, required this.onBack, super.key});

  final String title;
  final String eyebrow;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          RoundButton(icon: Icons.chevron_left_rounded, onTap: onBack),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {this.color = muted, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.title, this.eyebrow, this.action, super.key});

  final String title;
  final String? eyebrow;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) Eyebrow(eyebrow!),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          ),
          if (action != null)
            Text(action!, style: const TextStyle(fontSize: 10, color: Color(0xFF6F8E80), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({required this.child, this.color = Colors.white, this.padding = const EdgeInsets.all(18), super.key});

  final Widget child;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: color == Colors.white
            ? const [BoxShadow(color: Color(0x0F394B44), blurRadius: 26, offset: Offset(0, 8))]
            : null,
      ),
      child: child,
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({required this.icon, this.onTap, this.enabled = true, this.size = 43, super.key});

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .3,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2.7),
        elevation: 2,
        shadowColor: const Color(0x152A3E36),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(size / 2.7),
          child: SizedBox(width: size, height: size, child: Icon(icon, size: size * .52)),
        ),
      ),
    );
  }
}

class MiniButton extends StatelessWidget {
  const MiniButton({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap ?? () {},
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(backgroundColor: const Color(0xFFF1F5F2)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.enabled = true,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: enabled ? (onTap ?? () {}) : null,
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 23, 3, 9),
      child: Text(text, style: const TextStyle(fontSize: 9, color: muted, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21)),
      child: Column(
        children: List.generate(
          children.length * 2 - 1,
          (index) => index.isEven ? children[index ~/ 2] : const Divider(height: 1, color: Color(0xFFEEF1EF)),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackground,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackground;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(11)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 11),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 9, color: muted)),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, size: 18, color: muted),
          ],
        ),
      ),
    );
  }
}

class SwitchPill extends StatelessWidget {
  const SwitchPill({required this.value, super.key});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 40,
      height: 23,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF5F8E79) : const Color(0xFFD9DFDC),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: const CircleAvatar(radius: 8.5, backgroundColor: Colors.white),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({required this.size, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF587B6B),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(.8), width: 3),
      ),
      child: Text('Н', style: TextStyle(fontSize: size * .34, color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({required this.emoji, required this.label, required this.value, super.key});
  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 8, color: muted)),
              Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    required this.icon,
    required this.title,
    required this.copy,
    required this.time,
    this.unread = false,
    super.key,
  });

  final String icon;
  final String title;
  final String copy;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: unread ? const Color(0xFFF0F6F2) : Colors.white,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: const Color(0xFFDFEFE8), borderRadius: BorderRadius.circular(12)),
            child: Text(icon, style: const TextStyle(color: Color(0xFF4D806C), fontSize: 18)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(copy, style: const TextStyle(fontSize: 9, height: 1.5, color: Color(0xFF7C8882))),
                const SizedBox(height: 3),
                Text(time, style: const TextStyle(fontSize: 8, color: muted)),
              ],
            ),
          ),
          if (unread) const CircleAvatar(radius: 3, backgroundColor: Color(0xFF5E957C)),
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  const ProfileField({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w700),
        border: InputBorder.none,
      ),
    );
  }
}

class ThemeChoice extends StatelessWidget {
  const ThemeChoice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String id;
  final String title;
  final String subtitle;
  final String symbol;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewColor = switch (id) {
      'dark' => const Color(0xFF28313C),
      'nature' => const Color(0xFFDCE9DF),
      _ => const Color(0xFFF5F4EE),
    };
    final foreground = id == 'dark' ? Colors.white : const Color(0xFF466C5A);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: selected ? const Color(0xFF709987) : const Color(0xFFE5E9E7), width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 86,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: previewColor, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(symbol, style: TextStyle(fontSize: 18, color: foreground)),
                    const SizedBox(height: 7),
                    for (final width in [1.0, .72, .46])
                      FractionallySizedBox(
                        widthFactor: width,
                        child: Container(
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(color: foreground.withOpacity(.18), borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
                  if (selected) const Icon(Icons.check_rounded, size: 14, color: Color(0xFF56826E)),
                ],
              ),
              Text(subtitle, style: const TextStyle(fontSize: 7, color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? const Color(0xFF56806D) : const Color(0xFFC9D1CD), width: 1.5),
              ),
              child: selected ? const CircleAvatar(backgroundColor: Color(0xFF56806D)) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                Text(subtitle, style: const TextStyle(fontSize: 8, color: muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

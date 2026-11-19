import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';

/// Нэвтрэх / бүртгүүлэх хуудас.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLogin = true;
  bool _obscure = true;
  bool _accepted = false;
  String? _errorKey;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _setMode(bool login) {
    setState(() {
      _isLogin = login;
      _errorKey = null;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final app = AppScope.read(context);
    final String? error = _isLogin
        ? app.login(_email.text, _password.text)
        : app.register(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
    // Амжилттай бол AppState өөрчлөгдөж, MaterialApp үндсэн хуудас руу шилжүүлнэ.
    if (error != null) setState(() => _errorKey = error);
  }

  Future<void> _forgotPassword() async {
    final done = await showDialog<bool>(
      context: context,
      builder: (_) => _ResetPasswordDialog(initialEmail: _email.text),
    );
    if (done == true && mounted) {
      showSnack(context, context.s('auth.resetDone'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    final app = context.app;

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: BoxDecoration(
                  color: p.page,
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: p.card.withAlpha(217), width: 5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x25314339),
                      blurRadius: 50,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LanguageSwitch(
                        current: app.language,
                        onChanged: app.setLanguage,
                      ),
                      const SizedBox(height: 8),
                      _Brand(tagline: s('app.tagline')),
                      const SizedBox(height: 22),
                      _HeroBanner(
                        title: s('auth.heroTitle'),
                        subtitle: s('auth.heroSubtitle'),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        _isLogin ? s('auth.welcome') : s('auth.createAccount'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.6,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _isLogin ? s('auth.loginHint') : s('auth.registerHint'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: p.muted, height: 1.5),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: p.soft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _AuthTab(
                              key: const Key('tab_login'),
                              label: s('auth.login'),
                              active: _isLogin,
                              onTap: () => _setMode(true),
                            ),
                            _AuthTab(
                              key: const Key('tab_register'),
                              label: s('auth.register'),
                              active: !_isLogin,
                              onTap: () => _setMode(false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            if (!_isLogin) ...[
                              AuthField(
                                key: const Key('auth_name'),
                                controller: _name,
                                label: s('auth.name'),
                                hint: s('auth.nameHint'),
                                icon: AppIcons.user,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? s('err.nameRequired')
                                    : null,
                              ),
                              const SizedBox(height: 12),
                            ],
                            AuthField(
                              key: const Key('auth_email'),
                              controller: _email,
                              label: s('auth.email'),
                              hint: 'name@email.com',
                              icon: AppIcons.mail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (v) =>
                                  (v == null || !AppState.isValidEmail(v))
                                      ? s('err.emailInvalid')
                                      : null,
                            ),
                            const SizedBox(height: 12),
                            AuthField(
                              key: const Key('auth_password'),
                              controller: _password,
                              label: s('auth.password'),
                              hint: '••••••••',
                              icon: AppIcons.lock,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty) return s('err.passwordRequired');
                                if (!_isLogin &&
                                    value.length < AppState.minPasswordLength) {
                                  return s('err.passwordShort');
                                }
                                return null;
                              },
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? AppIcons.eyeSlash
                                      : AppIcons.eye,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_isLogin)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _forgotPassword,
                                  child: Text(
                                    s('auth.forgot'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: p.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            else
                              _TermsRow(
                                accepted: _accepted,
                                text: s('auth.terms'),
                                onTap: () => setState(() => _accepted = !_accepted),
                              ),
                          ],
                        ),
                      ),
                      if (_errorKey != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x1AD9534F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                AppIcons.warning,
                                size: 18,
                                color: Color(0xFFD9534F),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s(_errorKey!),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFD9534F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      PrimaryButton(
                        key: const Key('auth_submit'),
                        icon: _isLogin
                            ? AppIcons.arrowRight
                            : AppIcons.userPlus,
                        label: _isLogin ? s('auth.login') : s('auth.createBtn'),
                        onTap: (_isLogin || _accepted) ? _submit : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Divider(color: p.line)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              _isLogin ? s('auth.or') : s('auth.haveAccount'),
                              style: TextStyle(fontSize: 11, color: p.muted),
                            ),
                          ),
                          Expanded(child: Divider(color: p.line)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _setMode(!_isLogin),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: p.ink,
                          side: BorderSide(color: p.line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: Icon(
                          _isLogin
                              ? AppIcons.userPlus
                              : AppIcons.signIn,
                          size: 18,
                        ),
                        label: Text(
                          _isLogin ? s('auth.newAccount') : s('auth.toLogin'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({required this.current, required this.onChanged});

  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    const options = [('mn', 'МН'), ('en', 'EN')];
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: GestureDetector(
              onTap: () => onChanged(option.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: current == option.$1 ? p.forest : p.soft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option.$2,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: current == option.$1 ? p.onForest : p.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.tagline});

  final String tagline;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: p.forest,
            borderRadius: BorderRadius.circular(17),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3038574A),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(AppIcons.lotus, size: 28, color: p.onForest),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mindful',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            Text(tagline, style: TextStyle(fontSize: 11, color: p.muted)),
          ],
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      height: 136,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: p.mint,
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
                border: Border.all(color: Colors.white.withAlpha(71), width: 24),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: p.mintInk),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({
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
    final p = context.pal;
    return Expanded(
      child: Material(
        color: active ? p.card : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: active ? p.ink : p.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({
    required this.accepted,
    required this.text,
    required this.onTap,
  });

  final bool accepted;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: accepted ? p.accent : p.card,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: accepted ? p.accent : p.muted.withAlpha(120)),
              ),
              child: accepted
                  ? const Icon(AppIcons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: p.muted, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Нууц үг сэргээх цонх. Сервер байхгүй тул төхөөрөмж дээрх бүртгэлийг шууд шинэчилнэ.
class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  final _password = TextEditingController();
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final error = AppScope.read(context).resetPassword(_email.text, _password.text);
    if (error != null) {
      setState(() => _errorKey = error);
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = context.s;
    return AlertDialog(
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        s('auth.resetTitle'),
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s('auth.resetHint'),
                style: TextStyle(fontSize: 12, color: p.muted, height: 1.5),
              ),
              const SizedBox(height: 14),
              AuthField(
                controller: _email,
                label: s('auth.email'),
                hint: 'name@email.com',
                icon: AppIcons.mail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || !AppState.isValidEmail(v))
                    ? s('err.emailInvalid')
                    : null,
              ),
              const SizedBox(height: 12),
              AuthField(
                controller: _password,
                label: s('auth.newPassword'),
                hint: '••••••••',
                icon: AppIcons.lock,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
                validator: (v) => (v == null || v.length < AppState.minPasswordLength)
                    ? s('err.passwordShort')
                    : null,
              ),
              if (_errorKey != null) ...[
                const SizedBox(height: 10),
                Text(
                  s(_errorKey!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD9534F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s('common.cancel'), style: TextStyle(color: p.muted)),
        ),
        TextButton(
          onPressed: _save,
          child: Text(
            s('common.save'),
            style: TextStyle(color: p.accent, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

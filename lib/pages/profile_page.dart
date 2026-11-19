import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';

/// Профайл засах: нэр, и-мэйл, төрсөн өдөр, аватарын өнгө, нууц үг солих.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _birthdayText;
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();

  DateTime? _birthday;
  int _avatar = 0;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    final user = AppScope.read(context).user;
    _name = TextEditingController(text: user?.name ?? '');
    _name.addListener(() {
      if (mounted) setState(() {});
    });
    _email = TextEditingController(text: user?.email ?? '');
    _birthday = user?.birthday;
    _avatar = user?.avatar ?? 0;
    _birthdayText = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncBirthdayText();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _birthdayText.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  void _syncBirthdayText() {
    final b = _birthday;
    _birthdayText.text = b == null ? '' : context.s.ymd(b);
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthday = picked;
      _syncBirthdayText();
    });
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final app = AppScope.read(context);
    final s = context.s;

    final wantsPasswordChange = _newPassword.text.isNotEmpty;
    if (wantsPasswordChange && !app.checkPassword(_currentPassword.text)) {
      setState(() => _errorKey = 'err.wrongPassword');
      return;
    }
    final error = app.updateProfile(
      name: _name.text,
      email: _email.text,
      birthday: _birthday,
      avatar: _avatar,
    );
    if (error != null) {
      setState(() => _errorKey = error);
      return;
    }
    if (wantsPasswordChange) {
      final passwordError = app.changePassword(
        _currentPassword.text,
        _newPassword.text,
      );
      if (passwordError != null) {
        setState(() => _errorKey = passwordError);
        return;
      }
    }
    showSnack(context, s('profile.saved'));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.page,
      body: ScreenPage(
        children: [
          DetailHeader(title: s('profile.title'), eyebrow: s('profile.eyebrow')),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Avatar(size: 88, name: _name.text, colorIndex: _avatar),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    s('profile.pickColor'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < avatarColors.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _avatar = i),
                        child: Container(
                          width: 34,
                          height: 34,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: avatarColors[i],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _avatar == i ? p.ink : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: _avatar == i
                              ? const Icon(AppIcons.check, size: 18, color: Colors.white)
                              : null,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                SoftCard(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Column(
                    children: [
                      ProfileField(
                        key: const Key('profile_name'),
                        controller: _name,
                        label: s('auth.name'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? s('err.nameRequired')
                            : null,
                      ),
                      Divider(height: 1, color: p.line),
                      ProfileField(
                        key: const Key('profile_email'),
                        controller: _email,
                        label: s('auth.email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !AppState.isValidEmail(v))
                            ? s('err.emailInvalid')
                            : null,
                      ),
                      Divider(height: 1, color: p.line),
                      ProfileField(
                        controller: _birthdayText,
                        label: s('profile.birthday'),
                        readOnly: true,
                        onTap: _pickBirthday,
                        suffix: _birthday == null
                            ? Icon(AppIcons.calendarBlank, size: 18, color: p.muted)
                            : IconButton(
                                icon: Icon(AppIcons.close, size: 18, color: p.muted),
                                onPressed: () => setState(() {
                                  _birthday = null;
                                  _syncBirthdayText();
                                }),
                              ),
                      ),
                    ],
                  ),
                ),
                GroupLabel(s('profile.passwordGroup')),
                SoftCard(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Column(
                    children: [
                      ProfileField(
                        controller: _currentPassword,
                        label: s('profile.currentPassword'),
                        obscureText: true,
                        validator: (v) {
                          if (_newPassword.text.isNotEmpty && (v == null || v.isEmpty)) {
                            return s('err.passwordRequired');
                          }
                          return null;
                        },
                      ),
                      Divider(height: 1, color: p.line),
                      ProfileField(
                        controller: _newPassword,
                        label: s('auth.newPassword'),
                        obscureText: true,
                        validator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              v.length < AppState.minPasswordLength) {
                            return s('err.passwordShort');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    s('profile.passwordHint'),
                    style: TextStyle(fontSize: 11, color: p.muted, height: 1.5),
                  ),
                ),
                if (_errorKey != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    s(_errorKey!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFD9534F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                PrimaryButton(
                  key: const Key('profile_save'),
                  icon: AppIcons.check,
                  label: s('profile.save'),
                  onTap: _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

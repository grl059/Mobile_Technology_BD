import 'package:flutter/material.dart';

import '../core/core.dart';

/// Нэвтрэх/бүртгүүлэх хуудасны талбар (дүрс, шошготой).
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
    this.validator,
    this.onSubmitted,
    this.autofillHints,
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
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      autofillHints: autofillHints,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 13, color: p.muted),
        hintStyle: TextStyle(fontSize: 13, color: p.muted.withAlpha(150)),
        errorStyle: const TextStyle(fontSize: 11),
        prefixIcon: Icon(icon, size: 20, color: p.accent),
        suffixIcon: suffix,
        filled: true,
        fillColor: p.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        enabledBorder: border(p.line),
        focusedBorder: border(p.accent, 1.5),
        errorBorder: border(const Color(0xFFD9534F)),
        focusedErrorBorder: border(const Color(0xFFD9534F), 1.5),
      ),
    );
  }
}

/// Профайл болон тохиргооны карт доторх хүрээгүй талбар.
class ProfileField extends StatelessWidget {
  const ProfileField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: p.muted, fontWeight: FontWeight.w600),
        errorStyle: const TextStyle(fontSize: 11),
        suffixIcon: suffix,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

/// Олон мөрт текст талбар (тэмдэглэл, санал хүсэлт).
class NoteField extends StatelessWidget {
  const NoteField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.maxLength,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: 3,
      maxLines: 5,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 14, height: 1.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: p.muted.withAlpha(160)),
        filled: true,
        fillColor: p.card,
        counterStyle: TextStyle(fontSize: 11, color: p.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

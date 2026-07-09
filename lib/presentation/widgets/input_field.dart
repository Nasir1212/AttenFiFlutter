import 'package:flutter/material.dart';
import 'package:atten_fi/core/constants/app_colors.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType keyboardType;
  final bool isPassword;
  final int maxLines; // 🌟 ঠিকানা লেখার জন্য maxLines যোগ করা হলো
  final String? Function(String?)? validator; // 🌟 ভ্যালিডেশনের জন্য এটি দরকার

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.maxLines = 1, // ডিফল্ট ১ লাইন
    this.validator, // অপশনাল ভ্যালিডেটর
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // 🌟 TextField থেকে TextFormField করা হলো
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      maxLines: maxLines,
      validator: validator, // 🌟 ভ্যালিডেটর অ্যাসাইন করা হলো
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
        labelStyle: const TextStyle(color: AppColors.grayText, fontSize: 14),
        filled: true,
        fillColor: AppColors.white,
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        // 🌟 ভ্যালিডেশন এরর বর্ডার ডিজাইন
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

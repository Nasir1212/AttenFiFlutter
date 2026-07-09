import 'package:flutter/material.dart';
import 'package:atten_fi/core/constants/app_colors.dart';

class Select extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;

  const Select({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true, // টেক্সট বড় হলে ওভারফ্লো হবে না
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grayText, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
        filled: true,
        fillColor: AppColors.white, // আপনার রিকোয়ারমেন্ট অনুযায়ী পিওর হোয়াইট
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),

        // InputField-এর সাথে মিল রেখে বর্ডার ডিজাইন
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 15)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

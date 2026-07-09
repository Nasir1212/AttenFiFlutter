import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final String? actionText;
  final VoidCallback onTap;
  final MainAxisAlignment alignment;

  const LinkButton({
    super.key,
    required this.text,
    this.actionText,
    required this.onTap,
    this.alignment = MainAxisAlignment.center, // ডিফল্টভাবে মাঝখানে থাকবে
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText ?? "",
            style: const TextStyle(
              color: AppColors.primary, // আপনার নীল কালারটি ব্যবহার হবে
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

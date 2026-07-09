import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'auth/auth_screen.dart';
import 'auth/user_otp_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, String role) async {
    if (!context.mounted) return;

    if (role == 'admin') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserOtpScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 110,
                  height: 110,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "স্বাগতম AttenFI-তে",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "অ্যাপটি ব্যবহার করতে আপনার অ্যাকাউন্ট টাইপ সিলেক্ট করুন",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grayText,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              _buildRoleCard(
                context: context,
                title: "এডমিন/ম্যানেজার",
                subtitle: "কর্মচারিদের হাজিরা ম্যানেজমেন্ট করতে",
                icon: Icons.admin_panel_settings_rounded,
                iconColor: AppColors.primary,
                onTap: () => _selectRole(context, 'admin'),
              ),

              const SizedBox(height: 16),

              _buildRoleCard(
                context: context,
                title: "কর্মচারি",
                subtitle: "কর্মচারি হিসাবে হাজিরা দিতে",
                icon: Icons.person_rounded,
                iconColor: AppColors.userPrimary,
                onTap: () => _selectRole(context, 'user'),
              ),

              const Spacer(flex: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Secure & Encrypted Platform",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // প্রিমিয়াম রোল কার্ড充বিল্ডার উইজেট
  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: iconColor.withOpacity(0.05),
        highlightColor: iconColor.withOpacity(0.02),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // কাস্টম আইকন কন্টেইনার
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 30, color: iconColor),
              ),
              const SizedBox(width: 16),

              // টেক্সট গ্রুপ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

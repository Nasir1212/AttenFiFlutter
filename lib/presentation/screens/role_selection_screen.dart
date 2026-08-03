import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
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
        MaterialPageRoute(builder: (context) => const UserOtpScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // 🌐 ভাষা পরিবর্তন করার বাটন (EN / বাং)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // English Button
                      _buildLanguageButton(
                        context: context,
                        label: 'EN',
                        isSelected:
                            languageProvider.currentLocale.languageCode == 'en',
                        onTap: () {
                          // 🔑 প্রোভাইডার এর মাধ্যমে ভাষা পরিবর্তন ও সেভ করা
                          languageProvider.changeLanguage(const Locale('en'));
                        },
                      ),
                      const SizedBox(width: 4),
                      // Bangla Button
                      _buildLanguageButton(
                        context: context,
                        label: 'বাং',
                        isSelected:
                            languageProvider.currentLocale.languageCode == 'bn',
                        onTap: () {
                          languageProvider.changeLanguage(const Locale('bn'));
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Logo Container
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

              Text(
                l10n.welcomeTitle,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectAccountTypeSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grayText,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              _buildRoleCard(
                context: context,
                title: l10n.adminRoleTitle,
                subtitle: l10n.adminRoleSubtitle,
                icon: Icons.admin_panel_settings_rounded,
                iconColor: AppColors.primary,
                onTap: () => _selectRole(context, 'admin'),
              ),

              const SizedBox(height: 16),

              _buildRoleCard(
                context: context,
                title: l10n.employeeRoleTitle,
                subtitle: l10n.employeeRoleSubtitle,
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
                    l10n.securePlatformText,
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

  // 🌐 ল্যাঙ্গুয়েজ সুইচিং বাটন বিল্ডার
  Widget _buildLanguageButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }

  // প্রিমিয়াম রোল কার্ড বিল্ডার উইজেট
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

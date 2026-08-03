import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:atten_fi/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/link_button.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  // টেক্সট কন্ট্রোলার (ডাটা ইনপুট নেওয়ার জন্য)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 100, width: 100),
                const SizedBox(height: 8),
                Text(
                  l10n.adminLoginSubtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 60),

                // ইমেইল ইনপুট ফিল্ড
                InputField(
                  controller: _emailController,
                  hint: l10n.emailHint,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  label: l10n.emailLabel,
                ),
                const SizedBox(height: 20),

                // পাসওয়ার্ড ইনপুট ফিল্ড
                InputField(
                  controller: _passwordController,
                  hint: l10n.passwordHint,
                  label: l10n.passwordLabel,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                // লগইন বাটন
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: PrimaryButton(
                    label: l10n.loginButton,
                    icon: Icons.login,
                    isLoading: authProvider.isLoading, // লোডিং স্টেট হ্যান্ডেল
                    onPressed: () => _handleLogin(context, authProvider),
                  ),
                ),

                const SizedBox(height: 25),

                // একাউন্ট তৈরি করার বাটন/লিঙ্ক
                LinkButton(
                  text: l10n.noAccountText,
                  actionText: l10n.createAccountText,
                  alignment: MainAxisAlignment.center,
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // লগইন হ্যান্ডলার এবং ভ্যালিডেশন
  void _handleLogin(BuildContext context, AuthProvider authProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // ১. খালি ফিল্ড ভ্যালিডেশন
    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar.show(
        context,
        message: l10n.fillEmailAndPasswordValidation,
        isSuccess: false,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    // ২. এপিআই কল করা
    final result = await authProvider.loginUser(
      email: email,
      password: password,
    );

    // ৩. রেসপন্স অনুযায়ী রাউটিং ও ইউআই
    if (context.mounted) {
      if (result['success'] == true) {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        // লগইন সফল হলে ড্যাশবোর্ডে নিয়ে যাওয়া এবং ব্যাক স্ট্যাক ক্লিয়ার করা
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      } else {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: false,
          icon: Icons.lock_person_outlined,
        );
      }
    }
  }
}

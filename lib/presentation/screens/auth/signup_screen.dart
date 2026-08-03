import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/presentation/widgets/custom_snackbar.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:atten_fi/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/model/user_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/select.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // কন্ট্রোলারগুলোকে State ক্লাসের প্রোপার্টি হিসেবে রাখা হলো
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'owner': TextEditingController(),
      'org': TextEditingController(),
      'email': TextEditingController(),
      'phone': TextEditingController(),
      'pass': TextEditingController(),
      'con_pass': TextEditingController(),
    };
  }

  // মেমোরি লিক রোধ করতে dispose করা জরুরি
  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    final List<String> employeeRanges = [
      l10n.range1To10,
      l10n.range11To50,
      l10n.range51To100,
      l10n.range100Plus,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A237E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                Text(
                  l10n.registerTitle,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 40),

                // ১. মালিকের নাম
                InputField(
                  controller: _controllers['owner']!,
                  label: l10n.ownerNameLabel,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // ২. প্রতিষ্ঠানের নাম
                InputField(
                  controller: _controllers['org']!,
                  label: l10n.companyNameLabel,
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 20),

                // ৩. কতজন কর্মচারী (Dropdown)
                Select(
                  label: l10n.employeeRangeLabel,
                  icon: Icons.groups_outlined,
                  items: employeeRanges,
                  value: authProvider.selectedRange,
                  onChanged: (val) {
                    authProvider.setSelectedRange(val);
                  },
                ),
                const SizedBox(height: 20),

                // ৪. ইমেইল
                InputField(
                  controller: _controllers['email']!,
                  label: l10n.emailAddressLabel,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // ৫. ফোন নম্বর
                InputField(
                  controller: _controllers['phone']!,
                  label: l10n.phoneNumberLabel,
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // ৬. পাসওয়ার্ড
                InputField(
                  controller: _controllers['pass']!,
                  label: l10n.passwordLabelText,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                InputField(
                  controller: _controllers['con_pass']!,
                  label: l10n.confirmPasswordLabel,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: PrimaryButton(
                    label: l10n.completeRegistrationButton,
                    icon: Icons.save,
                    isLoading: authProvider.isLoading,
                    onPressed: () => _handleSignup(context, authProvider),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup(BuildContext context, AuthProvider authProvider) async {
    final l10n = AppLocalizations.of(context)!;

    if (_controllers['owner']!.text.isEmpty ||
        _controllers['email']!.text.isEmpty ||
        _controllers['org']!.text.isEmpty ||
        _controllers['phone']!.text.isEmpty ||
        _controllers['pass']!.text.isEmpty ||
        authProvider.selectedRange == null) {
      CustomSnackBar.show(
        context,
        message: l10n.fillAllFieldsValidation,
        isSuccess: false,
        icon: Icons.error_outline,
      );
      return;
    }

    if (_controllers['pass']!.text != _controllers['con_pass']!.text) {
      CustomSnackBar.show(
        context,
        message: l10n.passwordsDoNotMatchValidation,
        isSuccess: false,
        icon: Icons.error_outline,
      );
      return;
    }

    final userPayload = UserModel(
      ownerName: _controllers['owner']!.text.trim(),
      companyName: _controllers['org']!.text.trim(),
      employeeRange: authProvider.selectedRange!,
      email: _controllers['email']!.text.trim(),
      phone: _controllers['phone']!.text.trim(),
      password: _controllers['pass']!.text,
    );

    final result = await authProvider.registerUser(userPayload);

    if (context.mounted) {
      if (result['success'] == true) {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: false,
          icon: Icons.gpp_bad_outlined,
        );
      }
    }
  }
}

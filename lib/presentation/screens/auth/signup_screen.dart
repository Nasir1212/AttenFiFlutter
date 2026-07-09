import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/presentation/widgets/custom_snackbar.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:atten_fi/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/model/user_model.dart';
import '../../widgets/select.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final List<String> _employeeRanges = [
    "১-১০ জন",
    "১১-৫০ জন",
    "৫১-১০০ জন",
    "১০০+ জন",
  ];

  final Map<String, TextEditingController> _controllers = {
    'owner': TextEditingController(),
    'org': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'pass': TextEditingController(),
    'con_pass': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                const Text(
                  "নিবন্ধন করুন",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 40),

                // ১. মালিকের নাম
                InputField(
                  controller: _controllers['owner']!,
                  label: "মালিকের নাম / Owner Name", // এখানে লেবেল যোগ হয়েছে
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // ২. প্রতিষ্ঠানের নাম
                InputField(
                  controller: _controllers['org']!,
                  label: "প্রতিষ্ঠানের নাম / Company Name",
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 20),

                // ৩. কতজন কর্মচারী (Dropdown)
                // আপনার স্ক্রিনের Column-এর ভেতর:
                Select(
                  label: "কতজন কর্মচারী / Employee Range",
                  icon: Icons.groups_outlined,
                  items: _employeeRanges,
                  value: authProvider.selectedRange,
                  onChanged: (val) {
                    authProvider.setSelectedRange(val);
                  },
                ),
                const SizedBox(height: 20),

                // ৪. ইমেইল
                InputField(
                  controller: _controllers['email']!,
                  label: "ইমেইল অ্যাড্রেস / Email Address",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // ৫. ফোন নম্বর
                InputField(
                  controller: _controllers['phone']!,
                  label: "ফোন নম্বর / Phone Number",
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // ৬. পাসওয়ার্ড
                InputField(
                  controller: _controllers['pass']!,
                  label: "পাসওয়ার্ড / Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                InputField(
                  controller: _controllers['con_pass']!,
                  label: "কনর্ফাম পাসওয়ার্ড / Confirom Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: PrimaryButton(
                    label: 'নিবন্ধন সম্পন্ন করুন',
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

  // সাইনআপ প্রসেস এবং ভ্যালিডেশন লজিক
  void _handleSignup(BuildContext context, AuthProvider authProvider) async {
    // ১. খালি ফিল্ড ভ্যালিডেশন
    if (_controllers['owner']!.text.isEmpty ||
        _controllers['email']!.text.isEmpty ||
        _controllers['org']!.text.isEmpty ||
        _controllers['phone']!.text.isEmpty ||
        _controllers['pass']!.text.isEmpty ||
        authProvider.selectedRange == null) {
      CustomSnackBar.show(
        context,
        message: "সবগুলো তথ্য সঠিকভাবে পূরণ করুন",
        isSuccess: false, // এরর কালার দেখাবে
        icon: Icons.error_outline,
      );
      return;
    }

    // ২. পাসওয়ার্ড ম্যাচিং ভ্যালিডেশন
    if (_controllers['pass']!.text != _controllers['con_pass']!.text) {
      CustomSnackBar.show(
        context,
        message: "পাসওয়ার্ড দুটি মিলছে না!",
        isSuccess: false, // এরর কালার দেখাবে
        icon: Icons.error_outline,
      );
      return;
    }

    // ৩. মডেল অবজেক্ট তৈরি (সব ডেটা মডেলে পুশ করা হচ্ছে)
    final userPayload = UserModel(
      ownerName: _controllers['owner']!.text.trim(),
      companyName: _controllers['org']!.text.trim(),
      employeeRange: authProvider.selectedRange!,
      email: _controllers['email']!.text.trim(),
      phone: _controllers['phone']!.text.trim(),
      password: _controllers['pass']!.text,
    );

    // ৪. প্রোভাইডারের মাধ্যমে এপিআই-তে মডেল পাঠানো
    final result = await authProvider.registerUser(userPayload);

    // ৫. রেসপন্স অনুযায়ী UI অ্যাকশন
    if (context.mounted) {
      if (result['success'] == true) {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: true, // এরর কালার দেখাবে
          icon: Icons.check_circle_outline,
        );
        Navigator.pushReplacementNamed(
          context,
          '/login',
        ); // সফল হলে লগইন পেজে রিডাইরেক্ট
      } else {
        CustomSnackBar.show(
          context,
          message: result['message'],
          isSuccess: false, // এরর কালার দেখাবে
          icon: Icons.gpp_bad_outlined,
        );
      }
    }
  }
}

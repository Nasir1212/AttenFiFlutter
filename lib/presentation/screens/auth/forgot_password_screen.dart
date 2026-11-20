import 'package:flutter/material.dart';
// ⚠️ আপনার InputField ফাইলের আসল পাথ বসান
import 'package:atten_fi/presentation/widgets/input_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _emailKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _otp = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  // 🔢 ধাপ: ০ = ইমেইল, ১ = OTP, ২ = নতুন পাসওয়ার্ড
  final _step = ValueNotifier<int>(0);

  Widget _button(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ১ম ধাপ: ইমেইল
  Widget _emailStep(BuildContext context) {
    return Form(
      key: _emailKey,
      child: Column(
        children: [
          const Text(
            'আপনার ইমেইল দিন। সেই ইমেইলে একটি OTP পাঠানো হবে।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'ইমেইল',
            controller: _email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'ইমেইল দিন';
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
                return 'সঠিক ইমেইল দিন';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _button(context, 'OTP পাঠান', () {
            if (_emailKey.currentState!.validate()) {
              // এখানে OTP পাঠানোর API কল হবে, সফল হলে পরের ধাপে যাবে
              _step.value = 1;
            }
          }),
        ],
      ),
    );
  }

  // ২য় ধাপ: OTP
  Widget _otpStep(BuildContext context) {
    return Form(
      key: _otpKey,
      child: Column(
        children: [
          Text(
            '${_email.text.trim()} ঠিকানায় পাঠানো OTP কোডটি দিন।',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'OTP কোড',
            controller: _otp,
            icon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'OTP কোড দিন' : null,
          ),
          const SizedBox(height: 24),
          _button(context, 'যাচাই করুন', () {
            if (_otpKey.currentState!.validate()) {
              // এখানে OTP যাচাইয়ের API কল হবে, সঠিক হলে পরের ধাপে যাবে
              _step.value = 2;
            }
          }),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _step.value = 0,
            child: const Text('ইমেইল বদলান'),
          ),
        ],
      ),
    );
  }

  // ৩য় ধাপ: নতুন পাসওয়ার্ড
  Widget _passwordStep(BuildContext context) {
    return Form(
      key: _passKey,
      child: Column(
        children: [
          const Text(
            'আপনার নতুন পাসওয়ার্ড দিন।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'নতুন পাসওয়ার্ড',
            controller: _newPass,
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'নতুন পাসওয়ার্ড দিন';
              if (v.length < 8) return 'কমপক্ষে ৮ অক্ষরের হতে হবে';
              return null;
            },
          ),
          const SizedBox(height: 14),
          InputField(
            label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
            controller: _confirmPass,
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'পাসওয়ার্ডটি আবার লিখুন';
              if (v != _newPass.text) return 'পাসওয়ার্ড দুটি মিলছে না';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _button(context, 'পাসওয়ার্ড পরিবর্তন করুন', () {
            if (_passKey.currentState!.validate()) {
              // এখানে নতুন পাসওয়ার্ড সেভের API কল হবে
            }
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('পাসওয়ার্ড ভুলে গেছেন'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Icon(Icons.lock_reset_rounded, size: 72, color: primary),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: _step,
              builder: (context, step, _) {
                switch (step) {
                  case 1:
                    return _otpStep(context);
                  case 2:
                    return _passwordStep(context);
                  default:
                    return _emailStep(context);
                }
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('লগইনে ফিরে যান'),
            ),
          ],
        ),
      ),
    );
  }
}

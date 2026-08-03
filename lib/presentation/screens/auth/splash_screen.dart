import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/presentation/screens/dashboard/admin_dashboard.dart';
import 'package:atten_fi/presentation/screens/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../User/dashboard/user_dashboard.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // ২ সেকেন্ড লোগো দেখানো এবং ব্যাকগ্রাউন্ডে রোল চেক করার কম্বাইন্ড ফাংশন
  Future<String?> _checkAuthAndDelay(BuildContext context) async {
    // ১. জোরপূর্বক ২ সেকেন্ড অপেক্ষা করা (লোগো দেখানোর জন্য)
    await Future.delayed(const Duration(seconds: 2));

    // ২. প্রোভাইডার থেকে রোল তুলে আনা
    if (context.mounted) {
      return await context.read<AuthProvider>().tryAutoLogin();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkAuthAndDelay(context),
      builder: (context, snapshot) {
        // যতক্ষণ ২ সেকেন্ড শেষ হচ্ছে না এবং ডাটা লোড হচ্ছে, ততক্ষণ লোগো ও ইন্ডিকেটর দেখাবে
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ২ সেকেন্ড পর ডাটা চলে আসলে রোল অনুযায়ী স্ক্রিন রিটার্ন করবে
        if (snapshot.hasData) {
          final String? userRole = snapshot.data;

          if (userRole == 'admin') {
            return const AdminDashboard();
          } else if (userRole == 'user') {
            return UserDashboard();
          }
        }

        // কোনো টোকেন বা রোল না থাকলে (নতুন ইনস্টল বা লগআউট) সরাসরি অথ স্ক্রিন দেখাবে
        return RoleSelectionScreen();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../User/dashboard/user_dashboard.dart';

class UserOtpScreen extends StatelessWidget {
  UserOtpScreen({super.key});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // 🛡️ পারমিশন ও জিপিএস চেক করার কমন মেথড (লোড এবং বাটন দুই জায়গাতেই কল হবে)
  Future<bool> _hasLocationAndGpsPermission(BuildContext context) async {
    // ১. প্রথমে লোকেশন পারমিশনের কারেন্ট স্ট্যাটাস দেখা
    var permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();
    }

    // ২. ফোনের GPS/Location Service অন আছে কিনা চেক করা
    bool isGpsEnabled = await Permission.location.serviceStatus.isEnabled;

    // 🟢 পারমিশন এবং জিপিএস দুটোই ওকে থাকলে true রিটার্ন করবে
    if (permissionStatus.isGranted && isGpsEnabled) {
      return true;
    }

    // 🔴 অনুমতি না থাকলে বা জিপিএস বন্ধ থাকলে ডায়ালগ দেখাবে
    bool isPermanentlyBlocked = permissionStatus.isPermanentlyDenied;

    if (!context.mounted) return false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber),
            SizedBox(width: 10),
            Text('অনুমতি প্রয়োজন'),
          ],
        ),
        content: Text(
          !isGpsEnabled
              ? 'আপনার ফোনের GPS/Location Service বন্ধ আছে। দয়া করে এটি অন করুন।'
              : isPermanentlyBlocked
              ? 'আপনি লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করেছেন। লগইন করতে ফোনের সেটিংস থেকে অনুমতি অন করুন।'
              : 'ওয়াইফাই ভেরিফিকেশনের জন্য লোকেশন পারমিশন দেওয়া বাধ্যতামূলক।',
        ),
        actions: [
          // ❌ বাতিল বাটন: জাস্ট ডায়ালগ বন্ধ করবে, ইউজার ওটিপি স্ক্রিনেই থাকবে (ব্যাক হবে না)
          TextButton(
            onPressed: () {
              if (Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);
            },
            child: const Text('বাতিল', style: TextStyle(color: Colors.grey)),
          ),

          // 🎯 মূল অ্যাকশন বাটন
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);

              if (isPermanentlyBlocked) {
                await openAppSettings();
              }
            },
            child: Text(
              !isGpsEnabled
                  ? 'ঠিক আছে'
                  : isPermanentlyBlocked
                  ? 'সেটিংস ওপেন করুন'
                  : 'আবার চেষ্টা করুন',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return false; // পারমিশন সাকসেসফুল না হলে false
  }

  // 🚀 ১. আইডি সাবমিট করে ওটিপি পাঠানোর ফাংশন
  void _sendOtp(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final idText = _idController.text.trim();

    if (idText.isEmpty) {
      _showSnackBar(context, "অনুগ্রহ করে আপনার আইডি প্রদান করুন");
      return;
    }

    bool isPermissionOk = await _hasLocationAndGpsPermission(context);
    if (!isPermissionOk) {
      return; // পারমিশন না দিলে ওটিপি API কল হবে না
    }

    try {
      final msg = await authProvider.sendOtp(idText);
      if (msg['success'] == true && context.mounted) {
        _showSnackBar(
          context,
          "আপনার রেজিস্টার্ড নাম্বারে ওটিপি পাঠানো হয়েছে",
          isError: false,
        );
      } else {
        _showSnackBar(context, msg['message']);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, "ওটিপি পাঠাতে সমস্যা হয়েছে: $e");
      }
    }
  }

  // 🔐 ২. ওটিপি ভেরিফাই করে লগইন সম্পন্ন করার ফাংশন
  void _verifyOtpAndLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final otpText = _otpController.text.trim();
    final idText = authProvider.currentEmployeeId ?? _idController.text.trim();
    if (otpText.length < 4) {
      _showSnackBar(context, "অনুগ্রহ করে সঠিক ওটিপি কোডটি দিন");
      return;
    }

    try {
      bool loginSuccess = await authProvider.verifyOtpAndLogin(idText, otpText);
      if (loginSuccess && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboard()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, "ভেরিফিকেশন ব্যর্থ হয়েছে: $e");
      }
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 14)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _hasLocationAndGpsPermission(context));

    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final isOtpSent = authProvider.isOtpSent;
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 90,
                    height: 90,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "কর্মচারী লগইন",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOtpSent
                      ? "আপনার মোবাইলে প্রাপ্ত ওটিপি কোডটি নিচে প্রদান করুন"
                      : "আপনার ইউনিক কর্মচারী আইডি দিয়ে লগইন করুন",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // 🆔 আইডি ইনপুট ফিল্ড
                _buildTextField(
                  controller: _idController,
                  hintText: "কর্মচারীর  আইডি (যেমন: 001100)",
                  icon: Icons.badge_outlined,
                  enabled: !isOtpSent && !isLoading,
                  keyboardType: TextInputType.text,
                  focusColor: theme.colorScheme.primary,
                ),

                if (isOtpSent)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildTextField(
                      controller: _otpController,
                      hintText: "৪ বা ৬ ডিজিটের ওটিপি কোড",
                      icon: Icons.lock_open_rounded,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      focusColor: theme.colorScheme.primary,
                    ),
                  ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => isOtpSent
                              ? _verifyOtpAndLogin(context)
                              : _sendOtp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: theme.colorScheme.primary
                          .withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            isOtpSent ? "ভেরিফাই ও লগইন" : "ওটিপি পাঠান",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                if (isOtpSent)
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            authProvider.resetOtpState();
                            _otpController.clear();
                          },
                    child: Text(
                      "আইডি ভুল হয়েছে? পরিবর্তন করুন",
                      style: TextStyle(
                        color: theme.colorScheme.secondary.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // কাস্টম টেক্সট ফিল্ড হেল্পার
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool enabled,
    required TextInputType keyboardType,
    required Color focusColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: focusColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

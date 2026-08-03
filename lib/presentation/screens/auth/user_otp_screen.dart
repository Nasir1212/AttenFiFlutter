import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../User/dashboard/user_dashboard.dart';

class UserOtpScreen extends StatefulWidget {
  const UserOtpScreen({super.key});

  @override
  State<UserOtpScreen> createState() => _UserOtpScreenState();
}

class _UserOtpScreenState extends State<UserOtpScreen> {
  late final TextEditingController _idController;
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _otpController = TextEditingController();

    // স্ক্রিন লোড হওয়ার পর পারমিশন চেক
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _hasLocationAndGpsPermission(context);
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // 🛡️ পারমিশন ও জিপিএস চেক করার কমন মেথড
  Future<bool> _hasLocationAndGpsPermission(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    var permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();
    }

    bool isGpsEnabled = await Permission.location.serviceStatus.isEnabled;

    if (permissionStatus.isGranted && isGpsEnabled) {
      return true;
    }

    bool isPermanentlyBlocked = permissionStatus.isPermanentlyDenied;

    if (!context.mounted) return false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber),
            const SizedBox(width: 10),
            Text(l10n.permissionRequiredTitle),
          ],
        ),
        content: Text(
          !isGpsEnabled
              ? l10n.gpsDisabledMessage
              : isPermanentlyBlocked
              ? l10n.locationPermanentlyBlockedMessage
              : l10n.locationPermissionRequiredMessage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              l10n.cancelButton,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }

              if (isPermanentlyBlocked) {
                await openAppSettings();
              }
            },
            child: Text(
              !isGpsEnabled
                  ? l10n.okButton
                  : isPermanentlyBlocked
                  ? l10n.openSettingsButton
                  : l10n.tryAgainButton,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return false;
  }

  // 🚀 ১. আইডি সাবমিট করে ওটিপি পাঠানোর ফাংশন
  void _sendOtp(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final idText = _idController.text.trim();

    if (idText.isEmpty) {
      _showSnackBar(context, l10n.provideEmployeeIdError);
      return;
    }

    bool isPermissionOk = await _hasLocationAndGpsPermission(context);
    if (!isPermissionOk) {
      return;
    }

    try {
      final msg = await authProvider.sendOtp(idText);
      if (msg['success'] == true && context.mounted) {
        _showSnackBar(context, l10n.otpSentSuccess, isError: false);
      } else if (context.mounted) {
        _showSnackBar(context, msg['message']);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, l10n.otpSendError(e.toString()));
      }
    }
  }

  // 🔐 ২. ওটিপি ভেরিফাই করে লগইন সম্পন্ন করার ফাংশন
  void _verifyOtpAndLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final otpText = _otpController.text.trim();
    final idText = authProvider.currentEmployeeId ?? _idController.text.trim();

    if (otpText.length < 4) {
      _showSnackBar(context, l10n.enterValidOtpError);
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
        _showSnackBar(context, l10n.verificationFailedError(e.toString()));
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
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.employeeLoginTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOtpSent ? l10n.enterOtpSubtitle : l10n.enterIdSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // 🆔 আইডি ইনপুট ফিল্ড
                _buildTextField(
                  controller: _idController,
                  hintText: l10n.employeeIdHint,
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
                      hintText: l10n.otpCodeHint,
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
                            isOtpSent
                                ? l10n.verifyAndLoginButton
                                : l10n.sendOtpButton,
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
                      l10n.changeIdButton,
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

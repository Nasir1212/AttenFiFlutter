import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_snackbar.dart';

// ignore: must_be_immutable
class WifiSetupScreen extends StatelessWidget {
  WifiSetupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _bssidController = TextEditingController();

  // প্রথমবার অটো-সিঙ্ক ট্র্যাক করার জন্য ফ্ল্যাগ
  bool _isAutoSynced = false;
  final NetworkInfo _networkInfo = NetworkInfo();

  // অটো ওয়াইফাই সিঙ্ক করার মেথড
  Future<void> _autoSyncWifi(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // ১. প্রথমে লোকেশন পারমিশন চেক ও রিকোয়েস্ট করা
      PermissionStatus status = await Permission.locationWhenInUse.status;

      if (status.isDenied) {
        status = await Permission.locationWhenInUse.request();
      }

      if (status.isGranted) {
        // ২. ওয়াইফাই নাম (SSID) এবং রাউটার আইডি (BSSID) সংগ্রহ করা
        String? wifiName = await _networkInfo.getWifiName();
        String? wifiBSSID = await _networkInfo.getWifiBSSID();

        if (wifiName != null) {
          wifiName = wifiName.replaceAll('"', '');
          _ssidController.text = wifiName;
        }

        if (wifiBSSID != null) {
          _bssidController.text = wifiBSSID;
        }

        if (context.mounted && (wifiName != null || wifiBSSID != null)) {
          CustomSnackBar.show(
            context,
            message: l10n.wifiAutoSyncedSuccess,
            isSuccess: true,
            icon: Icons.wifi_find,
          );
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            message: l10n.locationPermissionRequiredWifi,
            isSuccess: false,
            icon: Icons.location_off,
          );
        }
      }
    } catch (e) {
      debugPrint("WiFi Sync Error: $e");
    }
  }

  // ডাটা ব্যাকএন্ডে সেভ করার মেথড
  void _submitForm(BuildContext context, int? officeId) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final String? userToken = context.read<AuthProvider>().token;
    if (userToken == null) return;

    // স্ক্রিনে লোডিং ডায়ালগ দেখানো
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await context.read<OfficeProvider>().saveWifi(
      token: userToken,
      officeId: officeId, // আইডি থাকলে পাস হবে, ডিরেক্ট মেনু হলে null যাবে
      ssid: _ssidController.text.trim(),
      bssid: _bssidController.text.trim(),
    );

    if (context.mounted) Navigator.pop(context); // লোডিং বন্ধ

    if (result['success'] == true) {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: result['message'] ?? l10n.wifiSaveSuccess,
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pop(context); // সফল হলে আগের স্ক্রিনে ব্যাক করবে
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: result['message'] ?? l10n.wifiSaveFailed,
          isSuccess: false,
          icon: Icons.error_outline,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);
    final l10n = AppLocalizations.of(context)!;

    // রাউটিং আর্গুমেন্ট থেকে অফিস আইডি রিসিভ করা (অফিস ছাড়া আসলে null থাকবে)
    final int? officeId = ModalRoute.of(context)?.settings.arguments as int?;

    // ট্রিক: স্ক্রিন ওপেন হওয়ার পর কন্ট্রোলার খালি থাকলে এবং আগে সিঙ্ক না হয়ে থাকলে অটো কল হবে
    if (!_isAutoSynced && _ssidController.text.isEmpty) {
      _isAutoSynced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoSyncWifi(context);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          officeId != null
              ? l10n.officeWifiSetupTitle
              : l10n.globalWifiSetupTitle,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _autoSyncWifi(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.wifi_lock, size: 80, color: primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.configureOfficeWifiTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.configureOfficeWifiSubtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 30),

              // ১. ওয়াইফাই নাম (SSID)
              InputField(
                label: l10n.wifiNameLabel,
                controller: _ssidController,
                icon: Icons.wifi,
                hint: l10n.wifiNameHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.wifiNameRequired
                    : null,
              ),
              const SizedBox(height: 20),

              // ২. রাউটার আইডি (BSSID)
              InputField(
                label: l10n.routerBssidLabel,
                controller: _bssidController,
                icon: Icons.fingerprint,
                hint: l10n.routerBssidHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.routerBssidRequired
                    : null,
              ),
              const SizedBox(height: 40),

              // সেভ বাটন
              SizedBox(
                width: double.infinity,
                height: 55,
                child: PrimaryButton(
                  label: l10n.saveButton,
                  icon: Icons.save,
                  onPressed: () => _submitForm(context, officeId),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomAdBottomBar(),
    );
  }
}

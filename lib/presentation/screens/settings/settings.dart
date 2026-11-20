import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/language_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/dob_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 🌐 ভাষা নির্বাচনের বটম শিট দেখানোর ফাংশন
  void _showLanguageBottomSheet(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final l10n = AppLocalizations.of(context)!;
    final String currentCode = languageProvider.currentLocale.languageCode;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // 🇧🇩 বাংলা অপশন
              ListTile(
                leading: const Text('🇧🇩', style: TextStyle(fontSize: 24)),
                title: const Text('বাংলা (Bangla)'),
                trailing: currentCode == 'bn'
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : const Icon(Icons.circle_outlined, color: Colors.grey),
                onTap: () {
                  // 🔑 প্রোভাইডার এর মাধ্যমে ভাষা পরিবর্তন ও সেভ করা
                  languageProvider.changeLanguage(const Locale('bn'));
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),

              // 🇺🇸 ইংরেজি অপশন
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: const Text('English'),
                trailing: currentCode == 'en'
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : const Icon(Icons.circle_outlined, color: Colors.grey),
                onTap: () {
                  // 🔑 প্রোভাইডার এর মাধ্যমে ভাষা পরিবর্তন ও সেভ করা
                  languageProvider.changeLanguage(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyAttendancePopup(BuildContext context) async {
    final bool? proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(
          Icons.fingerprint_rounded,
          size: 44,
          color: Theme.of(ctx).primaryColor,
        ),
        title: const Text(
          'নিজের হাজিরা দিন',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'নিজের হাজিরা দিতে আপনাকে একবার কর্মীর তথ্য পূরণ করতে হবে। এরপর থেকে সরাসরি ইউজার মোডে ঢুকতে পারবেন।',
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx, true);
              _showEmployeeFormPopup(context);
            },
            child: const Text('পরবর্তী'),
          ),
        ],
      ),
    );

    if (proceed == true && context.mounted) {
      // ➡️ "পরবর্তী" চাপলে এখানে পরের ধাপ খুলবে
      // উদাহরণ: Navigator.pushNamed(context, '/manager-profile-form');
    }
  }

  // 📝 ফর্ম পপআপ
  void _showEmployeeFormPopup(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final fatherName = TextEditingController();
    final motherName = TextEditingController();
    final nid = TextEditingController();
    final mobile = TextEditingController();
    final dobError = ValueNotifier<String?>(null);
    String? dobText;

    InputDecoration dec(String label, IconData icon) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'আপনার তথ্য',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.add_a_photo_outlined, size: 26),
                  ),
                  const SizedBox(height: 14),

                  // নাম (আবশ্যক)
                  TextFormField(
                    controller: name,
                    decoration: dec('নাম', Icons.person_outline),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'নাম দিন' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: fatherName,
                    decoration: dec('পিতার নাম', Icons.man_outlined),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: motherName,
                    decoration: dec('মাতার নাম', Icons.woman_outlined),
                  ),
                  const SizedBox(height: 10),

                  // এনআইডি (ঐচ্ছিক, দিলে ১০/১৩/১৭ অঙ্ক)
                  TextFormField(
                    controller: nid,
                    keyboardType: TextInputType.number,
                    decoration: dec('এনআইডি নম্বর', Icons.badge_outlined),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'শুধু সংখ্যা দিন';
                      }
                      if (![10, 13, 17].contains(value.length)) {
                        return 'এনআইডি ১০, ১৩ বা ১৭ অঙ্কের হতে হবে';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // জন্ম তারিখ (আবশ্যক)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'জন্ম তারিখ নির্বাচন করুন',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  DobPicker(
                    onChanged: (value) {
                      dobText = value;
                      if (value != null) dobError.value = null;
                    },
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: dobError,
                    builder: (_, error, __) => error == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                error,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),

                  // মোবাইল (আবশ্যক, বাংলাদেশি নম্বর)
                  TextFormField(
                    controller: mobile,
                    keyboardType: TextInputType.phone,
                    decoration: dec('মোবাইল', Icons.phone_outlined),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'মোবাইল নম্বর দিন';
                      if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(value)) {
                        return 'সঠিক মোবাইল নম্বর দিন (01XXXXXXXXX)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final formValid = formKey.currentState!.validate();

              if (dobText == null) {
                dobError.value = 'সঠিক জন্ম তারিখ বাছাই করুন';
              }

              if (!formValid || dobText == null) return;

              // ✅ ডাটা প্রিন্ট
              debugPrint('নাম: ${name.text.trim()}');
              debugPrint('পিতার নাম: ${fatherName.text.trim()}');
              debugPrint('মাতার নাম: ${motherName.text.trim()}');
              debugPrint('এনআইডি: ${nid.text.trim()}');
              debugPrint('জন্ম তারিখ: $dobText');
              debugPrint('মোবাইল: ${mobile.text.trim()}');

              Navigator.pop(ctx);
            },
            child: const Text('সংরক্ষণ করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔑 স্ট্যান্ডার্ড লোকালাইজেশন অবজেক্ট
    final l10n = AppLocalizations.of(context)!;
    // 🔑 বর্তমান ভাষা ট্র্যাক করা (UI সাথে সাথে রিরেন্ডার হওয়ার জন্য)
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isBangla = languageProvider.currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          // ------------------ ১. সাধারণ সেটিংস ------------------
          Text(
            l10n.generalSettings,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // অ্যাপের ভাষা
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: Text(l10n.appLanguage),
                  subtitle: Text(isBangla ? 'বাংলা (Bangla)' : 'English'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ------------------ ২. অন্যান্য ------------------
          Text(
            l10n.other,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // ✅ আমার হাজিরা (ম্যানেজার থেকে ইউজার ড্যাশবোর্ডে যাওয়া)
                ListTile(
                  leading: const Icon(
                    Icons.fingerprint_rounded,
                    color: Colors.indigo,
                  ),
                  title: Text(l10n.managerMyAttendance),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showMyAttendancePopup(context),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // ছুটির সেটিং
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.teal,
                  ),
                  title: Text(l10n.holidaySettings),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings-holly');
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // পাসওয়ার্ড পরিবর্তন
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.orange),
                  title: Text(l10n.changePassword),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, '/change-password');
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: Text(l10n.version),
                  trailing: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.hasData
                          ? 'v${snapshot.data!.version}'
                          : '...';
                      return Text(
                        version,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

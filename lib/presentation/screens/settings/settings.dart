import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/language_provider.dart';
import '../../../l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    // 🔑 স্ট্যান্ডার্ড লোকালাইজেশন অবজেক্ট
    final l10n = AppLocalizations.of(context)!;
    // 🔑 বর্তমান ভাষা ট্র্যাক করা (UI সাথে সাথে রিরেন্ডার হওয়ার জন্য)
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
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // ভার্সন
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: Text(l10n.version),
                  trailing: const Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
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

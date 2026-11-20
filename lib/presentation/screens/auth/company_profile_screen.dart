import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কোম্পানির প্রোফাইল'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🏢 উপরের অংশ
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: primary.withOpacity(0.1),
                  child: Icon(Icons.business_rounded, size: 40, color: primary),
                ),
                const SizedBox(height: 10),
                const Text(
                  'কোম্পানির নাম',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'মালিকের নাম',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 📋 তথ্য
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _infoTile(
                  Icons.apartment_rounded,
                  'কোম্পানির নাম',
                  'কোম্পানির নাম',
                  Colors.indigo,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.person_outline,
                  'মালিকের নাম',
                  'মালিকের নাম',
                  Colors.teal,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.email_outlined,
                  'ইমেইল',
                  'example@mail.com',
                  Colors.orange,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.phone_outlined,
                  'ফোন',
                  '01XXXXXXXXX',
                  Colors.green,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.groups_outlined,
                  'কর্মীর সংখ্যা',
                  '১-১০ জন',
                  Colors.purple,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.verified_outlined,
                  'ইমেইল যাচাই',
                  'যাচাই হয়েছে',
                  Colors.blue,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _infoTile(
                  Icons.calendar_today_outlined,
                  'নিবন্ধনের তারিখ',
                  '০১-০১-২০২৬',
                  Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

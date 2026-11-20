import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// 🌐 ⚠️ আপনার API বেস URL বসান (অথবা ApiConstants.baseUrl ব্যবহার করুন)
const String _baseUrl = 'https://YOUR_DOMAIN/api';

class ManagerSwitchService {
  static Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  // সুইচ চেক: প্রোফাইল থাকলে টোকেন, না থাকলে needs_profile = true
  static Future<Map<String, dynamic>> switchToUser(String token) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/manager/switch-to-user'),
      headers: _headers(token),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ফর্ম সাবমিট
  static Future<Map<String, dynamic>> saveProfile({
    required String token,
    required Map<String, String> fields,
    File? image,
  }) async {
    final req =
        http.MultipartRequest(
            'POST',
            Uri.parse('$_baseUrl/manager/user-profile'),
          )
          ..headers.addAll(_headers(token))
          ..fields.addAll(fields);

    if (image != null) {
      req.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

// 💬 ফর্ম পপআপ খোলার ফাংশন
// সফলভাবে সেভ হলে API-র সাড়া (Map) ফেরত দেয়, বাতিল করলে null
Future<Map<String, dynamic>?> showManagerProfileFormDialog(
  BuildContext context, {
  required String token,
  Map<String, dynamic> prefill = const {},
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (_) => ManagerProfileFormDialog(token: token, prefill: prefill),
  );
}

class ManagerProfileFormDialog extends StatefulWidget {
  final String token;
  final Map<String, dynamic> prefill;

  const ManagerProfileFormDialog({
    super.key,
    required this.token,
    this.prefill = const {},
  });

  @override
  State<ManagerProfileFormDialog> createState() =>
      _ManagerProfileFormDialogState();
}

class _ManagerProfileFormDialogState extends State<ManagerProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _mobile;
  final _father = TextEditingController();
  final _mother = TextEditingController();
  final _nid = TextEditingController();
  final _dob = TextEditingController();
  final _address = TextEditingController();

  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(
      text: widget.prefill['name']?.toString() ?? '',
    );
    _mobile = TextEditingController(
      text: widget.prefill['mobile']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    for (final c in [_name, _mobile, _father, _mother, _nid, _dob, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (date != null) {
      _dob.text =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final result = await ManagerSwitchService.saveProfile(
        token: widget.token,
        fields: {
          'name': _name.text.trim(),
          'mobile': _mobile.text.trim(),
          'father_name': _father.text.trim(),
          'mother_name': _mother.text.trim(),
          'nid': _nid.text.trim(),
          'dob': _dob.text.trim(),
          'address': _address.text.trim(),
        },
        image: _image,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pop(context, result); // সফল হলে সাড়া ফেরত
      } else {
        _showError(
          result['message']?.toString() ?? 'কিছু ভুল হয়েছে। আবার চেষ্টা করুন।',
        );
      }
    } catch (_) {
      if (mounted) _showError('কিছু ভুল হয়েছে। আবার চেষ্টা করুন।');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    isDense: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔝 হেডার
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'আপনার তথ্য',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _loading ? null : () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // 📝 ফর্ম (স্ক্রল করা যাবে)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: primary.withOpacity(0.1),
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : null,
                          child: _image == null
                              ? Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 28,
                                  color: primary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'ছবি যোগ করুন (ঐচ্ছিক)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _name,
                        decoration: _dec('নাম', Icons.person_outline),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'এই ঘরটি পূরণ করা আবশ্যক'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _mobile,
                        keyboardType: TextInputType.phone,
                        decoration: _dec('মোবাইল', Icons.phone_outlined),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'এই ঘরটি পূরণ করা আবশ্যক'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _father,
                        decoration: _dec('পিতার নাম', Icons.man_outlined),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _mother,
                        decoration: _dec('মাতার নাম', Icons.woman_outlined),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nid,
                        keyboardType: TextInputType.number,
                        decoration: _dec('এনআইডি নম্বর', Icons.badge_outlined),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dob,
                        readOnly: true,
                        onTap: _pickDob,
                        decoration: _dec('জন্ম তারিখ', Icons.cake_outlined),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _address,
                        maxLines: 2,
                        decoration: _dec('ঠিকানা', Icons.location_on_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ সাবমিট বাটন
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'সংরক্ষণ করে এগিয়ে যান',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

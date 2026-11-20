import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  // 👁️ পাসওয়ার্ড দেখা/লুকানোর অবস্থা
  final _hideOld = ValueNotifier<bool>(true);
  final _hideNew = ValueNotifier<bool>(true);
  final _hideConfirm = ValueNotifier<bool>(true);

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required ValueNotifier<bool> hidden,
    required String? Function(String?) validator,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: hidden,
      builder: (context, isHidden, _) => TextFormField(
        controller: controller,
        obscureText: isHidden,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              isHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => hidden.value = !hidden.value,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('পাসওয়ার্ড পরিবর্তন'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              _passwordField(
                label: 'পুরোনো পাসওয়ার্ড',
                controller: _oldPass,
                hidden: _hideOld,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'পুরোনো পাসওয়ার্ড দিন' : null,
              ),
              const SizedBox(height: 14),
              _passwordField(
                label: 'নতুন পাসওয়ার্ড',
                controller: _newPass,
                hidden: _hideNew,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'নতুন পাসওয়ার্ড দিন';
                  if (v.length < 8) return 'কমপক্ষে ৮ অক্ষরের হতে হবে';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _passwordField(
                label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
                controller: _confirmPass,
                hidden: _hideConfirm,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'পাসওয়ার্ডটি আবার লিখুন';
                  if (v != _newPass.text) return 'পাসওয়ার্ড দুটি মিলছে না';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // এখানে পাসওয়ার্ড পরিবর্তনের কাজ হবে
                    }
                  },
                  child: const Text(
                    'পাসওয়ার্ড পরিবর্তন করুন',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

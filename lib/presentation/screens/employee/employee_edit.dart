import 'dart:io';
import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/model/employee_model.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/employee_provider.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';

class EmployeeEditScreen extends StatelessWidget {
  EmployeeEditScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  final ValueNotifier<String> _dobNotifier = ValueNotifier<String>('');

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        _imageNotifier.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Image Pick Error: $e");
    }
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('গ্যালারি থেকে সিলেক্ট করুন'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('ক্যামেরা দিয়ে ছবি তুলুন'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String currentDob) async {
    DateTime initialDob = DateTime(2000);
    if (currentDob.isNotEmpty) {
      try {
        initialDob = DateFormat('dd/MM/yyyy').parse(currentDob);
      } catch (_) {
        initialDob = DateTime(2000);
      }
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDob,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      _dobController.text = formattedDate;
      _dobNotifier.value = formattedDate; // 🌟 নোটিফায়ার আপডেট করা হলো
    }
  }

  @override
  Widget build(BuildContext context) {
    final employee =
        ModalRoute.of(context)!.settings.arguments as EmployeeModel;

    // 🌟 ট্রিক: কন্ট্রোলারের টেক্সট যদি খালি থাকে (অর্থাৎ স্ক্রিন প্রথমবার ওপেন হয়েছে), শুধু তখনই ডাটা অ্যাসাইন হবে।
    // এর ফলে টাইপ বা ইমেজ পরিবর্তনের কারণে স্ক্রিন রি-বিল্ড হলেও আপনার ইনপুট করা নতুন ডাটা মুছে যাবে না।
    if (_nameController.text.isEmpty) {
      _nameController.text = employee.name;
      _mobileController.text = employee.mobile;
      _fatherNameController.text = employee.fatherName ?? '';
      _motherNameController.text = employee.motherName ?? '';
      _dobController.text = employee.dob ?? '';
      _nidController.text = employee.nid ?? '';
      _addressController.text = employee.address ?? '';
      _dobNotifier.value = employee.dob ?? ''; // শুরুর ডেট সেট করা
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          "তথ্য পরিবর্তন করুন",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ইমেজ সেকশন
              Center(
                child: Stack(
                  children: [
                    ValueListenableBuilder<File?>(
                      valueListenable: _imageNotifier,
                      builder: (context, newImage, child) {
                        return Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: newImage != null
                                ? Image.file(newImage, fit: BoxFit.cover)
                                : (employee.imageUrl != null &&
                                      employee.imageUrl!.isNotEmpty)
                                ? Image.network(
                                    employee.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.person,
                                              size: 55,
                                              color: Colors.grey,
                                            ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 55,
                                    color: Colors.grey,
                                  ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImageSourceBottomSheet(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              if (employee.employeeId != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "কর্মচারী আইডি: ${employee.employeeId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              InputField(
                controller: _nameController,
                label: "কর্মচারীর নাম",
                icon: Icons.person_outline,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "নাম আবশ্যক" : null,
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _mobileController,
                label: "মোবাইল নম্বর",
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "মোবাইল নম্বর আবশ্যক"
                    : null,
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _fatherNameController,
                label: "পিতার নাম",
                icon: Icons.person_search_outlined,
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _motherNameController,
                label: "মাতার নাম",
                icon: Icons.person_search_outlined,
              ),
              const SizedBox(height: 16),

              // 🌟 জন্ম তারিখ ফিল্ড (ValueListenableBuilder দিয়ে রেন্ডার অপ্টিমাইজ করা হলো)
              ValueListenableBuilder<String>(
                valueListenable: _dobNotifier,
                builder: (context, dobValue, child) {
                  return GestureDetector(
                    onTap: () => _selectDate(context, dobValue),
                    child: AbsorbPointer(
                      child: InputField(
                        label: "জন্ম তারিখ",
                        controller: _dobController,
                        icon: Icons.calendar_today,
                        hint: "DD/MM/YYYY",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _nidController,
                label: "এন.আই.ডি (NID)",
                icon: Icons.credit_card_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _addressController,
                label: "ঠিকানা",
                icon: Icons.home_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _saveForm(context, employee.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "হালনাগাদ করুন",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  void _saveForm(BuildContext context, int? employeeId) async {
    if (employeeId == null) return;
    if (!_formKey.currentState!.validate()) return;

    final String? userToken = context.read<AuthProvider>().token;
    if (userToken == null) return;

    final Map<String, String> updatedData = {
      'name': _nameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'father_name': _fatherNameController.text.trim(),
      'mother_name': _motherNameController.text.trim(),
      'dob': _dobController.text.trim(),
      'nid': _nidController.text.trim(),
      'address': _addressController.text.trim(),
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await context.read<EmployeeProvider>().updateEmployee(
      employeeId: employeeId,
      employeeData: updatedData,
      userToken: userToken,
      imageFile: _imageNotifier.value,
    );

    if (context.mounted) Navigator.pop(context);

    if (result == true) {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: "আপডেট করা হয়েছে",
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushNamed(context, '/employee-list-table');
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: "আবার চেষ্ট করুন",
          isSuccess: false,
          icon: Icons.error_outline,
        );
      }
    }
  }
}

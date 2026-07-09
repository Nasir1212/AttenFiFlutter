import 'dart:io';
import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/model/employee_model.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/employee_provider.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import 'package:atten_fi/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';

class AddEmployeeScreen extends StatelessWidget {
  AddEmployeeScreen({super.key});

  // টেক্সট কন্ট্রোলারসমূহ
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      _imageNotifier.value = File(pickedFile.path);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
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
      // 🌟 সিলেক্ট করা ডেটটিকে DD/MM/YYYY ফরম্যাটে কনভার্ট করে টেক্সট কন্ট্রোলারে বসানো
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      _dobController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          "নতুন কর্মচারী যোগ করুন",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ছবি আপলোড সেকশন
            Center(
              child: ValueListenableBuilder<File?>(
                valueListenable: _imageNotifier,
                builder: (context, selectedImage, child) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.grayText,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(selectedImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: selectedImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () => _pickImage(context),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // ইনপুট ফিল্ডসমূহ
            InputField(
              label: "কর্মচারীর নাম",
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            InputField(
              label: "পিতার নাম",
              controller: _fatherNameController,
              icon: Icons.person_search,
            ),
            const SizedBox(height: 15),
            InputField(
              label: "মাতার নাম",
              controller: _motherNameController,
              icon: Icons.person_search,
            ),
            const SizedBox(height: 15),
            InputField(
              label: "এনআইডি (NID) নম্বর",
              controller: _nidController,
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: InputField(
                  label: "জন্ম তারিখ",
                  controller: _dobController,
                  icon: Icons.calendar_today,
                  hint: "DD/MM/YYYY",
                ),
              ),
            ),
            const SizedBox(height: 15),

            InputField(
              label: "মোবাইল নম্বর",
              controller: _mobileController,
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            InputField(
              label: "সম্পূর্ন ঠিকানা",
              controller: _addressController,
              icon: Icons.home,
            ),
            const SizedBox(height: 40),

            // সেভ বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                label: "তথ্য সংরক্ষণ করুন",
                icon: Icons.save,
                isLoading: employeeProvider.isLoading,
                onPressed: () => _handleSave(context, employeeProvider),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  void _handleSave(BuildContext context, EmployeeProvider provider) async {
    if (_nameController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        message: "* নাম, মোবাইল এবং ঠিকানা অবশ্যই পূরণ করুন",
        isSuccess: false,
        icon: Icons.error_outline,
      );
      return;
    }

    final String? userToken = context.read<AuthProvider>().token;
    if (userToken == null) {
      CustomSnackBar.show(
        context,
        message: "সেশন শেষ হয়ে গেছে! অনুগ্রহ করে আবার লগইন করুন।",
        isSuccess: false,
        icon: Icons.lock_outline,
      );
      return;
    }

    final employeeModel = EmployeeModel(
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      nid: _nidController.text.trim(),
      dob: _dobController.text.trim(),
      mobile: _mobileController.text.trim(),
      address: _addressController.text.trim(),
    );

    final result = await provider.addEmployee(
      employeeData: employeeModel.toMap(),
      userToken: userToken,
      imageFile: _imageNotifier.value,
    );

    if (context.mounted) {
      if (result['success'] == true) {
        CustomSnackBar.show(
          context,
          message: result['message'] ?? "কর্মচারী সফলভাবে যোগ করা হয়েছে",
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushReplacementNamed(context, '/employee-list-table');
      }
      // else {
      //   CustomSnackBar.show(
      //     context,
      //     message: result['message'],
      //     isSuccess: false,
      //     icon: Icons.gpp_bad_outlined,
      //   );
      // }
    }
  }
}

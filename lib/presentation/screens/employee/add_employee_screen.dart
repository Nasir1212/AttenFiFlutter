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
import '../../../l10n/app_localizations.dart';
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      _dobController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = context.watch<EmployeeProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          l10n.addEmployeeTitle,
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
              label: l10n.employeeName,
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            InputField(
              label: l10n.fatherName,
              controller: _fatherNameController,
              icon: Icons.person_search,
            ),
            const SizedBox(height: 15),
            InputField(
              label: l10n.motherName,
              controller: _motherNameController,
              icon: Icons.person_search,
            ),
            const SizedBox(height: 15),
            InputField(
              label: l10n.nidNumber,
              controller: _nidController,
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: InputField(
                  label: l10n.dateOfBirth,
                  controller: _dobController,
                  icon: Icons.calendar_today,
                  hint: l10n.dobHint,
                ),
              ),
            ),
            const SizedBox(height: 15),

            InputField(
              label: l10n.mobileNumber,
              controller: _mobileController,
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            InputField(
              label: l10n.fullAddress,
              controller: _addressController,
              icon: Icons.home,
            ),
            const SizedBox(height: 40),

            // সেভ বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                label: l10n.saveInformation,
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
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        message: l10n.validationRequiredFields,
        isSuccess: false,
        icon: Icons.error_outline,
      );
      return;
    }

    final String? userToken = context.read<AuthProvider>().token;
    if (userToken == null) {
      CustomSnackBar.show(
        context,
        message: l10n.sessionExpiredMessage,
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
          message: result['message'] ?? l10n.employeeAddedSuccess,
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushReplacementNamed(context, '/employee-list-table');
      }
    }
  }
}

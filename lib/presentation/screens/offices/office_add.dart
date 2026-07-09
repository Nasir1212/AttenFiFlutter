import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import '../../../core/model/office_model.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/primary_button.dart';

class OfficeAddScreen extends StatelessWidget {
  OfficeAddScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController graceTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final String? userToken = context.read<AuthProvider>().token;
    if (userToken == null) return;

    // লোডিং ডায়ালগ
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await context.read<OfficeProvider>().addOffice(
      token: userToken,
      office: OfficeModel(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        startTime: startTimeController.text.trim(),
        graceTime: graceTimeController.text.trim(),
        endTime: endTimeController.text.trim(),
        id: 0,
      ),
    );

    if (context.mounted) Navigator.pop(context); // লোডিং বন্ধ

    if (result['success'] == true) {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: "নতুন অফিস সফলভাবে যুক্ত হয়েছে!",
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushNamed(context, '/office-list');
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: result['message'] ?? "অফিস যুক্ত করতে সমস্যা হয়েছে",
          isSuccess: false,
          icon: Icons.error_outline,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "নতুন অফিস যুক্ত করুন",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.corporate_fare,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 30),

              InputField(
                label: "অফিস/শাখার নাম",
                controller: _nameController,
                icon: Icons.business,
                hint: "উদা: চট্টগ্রাম শাখা, জিইসি",
                validator: (val) => val == null || val.trim().isEmpty
                    ? "অফিসের নাম আবশ্যক"
                    : null,
              ),
              const SizedBox(height: 20),

              InputField(
                label: "অফিসের ঠিকানা",
                controller: _addressController,
                icon: Icons.location_on_outlined,
                hint: "উদা: রোড #২, হাউজ #৪৫, ওআর নিজাম রোড",
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty
                    ? "অফিসের ঠিকানা আবশ্যক"
                    : null,
              ),

              const SizedBox(height: 25),
              InputField(
                label: "অফিসের শুরুর সময়",
                controller: startTimeController,
                icon: Icons.access_time_filled_rounded,
                hint: "উদা: 09:00:00",
                validator: (val) => val == null || val.trim().isEmpty
                    ? "অফিসের শুরুর সময় আবশ্যক"
                    : null,
              ),
              const SizedBox(height: 25),
              InputField(
                label: "লেট ট্র্যাকিং কত মিনিট ?",
                controller: graceTimeController,
                icon: Icons.running_with_errors_rounded,
                hint: "উদা: 09:15:00",
                validator: (val) => val == null || val.trim().isEmpty
                    ? "লেট ট্র্যাকিং সময় আবশ্যক"
                    : null,
              ),
              const SizedBox(height: 25),
              InputField(
                label: "অফিসের ছুটির সময়",
                controller: endTimeController,
                icon: Icons.access_time_filled_rounded,
                hint: "17:00:00",
                validator: (val) => val == null || val.trim().isEmpty
                    ? "অফিসের ছুটির সময় আবশ্যক"
                    : null,
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: PrimaryButton(
                  label: "অফিস সংরক্ষণ করুন",
                  icon: Icons.save,
                  onPressed: () => _submitForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }
}

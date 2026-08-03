import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import '../../../core/model/office_model.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
          message: l10n.officeAddedSuccess,
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
        Navigator.pushNamed(context, '/office-list');
      }
    } else {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: result['message'] ?? l10n.officeAddError,
          isSuccess: false,
          icon: Icons.error_outline,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const Color primaryColor = Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          l10n.addOfficeTitle,
          style: const TextStyle(color: Colors.white),
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
                label: l10n.officeNameLabel,
                controller: _nameController,
                icon: Icons.business,
                hint: l10n.officeNameHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.officeNameRequired
                    : null,
              ),
              const SizedBox(height: 20),

              InputField(
                label: l10n.officeAddressLabel,
                controller: _addressController,
                icon: Icons.location_on_outlined,
                hint: l10n.officeAddressHint,
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.officeAddressRequired
                    : null,
              ),

              const SizedBox(height: 25),
              InputField(
                label: l10n.officeStartTimeLabel,
                controller: startTimeController,
                icon: Icons.access_time_filled_rounded,
                hint: l10n.officeStartTimeHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.officeStartTimeRequired
                    : null,
              ),
              const SizedBox(height: 25),
              InputField(
                label: l10n.lateTrackingLabel,
                controller: graceTimeController,
                icon: Icons.running_with_errors_rounded,
                hint: l10n.lateTrackingHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.lateTrackingRequired
                    : null,
              ),
              const SizedBox(height: 25),
              InputField(
                label: l10n.officeEndTimeLabel,
                controller: endTimeController,
                icon: Icons.access_time_filled_rounded,
                hint: l10n.officeEndTimeHint,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.officeEndTimeRequired
                    : null,
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: PrimaryButton(
                  label: l10n.saveOfficeButton,
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

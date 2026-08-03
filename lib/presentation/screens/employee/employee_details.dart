import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/model/employee_model.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../l10n/app_localizations.dart';

import '../../widgets/custom_ad_bottom_bar.dart';

class EmployeeDetails extends StatelessWidget {
  const EmployeeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ১. আগের স্ক্রিন থেকে পাঠানো কর্মচারীর অবজেক্টটি আর্গুমেন্ট হিসেবে রিসিভ করা
    final employee =
        ModalRoute.of(context)!.settings.arguments as EmployeeModel;

    // ছবি লোড করার হেডার পাসের জন্য টোকেনটি নিয়ে রাখা
    final String userToken = context.read<AuthProvider>().token ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          l10n.employeeDetailsTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // প্রোফাইল পিকচার এবং উপরের ব্যানার অংশ
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  // ডাইনামিক প্রোফাইল ইমেজ (Cached Network Image সহ)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        employee.imageUrl != null &&
                            employee.imageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(
                            employee.imageUrl!,
                            headers: {
                              'ngrok-skip-browser-warning': 'true',
                              'Authorization': 'Bearer $userToken',
                            },
                          )
                        : null,
                    child:
                        employee.imageUrl == null ||
                            employee.imageUrl!.isNotEmpty == false
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),

                  // ডাইনামিক নাম
                  Text(
                    employee.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // পদবি
                  Text(
                    l10n.employeeRole,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // তথ্যের কার্ডসমূহ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // প্রাতিষ্ঠানিক তথ্য
                  _buildInfoCard(context, l10n.institutionalInfo, [
                    _buildInfoRow(
                      Icons.badge_outlined,
                      l10n.employeeId,
                      employee.employeeId != null &&
                              employee.employeeId!.isNotEmpty
                          ? employee.employeeId!
                          : l10n.idNotFound,
                    ),
                  ]),
                  const SizedBox(height: 15),

                  // ব্যক্তিগত তথ্য
                  _buildInfoCard(context, l10n.personalInfo, [
                    _buildInfoRow(
                      Icons.person_outline,
                      l10n.fatherName,
                      employee.fatherName != null &&
                              employee.fatherName!.isNotEmpty
                          ? employee.fatherName!
                          : l10n.notSpecified,
                    ),
                    _buildInfoRow(
                      Icons.person_outline,
                      l10n.motherName,
                      employee.motherName != null &&
                              employee.motherName!.isNotEmpty
                          ? employee.motherName!
                          : l10n.notSpecified,
                    ),
                    _buildInfoRow(
                      Icons.calendar_month,
                      l10n.dateOfBirth,
                      employee.dob != null && employee.dob!.isNotEmpty
                          ? employee.dob!
                          : l10n.notSpecified,
                    ),
                    _buildInfoRow(
                      Icons.credit_card,
                      l10n.nidNumber,
                      employee.nid != null && employee.nid!.isNotEmpty
                          ? employee.nid!
                          : l10n.notSpecified,
                    ),
                  ]),
                  const SizedBox(height: 15),

                  // যোগাযোগের তথ্য
                  _buildInfoCard(context, l10n.contactInfo, [
                    _buildInfoRow(
                      Icons.phone_android,
                      l10n.mobileNumber,
                      employee.mobile,
                    ),
                    _buildInfoRow(
                      Icons.home_outlined,
                      l10n.fullAddress,
                      employee.address != null && employee.address!.isNotEmpty
                          ? employee.address!
                          : l10n.notSpecified,
                    ),
                  ]),
                  const SizedBox(height: 30),

                  // এডিট বাটন
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit-employee',
                          arguments: employee,
                        );
                      },
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      label: Text(
                        l10n.editInformation,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  // তথ্য দেখানোর কার্ড উইজেট বিল্ডার
  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 25),
          ...children,
        ],
      ),
    );
  }

  // তথ্যের প্রতিটি রো (Row)
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.7)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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

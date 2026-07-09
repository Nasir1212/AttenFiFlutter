import 'dart:convert';
import 'package:atten_fi/presentation/widgets/bottom_navItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/model/employee_model.dart';
import '../../../../core/providers/attendance_provider.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  // 🔄 প্রোফাইল ডাটা রিফ্রেশ করার মেথড
  Future<void> _handleRefresh(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      final attendance = context.read<AttendanceProvider>();
      // সার্ভার থেকে নতুন প্রোফাইল ডাটা ফেচ করবে
      await attendance.refreshProfileFromServer(token);
    }
  }

  // 💾 শ্যারেড প্রেফারেন্স থেকে প্রোফাইল ডাটা পার্স করার হেল্পার
  EmployeeModel? _getEmployeeFromPrefs(String? profileStr) {
    if (profileStr == null || profileStr.isEmpty) return null;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(profileStr);
      return EmployeeModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // 🎯 প্রোভাইডার ওয়াচ করা হচ্ছে যাতে ডাটা চেঞ্জ হলে ইউআই অটো আপডেট হয়
    context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "আমার প্রোফাইল",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 65,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                icon: Icons.home_rounded,
                label: "হোম",
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/user-dashboard');
                },
              ),
              BottomNavItem(
                icon: Icons.history_rounded,
                label: "হিস্ট্রি",
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.person,
                label: "প্রোফাইল",
                color: primaryColor,
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, '/employee_profile');
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final prefs = snapshot.data!;
          final String? profileStr = prefs.getString('user_profile');
          final employee = _getEmployeeFromPrefs(profileStr);

          // 🎯 আপনার নতুন EmployeeModel অনুযায়ী ডেটা ম্যাপিং ও নাল হ্যান্ডলিং
          String name = employee?.name ?? "পরিচিত কর্মী";
          String empId =
              employee?.employeeId == null || employee!.employeeId!.isEmpty
              ? "N/A"
              : employee.employeeId!;
          String mobile = employee?.mobile ?? "মোবাইল নম্বর পাওয়া যায়নি";
          String fatherName = employee?.fatherName ?? "তথ্য নেই";
          String motherName = employee?.motherName ?? "তথ্য নেই";
          String nid = employee?.nid ?? "তথ্য নেই";
          String dob = employee?.dob ?? "তথ্য নেই";
          String address =
              employee?.address == null || employee!.address!.isEmpty
              ? "ঠিকানা পাওয়া যায়নি"
              : employee.address!;
          String? imageUrl = employee?.imageUrl;

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => _handleRefresh(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // 👤 ১. প্রোফাইল হেডার কার্ড (টপ সেকশন)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              imageUrl != null && imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl == null || imageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[600],
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 📝 ২. নাম ও আইডি
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "আইডি: $empId",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📋 ৩. নতুন মডেল অনুযায়ী ডিটেইলস ইনফরমেশন লিস্ট
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              icon: Icons.phone_android_outlined,
                              title: "মোবাইল নম্বর",
                              value: mobile,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              icon: Icons.credit_card_outlined,
                              title: "এনআইডি (NID)",
                              value: nid,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              icon: Icons.cake_outlined,
                              title: "জন্ম তারিখ",
                              value: dob,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              icon: Icons.person_outline_rounded,
                              title: "পিতার নাম",
                              value: fatherName,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              icon: Icons.person_outline_rounded,
                              title: "মাতার নাম",
                              value: motherName,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              icon: Icons.location_on_outlined,
                              title: "বর্তমান ঠিকানা",
                              value: address,
                              iconColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🛠️ প্রতিটি তথ্যের রো (Row) তৈরি করার হেল্পার উইজেট
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // লম্বা ঠিকানার জন্য টপ অ্যালাইন করা হয়েছে
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? "তথ্য নেই" : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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

// 📏 কাস্টম লাইট ডিভাইডার
class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64.0, right: 16.0),
      child: Divider(height: 1, thickness: 0.5, color: Colors.grey[200]),
    );
  }
}

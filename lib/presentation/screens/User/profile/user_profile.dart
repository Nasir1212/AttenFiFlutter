import 'dart:convert';
import 'package:atten_fi/presentation/widgets/bottom_navItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/model/employee_model.dart';
import '../../../../core/providers/attendance_provider.dart';
import '../../../../l10n/app_localizations.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  // 🌐 অ্যাপের বেস URL এর সাথে 'eps' সাব-পাথ (প্রয়োজনে পরিবর্তন করুন)
  static const String _baseUrl = 'https://your-domain.com/eps';

  // 🔄 প্রোফাইল ডাটা রিফ্রেশ করার মেথড
  Future<void> _handleRefresh(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null && context.mounted) {
      final attendance = context.read<AttendanceProvider>();
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

  // 🖼️ URL ফরম্যাটিং
  String? _getFormattedImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }
    final formattedPath = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '$_baseUrl$formattedPath';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.eps_profile_title,
          style: const TextStyle(
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
                label: l10n.eps_nav_home,
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/user-dashboard');
                },
              ),
              BottomNavItem(
                icon: Icons.history_rounded,
                label: l10n.eps_nav_history,
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.person,
                label: l10n.eps_nav_profile,
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

          // 🎯 লকালাইজেশন সহ ডেটা ম্যাপিং
          String name = employee?.name ?? l10n.eps_default_name;
          String empId =
              (employee?.employeeId == null || employee!.employeeId!.isEmpty)
              ? l10n.eps_not_available
              : employee.employeeId!;
          String mobile = employee?.mobile ?? l10n.eps_mobile_not_found;
          String fatherName = employee?.fatherName ?? l10n.eps_no_info;
          String motherName = employee?.motherName ?? l10n.eps_no_info;
          String nid = employee?.nid ?? l10n.eps_no_info;
          String dob = employee?.dob ?? l10n.eps_no_info;
          String address =
              (employee?.address == null || employee!.address!.isEmpty)
              ? l10n.eps_address_not_found
              : employee.address!;

          String? imageUrl = _getFormattedImageUrl(employee?.imageUrl);

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => _handleRefresh(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // 👤 ১. প্রোফাইল হেডার
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
                    l10n.eps_id_label(empId),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📋 ৩. ডিটেইলস ইনফরমেশন লিস্ট
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
                              context: context,
                              icon: Icons.phone_android_outlined,
                              title: l10n.eps_label_mobile,
                              value: mobile,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              context: context,
                              icon: Icons.credit_card_outlined,
                              title: l10n.eps_label_nid,
                              value: nid,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              context: context,
                              icon: Icons.cake_outlined,
                              title: l10n.eps_label_dob,
                              value: dob,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              context: context,
                              icon: Icons.person_outline_rounded,
                              title: l10n.eps_label_father_name,
                              value: fatherName,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              context: context,
                              icon: Icons.person_outline_rounded,
                              title: l10n.eps_label_mother_name,
                              value: motherName,
                              iconColor: primaryColor,
                            ),
                            const _CustomDivider(),
                            _buildInfoTile(
                              context: context,
                              icon: Icons.location_on_outlined,
                              title: l10n.eps_label_address,
                              value: address,
                              iconColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🛠️ ইনফরমেশন রো
  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  value.isEmpty ? l10n.eps_no_info : value,
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

// 📏 কাস্টম ডিভাইডার
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

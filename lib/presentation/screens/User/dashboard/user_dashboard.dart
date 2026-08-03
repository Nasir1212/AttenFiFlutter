import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atten_fi/core/constants/app_colors.dart';
import '../../../../core/model/employee_model.dart';
import '../../../../core/providers/attendance_provider.dart';
import '../../../../core/providers/auth_provider.dart' show AuthProvider;
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/bottom_navItem.dart';
import '../../role_selection_screen.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  // 🔄 রিফ্রেশ ইন্ডিকেটরের জন্য অ্যাসিনক্রোনাস মেথড
  Future<void> _handleRefresh(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      // context.read ব্যবহার করা হয়েছে কারণ এটি একটি মেথডের ভেতর ক্লিক অ্যাকশন
      final attendance = context.read<AttendanceProvider>();

      // 🎯 'await' দেওয়ার কারণে এপিআই রেসপন্স না আসা পর্যন্ত রিফ্রেশ স্পিনার ঘুরবে
      await attendance.fetchTodayLogs(token);
      await attendance.refreshProfileFromServer(token);
      await attendance.fetchMonthlyReport(token);

      // নোট: আপনার refreshProfileFromServer(token) মেথডটির শেষে
      // অবশ্যই `notifyListeners();` কল করা থাকতে হবে, যাতে ড্যাশবোর্ড নতুন ডাটা পায়।
    }
  }

  // 💾 লোকাল শ্যারেড প্রেফারেন্স থেকে প্রোফাইল ডাটা পার্স করার হেল্পার মেথড
  EmployeeModel? _getEmployeeFromPrefs(String? profileStr) {
    if (profileStr == null || profileStr.isEmpty) return null;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(profileStr);
      return EmployeeModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  void _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // 📋 লগআউট করার আগে ইউজারকে কনফার্মেশন ডায়ালগ দেখানো
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // ডায়ালগের বাইরে ক্লিক করলে যেন বন্ধ না হয়
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.logout_rounded, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                l10n.logoutConfirmTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(l10n.logoutConfirmMessage),
          actions: [
            // না বাটন
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.noButton,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // হ্যাঁ বাটন
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                l10n.yesLogoutButton,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    // ইউজার যদি 'না' চাপে বা ডায়ালগ ক্যানসেল করে, তবে এখানেই ফাংশন শেষ
    if (confirmLogout != true) return;

    // 🔄 লোডিং ডায়ালগ দেখানো (প্রসেস হওয়ার সময় ইউজার যেন স্ক্রিনে অন্য কোথাও চাপ না দিতে পারে)
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 🔑 প্রোভাইডার থেকে টোকেন নিয়ে লগআউট মেথড কল করা
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String currentToken = authProvider.token ?? "";

    bool isLoggedOut = await authProvider.logout(currentToken);

    // লোডিং ইন্ডিকেটর বন্ধ করা
    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (isLoggedOut) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        (route) => false,
      );
    } else {
      // কোনো কারণে API এরর আসলে ইউজারকে মেসেজ দেখানো
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.logoutError), backgroundColor: Colors.red),
      );
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 14)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    // 🎯 context.watch ব্যবহারের ফলে প্রোভাইডারে notifyListeners() কল হওয়ামাত্র ড্যাশবোর্ড অটো রিফ্রেশ হবে
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.userDashboardTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_important, color: Colors.white),
            onPressed: () {},
          ),
          Builder(
            builder: (innerContext) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(innerContext).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),

      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🏢 ১. মিনিমালিস্ট লোগো হেডার (শুধুমাত্র লোগো)
            Container(
              padding: const EdgeInsets.fromLTRB(70, 60, 70, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withOpacity(0.85)],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),

            // 📋 ২. মেনু আইটেম লিস্ট
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                children: [
                  // --- সেকশন ১: ব্যক্তিগত ও ট্র্যাকিং ---
                  _buildSectionTitle(
                    AppLocalizations.of(context)!.personalTrackingSection,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: AppLocalizations.of(context)!.myProfileMenu,
                    iconColor: primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/employee_profile');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history_toggle_off_rounded,
                    label: AppLocalizations.of(context)!.attendanceHistoryMenu,
                    iconColor: primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/attendance_history');
                    },
                  ),

                  const SizedBox(height: 12),
                  // --- সেকশন ২: আবেদন ও অনুরোধ ---
                  _buildSectionTitle(
                    AppLocalizations.of(context)!.applicationsSection,
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    label: AppLocalizations.of(context)!.leaveApplicationMenu,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.pushNamed(context, '/leave_application');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.more_time_rounded,
                    label: AppLocalizations.of(context)!.lateCondonationMenu,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),
                  // --- সেকশন ৩: অন্যান্য ও সাপোর্ট ---
                  _buildSectionTitle(
                    AppLocalizations.of(context)!.othersSection,
                  ),
                  _buildDrawerItem(
                    icon: Icons.gavel_rounded,
                    label: AppLocalizations.of(context)!.companyPolicyMenu,
                    iconColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent_rounded,
                    label: AppLocalizations.of(context)!.helpAndSupportMenu,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 12,
                    ),
                    child: Divider(height: 1),
                  ),

                  // --- লগআউট বাটন ---
                  _buildDrawerItem(
                    icon: Icons.logout_rounded,
                    label: AppLocalizations.of(context)!.logoutMenu,
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    tileColor: Colors.red.shade50,
                    onTap: () {
                      Navigator.pop(context);
                      _logout(context);
                    },
                  ),
                ],
              ),
            ),

            // 📱 ৩. ফুটার ব্র্যান্ডিং
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.appVersion,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                label: AppLocalizations.of(context)!.navHome,
                color: primaryColor,
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.history_rounded,
                label: AppLocalizations.of(context)!.navHistory,
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.person,
                label: AppLocalizations.of(context)!.navProfile,
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/employee_profile');
                },
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final l10n = AppLocalizations.of(context)!;
            final prefs = snapshot.data!;
            final String? profileStr = prefs.getString('user_profile');
            final employee = _getEmployeeFromPrefs(profileStr);

            String name = employee?.name ?? l10n.defaultEmployeeName;
            String empId = employee?.employeeId ?? "...";
            String? imageUrl = employee?.imageUrl;

            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () => _handleRefresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // 👋 ১. প্রোফাইল কার্ড
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            backgroundImage:
                                imageUrl != null && imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : null,
                            child: imageUrl == null || imageUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 35,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.idLabel(empId),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📊 ২. রিপোর্ট সেকশন
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.monthlyReportTitle("May 2026"),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Icon(
                                Icons.trending_up_rounded,
                                size: 16,
                                color: secondaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatCard(
                                l10n.statPresent,
                                l10n.daysCount(provider.totalPresentDays),
                                Colors.green[50]!,
                                Colors.green,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                l10n.statLate,
                                l10n.daysCount(provider.totalLateDays),
                                Colors.orange[50]!,
                                Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              _buildStatCard(
                                l10n.statLeave,
                                l10n.daysCount(provider.totalLeaveDays),
                                Colors.red[50]!,
                                Colors.redAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 📢 ৩. নোটিশ বোর্ড
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.campaign_rounded,
                              color: Colors.blue[800],
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.latestNotice,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.noticeContent,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔘 ৪. হোল্ড বাটন সেকশন
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTapDown: (_) async {
                              if (provider.isLoading) return;

                              for (int i = 1; i <= 20; i++) {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                if (provider.animationProgress == -1.0) break;
                                provider.updateProgress(i / 20);
                              }

                              if (provider.animationProgress == 1.0) {
                                provider.updateProgress(0.0);
                                if (context.mounted) {
                                  final String? token = prefs.getString(
                                    'auth_token',
                                  );
                                  String? wifiBssid = await NetworkInfo()
                                      .getWifiBSSID();

                                  if (token == null) {
                                    _showSnackBar(
                                      context,
                                      l10n.sessionExpired,
                                      isError: true,
                                    );
                                    _logout(context);
                                    return;
                                  }

                                  final result = await provider
                                      .submitAttendance(
                                        wifiBssid: wifiBssid ?? '',
                                        userToken: token,
                                      );

                                  if (context.mounted) {
                                    _showSnackBar(
                                      context,
                                      result['message'],
                                      isError: !result['success'],
                                    );
                                  }
                                }
                              }
                            },
                            onTapUp: (_) {
                              provider.updateProgress(-1.0);
                              Future.delayed(
                                const Duration(milliseconds: 50),
                                () {
                                  provider.updateProgress(0.0);
                                },
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: CircularProgressIndicator(
                                    value: provider.animationProgress < 0
                                        ? 0
                                        : provider.animationProgress,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      provider.isCheckedIn
                                          ? Colors.orangeAccent
                                          : secondaryColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: provider.isLoading
                                        ? Colors.grey
                                        : (provider.isCheckedIn
                                              ? Colors.redAccent
                                              : primaryColor),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (provider.isCheckedIn
                                                    ? Colors.redAccent
                                                    : primaryColor)
                                                .withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: provider.isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              provider.isCheckedIn
                                                  ? Icons.logout_rounded
                                                  : Icons.fingerprint_rounded,
                                              size: 36,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              provider.isCheckedIn
                                                  ? l10n.checkOutUpper
                                                  : l10n.checkInUpper,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.isLoading
                                ? l10n.processingWait
                                : (provider.isCheckedIn
                                      ? l10n.holdToCheckOut
                                      : l10n.holdToCheckIn),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📋 ৫. আজকের টাইমলাইন
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        elevation: 0,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    size: 16,
                                    color: secondaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.todayLogsTitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16, thickness: 1),
                              provider.todayLogs.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                        ),
                                        child: Text(
                                          l10n.noAttendanceToday,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: provider.todayLogs.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 5,
                                                color: primaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                provider.todayLogs[index],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // সেকশন টাইটেল তৈরীর জন্য (যেমন: ব্যক্তিগত ট্র্যাকিং, আবেদন ও অনুরোধ)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // প্রফেশনাল মেনু আইটেম উইজেট
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    Color? textColor,
    Color? tileColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: tileColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(
          vertical: -2,
        ), // টাইট ক্লিনের জন্য হাইট কমানো হয়েছে
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: textColor?.withOpacity(0.5) ?? Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }
}

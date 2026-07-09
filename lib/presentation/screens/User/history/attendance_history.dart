import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/attendance_provider.dart';
import '../../../widgets/bottom_navItem.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  // 🔄 স্ক্রিন প্রথমবার ওপেন হওয়ার সময় টোকেন নিয়ে ডাটা লোড করার মেথড
  Future<void> _loadHistoryData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken != null && context.mounted) {
      // সার্ভার থেকে চলতি মাসের হিস্ট্রি ডাটা ফেচ করা
      context.read<AttendanceProvider>().fetchAttendanceHistory(
        userToken: authToken,
      );
    }
  }

  // 🗓️ শুধু গত ৩ মাসের নাম ও দিন ফিল্টার করার কাস্টম বটম শিট
  Future<void> _selectMonthYear(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken == null) return;

    final now = DateTime.now();

    // 🎯 গত ৩ মাসের ডাটা তৈরি করা (চলতি মাস, ১ মাস আগে, ২ মাস আগে)
    final List<DateTime> monthsList = List.generate(3, (index) {
      return DateTime(now.year, now.month - index, 1);
    });

    // 🇧🇩 বাংলা মাসের নামের ম্যাপ
    final Map<int, String> banglaMonths = {
      1: 'জানুয়ারি',
      2: 'ফেব্রুয়ারি',
      3: 'মার্চ',
      4: 'এপ্রিল',
      5: 'মে',
      6: 'জুন',
      7: 'জুলাই',
      8: 'আগস্ট',
      9: 'সেপ্টেম্বর',
      10: 'অক্টোবর',
      11: 'নভেম্বর',
      12: 'ডিসেম্বর',
    };

    if (!context.mounted) return;

    // 🔝 সুন্দর একটি বটম শিট ওপেন হবে মাস সিলেক্ট করার জন্য
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'মাস নির্বাচন করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: monthsList.length,
                itemBuilder: (ctx, index) {
                  final monthDate = monthsList[index];
                  final monthName = banglaMonths[monthDate.month] ?? '';

                  return ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    title: Text(
                      monthName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      context.read<AttendanceProvider>().fetchAttendanceHistory(
                        userToken: authToken,
                        month: monthDate.month,
                        year: monthDate.year,
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final accentColor = theme.colorScheme.secondary;

    // 🚀 প্রথমবার বিল্ড হওয়ার সময় ডাটা লোড করার ট্রিগার
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistoryData(context);
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'হাজিরা হিস্ট্রি',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_rounded, color: accentColor),
            onPressed: () => _selectMonthYear(context),
          ),
        ],
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
                color: primaryColor,
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.person,
                label: "প্রোফাইল",
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
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          final reportTitle = provider.currentMonthText;

          // 💡 Column-কে বাইরে রেখে শুধু স্ক্রলযোগ্য কন্টেন্টকে RefreshIndicator-এর ভেতরে দেওয়া হয়েছে
          return Column(
            children: [
              // ১. ওপরের মিনি সামারি কার্ড (স্থির থাকবে)
              _buildMiniSummarySection(
                reportTitle: reportTitle,
                present: "${provider.totalPresentDays} দিন",
                late: "${provider.totalLateDays} দিন",
                leave: "${provider.totalLeaveDays} দিন",
              ),

              // ২. ফিল্টার চিপস সেকশন (স্থির থাকবে)
              _buildFilterSection(
                accentColor,
                provider.selectedFilter,
                provider,
              ),

              const SizedBox(height: 10),

              // ৩. প্রধান হিস্ট্রি লিস্ট ভিউ (যা স্ক্রল হবে এবং টান দিলে রিফ্রেশ হবে)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final authToken = prefs.getString('auth_token');

                    if (authToken != null && context.mounted) {
                      // ডাটা রি-ফেচ করার এপিআই কল (ফিউচার কমপ্লিট হওয়া পর্যন্ত স্পিনার ঘুরবে)
                      await context
                          .read<AttendanceProvider>()
                          .fetchAttendanceHistory(
                            userToken: authToken,
                            // প্রোভাইডারে যদি লাস্ট সিলেক্টেড মাস-বছর স্টোর করা থাকে তবে এভাবে পাঠাতে পারেন:
                            // month: provider.selectedMonth,
                            // year: provider.selectedYear,
                          );
                    }
                  },
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Builder(
                          builder: (context) {
                            final filteredLogs =
                                provider.filteredAttendanceHistory;

                            // ডাটা ফেস খালি থাকলেও যেন টান দিয়ে রিফ্রেশ করা যায়
                            if (filteredLogs.isEmpty) {
                              return ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      'এই ক্যাটাগরিতে কোনো হাজিরা রেকর্ড নেই।',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.builder(
                              // ↕️ ডাটা স্ক্রিনের চেয়ে কম হলেও যেন সবসময় রিফ্রেশ কাজ করে
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filteredLogs.length,
                              itemBuilder: (context, index) {
                                final log = filteredLogs[index];
                                return _buildHistoryCard(
                                  context,
                                  (log['status'] ?? 'Present') as String,
                                  (log['date'] ?? '') as String,
                                  (log['in'] ?? '--:--') as String,
                                  (log['out'] ?? '--:--') as String,
                                  (log['hours'] ?? '০ ঘণ্টা') as String,
                                  (log['wifi'] ?? '-') as String,
                                  (log['isLate'] ?? false) as bool,
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 📊 ১. মিনি সামারি উইজেট
  Widget _buildMiniSummarySection({
    required String reportTitle,
    required String present,
    required String late,
    required String leave,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reportTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem("✅ উপস্থিত", present, Colors.green),
              _buildSummaryItem("⚠️ লেট", late, Colors.orange),
              _buildSummaryItem("❌ ছুটি", leave, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // 🔍 ২. ফিল্টার সেকশন উইজেট
  Widget _buildFilterSection(
    Color accentColor,
    String currentFilter,
    AttendanceProvider provider,
  ) {
    final List<String> filters = ['All', 'Present', 'Late', 'Leave'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                filter == 'All'
                    ? 'সব দিন'
                    : filter == 'Present'
                    ? 'উপস্থিত'
                    : filter == 'Late'
                    ? 'লেট'
                    : 'ছুটি',
              ),
              selected: isSelected,
              selectedColor: accentColor.withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected ? accentColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? accentColor : Colors.grey[200]!,
              ),
              onSelected: (bool selected) {
                if (selected) {
                  provider.setFilter(filter);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // 📅 ৩. হিস্ট্রিカード উইজেট
  Widget _buildHistoryCard(
    BuildContext context,
    String status,
    String date,
    String checkIn,
    String checkOut,
    String totalHours,
    String wifiName,
    bool isLate,
  ) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case "Present":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        statusText = "Present";
        break;
      case "Late":
        statusColor = Colors.orange;
        statusIcon = Icons.warning_rounded;
        statusText = "Late";
        break;
      default:
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_rounded;
        statusText = "Leave";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeRow(
                      Icons.login_rounded,
                      "ইন টাইম",
                      checkIn,
                      isLate ? Colors.orange : Colors.grey[700]!,
                    ),
                    const SizedBox(height: 8),
                    _buildTimeRow(
                      Icons.logout_rounded,
                      "আউট টাইম",
                      checkOut,
                      Colors.grey[700]!,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          totalHours,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.wifi_rounded,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          wifiName,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(
    IconData icon,
    String label,
    String time,
    Color timeColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: timeColor,
          ),
        ),
      ],
    );
  }
}

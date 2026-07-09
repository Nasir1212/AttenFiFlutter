import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/providers/attendance_provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _handleLogout(BuildContext context) async {
    final String? token = context.read<AuthProvider>().token;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('লগআউট নিশ্চিত করুন'),
          content: const Text(
            'আপনি কি নিশ্চিতভাবেই অ্যাকাউন্ট থেকে লগআউট করতে চান?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('না', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  context.read<AuthProvider>().logout(token!);
                } catch (e) {
                  print("লগআউট এপিআই-তে সমস্যা: $e");
                }

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'হ্যাঁ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // স্ক্রিন ওপেন হওয়ামাত্র টোকেন রিড করে সার্ভার থেকে ডাইনামিক ডাটা পুল করবে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchAdminDashboardData();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AttenFI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "অ্যাডমিন/ম্যানেজার",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Log Out',
            onPressed: () => _handleLogout(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchAdminDashboardData(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "আজকের পরিসংখ্যান",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Statistics Grid (ডাইনামিক ডাটা অ্যাসাইন করা হয়েছে)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        "মোট কর্মচারী",
                        provider.adminStats["total"] ?? "0",
                        Icons.groups,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        "উপস্থিত",
                        provider.adminStats["present"] ?? "0",
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        "অনুপস্থিত",
                        provider.adminStats["absent"] ?? "0",
                        Icons.cancel,
                        Colors.red,
                      ),
                      _buildStatCard(
                        "দেরি (Late)",
                        provider.adminStats["late"] ?? "0",
                        Icons.access_time,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "কুইক অ্যাকশন",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Action Buttons (আপনার অরিজিনাল মেনু স্ট্রাকচার)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(Icons.person, " স্টাফ", () {
                          Navigator.pushNamed(context, '/employee-list-table');
                        }),
                        _buildActionButton(Icons.router, "রাউটার", () {
                          Navigator.pushNamed(context, '/wifi-list');
                        }),
                        _buildActionButton(Icons.bar_chart, "রিপোর্ট", () {
                          Navigator.pushNamed(
                            context,
                            '/employee-report-table',
                          );
                        }),
                        _buildActionButton(Icons.table_chart, "অফিস", () {
                          Navigator.pushNamed(context, '/office-list');
                        }),
                        _buildActionButton(Icons.holiday_village, "ছুটি", () {
                          Navigator.pushNamed(context, '/holiday');
                        }),

                        _buildActionButton(Icons.code, "ওটিপি", () {
                          Navigator.pushNamed(context, '/admin-otp');
                        }),
                        _buildActionButton(Icons.settings, "সেটিংস", () {
                          Navigator.pushNamed(context, '/settings');
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Recent Attendance List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "সাম্প্রতিক উপস্থিতি",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "সব দেখুন",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ডাইনামিক সাম্প্রতিক হাজিরার তালিকা জেনারেটর
                  provider.recentAttendanceList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Text(
                              "আজকে এখনও কোনো হাজিরার লগ নেই।",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.recentAttendanceList.length,
                          itemBuilder: (context, index) {
                            final log = provider.recentAttendanceList[index];

                            // স্ট্যাটাস টাইপ অনুযায়ী ডাইনামিক কালার সিলেকশন
                            Color statusColor = Colors.green;
                            if (log['status_type'] == 'Late') {
                              statusColor = Colors.orange;
                            } else if (log['status_type'] == 'Absent') {
                              statusColor = Colors.red;
                            }

                            return _buildRecentAttendance(
                              log['name'] ?? "অজানা",
                              log['time'] ?? "--:-- AM",
                              log['status'] ?? "সময়মতো",
                              statusColor,
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  // সাম্প্রতিক উপস্থিতি লিস্ট আইটেম (আপনার অরিজিনাল ডিজাইন উইজেট)
  Widget _buildRecentAttendance(
    String name,
    String time,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0] : "?",
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "সময়: $time",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // স্ট্যাট কার্ড (আপনার অরিজিনাল ডিজাইন উইজেট)
  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: color.withOpacity(0.5), size: 20),
            ],
          ),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  // কুইক অ্যাকশন বাটন (আপনার অরিজিনাল ডিজাইন উইজেট)
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFF1A237E)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

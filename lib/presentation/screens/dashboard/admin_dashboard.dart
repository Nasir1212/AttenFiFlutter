import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/providers/attendance_provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/custom_ad_bottom_bar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _handleLogout(BuildContext context) async {
    final String? token = context.read<AuthProvider>().token;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(l10n.logoutConfirmTitle),
          content: Text(l10n.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.no, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  context.read<AuthProvider>().logout(token!);
                } catch (e) {
                  debugPrint("লগআউট এপিআই-তে সমস্যা: $e");
                }

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                l10n.yes,
                style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;

    // স্ক্রিন ওপেন হওয়ামাত্র টোকেন রিড করে সার্ভার থেকে ডাইনামিক ডাটা পুল করবে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().fetchAdminDashboardData();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.adminManager,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
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
            tooltip: l10n.logOutTooltip,
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
                  Text(
                    l10n.todayStats,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Statistics Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        l10n.totalEmployee,
                        provider.adminStats["total"] ?? "0",
                        Icons.groups,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        l10n.present,
                        provider.adminStats["present"] ?? "0",
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        l10n.absent,
                        provider.adminStats["absent"] ?? "0",
                        Icons.cancel,
                        Colors.red,
                      ),
                      _buildStatCard(
                        l10n.late,
                        provider.adminStats["late"] ?? "0",
                        Icons.access_time,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  Text(
                    l10n.quickActions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Action Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(Icons.person, l10n.staff, () {
                          Navigator.pushNamed(context, '/employee-list-table');
                        }),
                        _buildActionButton(Icons.router, l10n.router, () {
                          Navigator.pushNamed(context, '/wifi-list');
                        }),
                        _buildActionButton(Icons.bar_chart, l10n.report, () {
                          Navigator.pushNamed(
                            context,
                            '/employee-report-table',
                          );
                        }),
                        _buildActionButton(Icons.table_chart, l10n.office, () {
                          Navigator.pushNamed(context, '/office-list');
                        }),
                        _buildActionButton(
                          Icons.holiday_village,
                          l10n.holiday,
                          () {
                            Navigator.pushNamed(context, '/holiday');
                          },
                        ),
                        _buildActionButton(Icons.code, l10n.otp, () {
                          Navigator.pushNamed(context, '/admin-otp');
                        }),
                        _buildActionButton(Icons.settings, l10n.settings, () {
                          Navigator.pushNamed(context, '/settings');
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Recent Attendance List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recentAttendance,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.seeAll,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Recent Attendance List Dynamic Generator
                  provider.recentAttendanceList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Text(
                              l10n.noAttendanceLogs,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.recentAttendanceList.length,
                          itemBuilder: (context, index) {
                            final log = provider.recentAttendanceList[index];

                            Color statusColor = Colors.green;
                            if (log['status_type'] == 'Late') {
                              statusColor = Colors.orange;
                            } else if (log['status_type'] == 'Absent') {
                              statusColor = Colors.red;
                            }

                            return _buildRecentAttendance(
                              context,
                              log['name'] ?? l10n.unknown,
                              log['time'] ?? "--:-- AM",
                              log['status'] ?? l10n.onTime,
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

  Widget _buildRecentAttendance(
    BuildContext context,
    String name,
    String time,
    String status,
    Color statusColor,
  ) {
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.timeFormat(time),
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

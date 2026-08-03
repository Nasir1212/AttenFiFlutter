import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/attendance_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/bottom_navItem.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  Future<void> _loadHistoryData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken != null && context.mounted) {
      context.read<AttendanceProvider>().fetchAttendanceHistory(
        userToken: authToken,
      );
    }
  }

  String _getMonthName(BuildContext context, int month) {
    final l10n = AppLocalizations.of(context)!;
    switch (month) {
      case 1:
        return l10n.aths_monthJan;
      case 2:
        return l10n.aths_monthFeb;
      case 3:
        return l10n.aths_monthMar;
      case 4:
        return l10n.aths_monthApr;
      case 5:
        return l10n.aths_monthMay;
      case 6:
        return l10n.aths_monthJun;
      case 7:
        return l10n.aths_monthJul;
      case 8:
        return l10n.aths_monthAug;
      case 9:
        return l10n.aths_monthSep;
      case 10:
        return l10n.aths_monthOct;
      case 11:
        return l10n.aths_monthNov;
      case 12:
        return l10n.aths_monthDec;
      default:
        return '';
    }
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken == null) return;

    final now = DateTime.now();

    final List<DateTime> monthsList = List.generate(3, (index) {
      return DateTime(now.year, now.month - index, 1);
    });

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

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
              Text(
                l10n.aths_selectMonthTitle,
                style: const TextStyle(
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
                  final monthName = _getMonthName(context, monthDate.month);

                  return ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    title: Text(
                      '$monthName ${monthDate.year}',
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final accentColor = theme.colorScheme.secondary;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistoryData(context);
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.aths_attendanceHistoryTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                label: l10n.aths_navHome,
                color: Colors.grey,
                isActive: false,
                onTap: () {
                  Navigator.pushNamed(context, '/user-dashboard');
                },
              ),
              BottomNavItem(
                icon: Icons.history_rounded,
                label: l10n.aths_navHistory,
                color: primaryColor,
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, '/attendance_history');
                },
              ),
              BottomNavItem(
                icon: Icons.person,
                label: l10n.aths_navProfile,
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

          return Column(
            children: [
              _buildMiniSummarySection(
                context: context,
                reportTitle: reportTitle,
                present: l10n.aths_daysFormat(
                  provider.totalPresentDays.toString(),
                ),
                late: l10n.aths_daysFormat(provider.totalLateDays.toString()),
                leave: l10n.aths_daysFormat(provider.totalLeaveDays.toString()),
              ),
              _buildFilterSection(
                context,
                accentColor,
                provider.selectedFilter,
                provider,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final authToken = prefs.getString('auth_token');

                    if (authToken != null && context.mounted) {
                      await context
                          .read<AttendanceProvider>()
                          .fetchAttendanceHistory(userToken: authToken);
                    }
                  },
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Builder(
                          builder: (context) {
                            final filteredLogs =
                                provider.filteredAttendanceHistory;

                            if (filteredLogs.isEmpty) {
                              return ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      l10n.aths_noAttendanceRecord,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.builder(
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
                                  (log['hours'] ?? '') as String,
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

  Widget _buildMiniSummarySection({
    required BuildContext context,
    required String reportTitle,
    required String present,
    required String late,
    required String leave,
  }) {
    final l10n = AppLocalizations.of(context)!;

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
          Text(
            reportTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                l10n.aths_summaryPresent,
                present,
                Colors.green,
              ),
              _buildSummaryItem(l10n.aths_summaryLate, late, Colors.orange),
              _buildSummaryItem(
                l10n.aths_summaryLeave,
                leave,
                Colors.redAccent,
              ),
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

  Widget _buildFilterSection(
    BuildContext context,
    Color accentColor,
    String currentFilter,
    AttendanceProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> filters = ['All', 'Present', 'Late', 'Leave'];

    String getFilterLabel(String filter) {
      switch (filter) {
        case 'All':
          return l10n.aths_filterAll;
        case 'Present':
          return l10n.aths_filterPresent;
        case 'Late':
          return l10n.aths_filterLate;
        case 'Leave':
          return l10n.aths_filterLeave;
        default:
          return filter;
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(getFilterLabel(filter)),
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
    final l10n = AppLocalizations.of(context)!;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case "Present":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        statusText = l10n.aths_statusPresent;
        break;
      case "Late":
        statusColor = Colors.orange;
        statusIcon = Icons.warning_rounded;
        statusText = l10n.aths_statusLate;
        break;
      default:
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_rounded;
        statusText = l10n.aths_statusLeave;
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
                      l10n.aths_inTime,
                      checkIn,
                      isLate ? Colors.orange : Colors.grey[700]!,
                    ),
                    const SizedBox(height: 8),
                    _buildTimeRow(
                      Icons.logout_rounded,
                      l10n.aths_outTime,
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

  Widget _buildTimeRow(IconData icon, String label, String time, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

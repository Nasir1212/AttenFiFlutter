import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/attendance_report_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/custom_ad_bottom_bar.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  // 🗓️ কাস্টম ডায়ালগ (মাস ও বছর নির্বাচন)
  Future<void> _selectMonthYear(
    BuildContext context,
    AdminEmployeeReportProvider provider,
    int? employeeId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    DateTime tempDate = provider.selectedDate;

    final List<String> months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.novembar,
      l10n.december,
    ];

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () {
                      setDialogState(() {
                        tempDate = DateTime(tempDate.year - 1, tempDate.month);
                      });
                    },
                  ),
                  Text(
                    '${tempDate.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () {
                      setDialogState(() {
                        tempDate = DateTime(tempDate.year + 1, tempDate.month);
                      });
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 220,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        tempDate.month == (index + 1) &&
                        tempDate.year == provider.selectedDate.year;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                          DateTime(tempDate.year, index + 1),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A237E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A237E)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (picked != null && employeeId != null) {
      provider.changeDate(picked, employeeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);
    final l10n = AppLocalizations.of(context)!;

    // ১. রাউট আর্গুমেন্ট রিসিভ করা
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int? employeeId = arguments?['employee_id'] as int?;
    final String? employeeName = arguments?['name'] as String?;

    // ২. ব্যাকএন্ড এপিআই ট্রিগার
    if (employeeId != null) {
      Future.delayed(Duration.zero, () {
        final provider = Provider.of<AdminEmployeeReportProvider>(
          context,
          listen: false,
        );
        provider.fetchEmployeeReportForAdmin(employeeId);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          employeeName != null
              ? l10n.employeeReportTitle(employeeName)
              : l10n.attendanceReportTitle,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AdminEmployeeReportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final summary = provider.summary;

          int totalDays = summary['total_days'] ?? 0;
          int totalPresent = summary['total_present'] ?? 0;
          int totalLate = summary['total_late'] ?? 0;
          int totalLeave = summary['total_leave'] ?? 0;
          int totalAbsent = totalDays - (totalPresent + totalLeave);
          if (totalAbsent < 0) totalAbsent = 0;

          double attendanceRate = totalDays > 0
              ? (totalPresent / totalDays) * 100
              : 0.0;
          double lateRate = totalPresent > 0
              ? (totalLate / totalPresent) * 100
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // তারিখ ফিল্টার সেকশন
                GestureDetector(
                  onTap: () => _selectMonthYear(context, provider, employeeId),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.reportPeriodLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                provider.monthYear.isNotEmpty
                                    ? provider.monthYear
                                    : l10n.loading,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // সংক্ষিপ্ত রিপোর্ট (Summary)
                Text(
                  l10n.summaryTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildSummaryCard(
                      l10n.averageAttendance,
                      "${attendanceRate.toStringAsFixed(0)}%",
                      Colors.green,
                    ),
                    const SizedBox(width: 15),
                    _buildSummaryCard(
                      l10n.averageLate,
                      "${lateRate.toStringAsFixed(0)}%",
                      Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // বিস্তারিত রিপোর্ট এরিয়া
                Text(
                  l10n.detailedReportTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                _buildReportListItem(
                  l10n.totalTrackedDays,
                  l10n.daysFormat(totalDays),
                  Icons.calendar_today_outlined,
                  Colors.blue,
                ),
                _buildReportListItem(
                  l10n.onTimeAttendance,
                  l10n.daysFormat(totalPresent),
                  Icons.timer_outlined,
                  Colors.green,
                ),
                _buildReportListItem(
                  l10n.lateAttendance,
                  l10n.daysFormat(totalLate),
                  Icons.history_toggle_off,
                  Colors.orange,
                ),
                _buildReportListItem(
                  l10n.leaveDays,
                  l10n.daysFormat(totalLeave),
                  Icons.beach_access_outlined,
                  Colors.purple,
                ),
                _buildReportListItem(
                  l10n.absentDays,
                  l10n.daysFormat(totalAbsent),
                  Icons.person_off_outlined,
                  Colors.red,
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomAdBottomBar(),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportListItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

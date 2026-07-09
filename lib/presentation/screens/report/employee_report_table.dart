import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/admin_report_provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';

class EmployeeReportTable extends StatelessWidget {
  const EmployeeReportTable({super.key});

  // বাংলা বা ইংরেজি মিক্সড সংখ্যাকে ইংরেজিতে রূপান্তর করার সেফ ফাংশন
  String convertBanglaToEnglish(String input) {
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < banglaDigits.length; i++) {
      input = input.replaceAll(banglaDigits[i], englishDigits[i]);
    }
    return input;
  }

  // পার্সেন্টেজ অনুযায়ী কালার সেট করার প্রফেশনাল লজিক
  Color _getPercentColor(String percent) {
    try {
      String cleanValue = convertBanglaToEnglish(
        percent.replaceAll('%', '').trim(),
      );
      int val = int.parse(cleanValue);

      if (val >= 90) return Colors.green;
      if (val >= 80) return Colors.blue;
      return Colors.red;
    } catch (e) {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);
    final reportProvider = Provider.of<AdminReportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "কর্মচারী রিপোর্ট তালিকা",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            reportProvider.fetchAllEmployeesReport(), // টান দিলে রিফ্রেশ হবে
        child: Column(
          children: [
            // 🏢 অ্যাডমিন সামারিカード (ডাইনামিক)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportProvider.isLoading
                        ? "লোড হচ্ছে..."
                        : "${reportProvider.monthYear}-এর রিপোর্ট",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "মোট কর্মচারী: ${reportProvider.totalEmployees} জন",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 📊 মূল ডাটা টেবিল এরিয়া
            Expanded(
              child: reportProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // লোডিং ইন্ডিকেটর
                  : reportProvider.employeeReports.isEmpty
                  ? const Center(child: Text("কোনো ডাটা পাওয়া যায়নি"))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFFF8F9FA),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'আইডি',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'নাম',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'উপস্থিতি',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'লেট',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'শতকরা',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'অ্যাকশন',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: reportProvider.employeeReports.map((item) {
                            return _buildDataRow(
                              context,
                              item['id'].toString(),
                              item['name'].toString(),
                              item['present_ratio'].toString(),
                              item['late'].toString(),
                              item['percentage'].toString(),
                              item['employee_db_id'], // আসল ডাটাবেজ আইডি নেভিগেশনের জন্য
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // এক্সেল বা পিডিএফ ডাউনলোডের লজিক
      //   },
      //   backgroundColor: primaryColor,
      //   icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
      //   label: const Text(
      //     "রিপোর্ট ডাউনলোড",
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    String id,
    String name,
    String present,
    String late,
    String percent,
    dynamic employeeDbId, // নেভিগেশন আইডি প্যারামিটার
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        DataCell(Text(present)),
        DataCell(
          Text(
            late,
            style: TextStyle(
              color: (late == "০" || late == "0")
                  ? Colors.black
                  : Colors.orange,
              fontWeight: (late == "০" || late == "0")
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPercentColor(percent).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              percent,
              style: TextStyle(
                color: _getPercentColor(percent),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        // শো আইকন (Action Column)
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Color(0xFF1A237E),
              size: 20,
            ),
            onPressed: () {
              // ১. স্নাকবার
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$name-এর বিস্তারিত তথ্য লোড হচ্ছে..."),
                  duration: const Duration(seconds: 1),
                ),
              );

              // ২. রাউট নেভিগেশন (arguments সহ)
              Navigator.pushNamed(
                context,
                '/attendance-report',
                arguments: {'employee_id': employeeDbId, 'name': name},
              );
            },
          ),
        ),
      ],
    );
  }
}

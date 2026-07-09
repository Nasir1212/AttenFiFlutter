import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart'; // আপনার এপিআই সার্ভিস পাথ

class AdminReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _employeeReports = [];
  List<dynamic> get employeeReports => _employeeReports;

  String _monthYear = "";
  String get monthYear => _monthYear;

  int _totalEmployees = 0;
  int get totalEmployees => _totalEmployees;

  // নতুন মেম্বার ভেরিয়েবল (ডাইনামিক ফিল্টারিং এর জন্য)
  int _actualWorkingDays = 0;
  int get actualWorkingDays => _actualWorkingDays;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  AdminReportProvider() {
    fetchAllEmployeesReport();
  }

  /// নির্দিষ্ট মাস ও বছর সেট করে ডাটা রিফ্রেশ করা
  void changeDate(DateTime newDate) {
    _selectedDate = newDate;
    fetchAllEmployeesReport();
  }

  /// এপিআই থেকে সকল কর্মচারীর রিপোর্ট ডাটা আনা
  Future<void> fetchAllEmployeesReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    _isLoading = true;
    notifyListeners();

    try {
      // কুয়েরি প্যারামিটারে মাস এবং বছর ডাইনামিক করা হলো
      final response = await ApiService.get(
        '/employees-report?month=${_selectedDate.month}&year=${_selectedDate.year}',
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          _employeeReports = responseBody['data'] ?? [];
          _monthYear = responseBody['month_year'] ?? "";
          _totalEmployees = responseBody['total_employees'] ?? 0;
          _actualWorkingDays = responseBody['total_working_days'] ?? 0;
        }
      }
    } catch (e) {
      debugPrint("Fetch Admin Report Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

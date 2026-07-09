import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AdminEmployeeReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _summary = {};
  Map<String, dynamic> get summary => _summary;

  List<dynamic> _history = [];
  List<dynamic> get history => _history;

  String _monthYear = "";
  String get monthYear => _monthYear;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // বর্তমান সিলেক্টেড এমপ্লয়ি আইডি ট্র্যাক রাখার জন্য
  int? _currentEmployeeId;

  /// মাস বা বছর পরিবর্তন করলে এই মেথড কল হবে
  void changeDate(DateTime newDate, int employeeId) {
    _selectedDate = newDate;
    fetchEmployeeReportForAdmin(employeeId);
  }

  /// এডমিনের জন্য নির্দিষ্ট এমপ্লয়ির ডাটা এপিআই থেকে আনা
  Future<void> fetchEmployeeReportForAdmin(int employeeId) async {
    _currentEmployeeId = employeeId;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    _isLoading = true;
    notifyListeners();

    try {
      // কুয়েরি প্যারামিটারে employee_id, month এবং year ডাইনামিক পাঠানো হচ্ছে
      final response = await ApiService.get(
        '/admin/employee-history?employee_id=$employeeId&month=${_selectedDate.month}&year=${_selectedDate.year}',
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          _monthYear = responseBody['month_year'] ?? "";
          _summary = responseBody['summary'] ?? {};
          _history = responseBody['history'] ?? [];
        }
      }
    } catch (e) {
      debugPrint("Fetch Admin Employee Report Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

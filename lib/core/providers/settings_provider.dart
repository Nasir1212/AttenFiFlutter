import 'package:atten_fi/core/services/api_service.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  List<String> weekendDays = ["5"];
  String attendanceMode = "anywhere";
  String inTime = "09:00";
  String outTime = "17:00";
  int gracePeriod = 15;
  int gpsRadius = 100;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SettingsProvider() {
    fetchSettingsFromApi();
  }

  // কোনো চিপ বা রেডিওতে ক্লিক করলে স্টেট চেঞ্জ করার ফাংশন
  void toggleWeekend(String day) {
    if (weekendDays.contains(day)) {
      weekendDays.remove(day);
    } else {
      weekendDays.add(day);
    }
    notifyListeners(); // এটি পুরো স্ক্রিনের UI আপডেট করে দেবে
  }

  void updateAttendanceMode(String mode) {
    attendanceMode = mode;
    notifyListeners();
  }

  void updateTimes(String? incomingTime, String? outgoingTime) {
    if (incomingTime != null) inTime = incomingTime;
    if (outgoingTime != null) outTime = outgoingTime;
    notifyListeners();
  }

  // ব্যাকএন্ড লারাভেল এপিআই-তে ডাটা সেভ করার মেথড
  Future<bool> saveSettingsToApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    try {
      final response = await ApiService.post(
        '/update-settings',
        token: token,
        body: {'weekend_days': weekendDays},
      );

      debugPrint(token);

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      debugPrint("Unassign Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      // ignore: control_flow_in_finally
      return isSuccess;
    }
  }

  // settings_provider.dart এর ভেতর যোগ করুন

  Future<void> fetchSettingsFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _isLoading = true;
    notifyListeners();

    try {
      // আপনার ApiService এ GET মেথড যেভাবে লেখা আছে (ধরে নিচ্ছি ApiService.get)
      final response = await ApiService.get('/get-settings', token: token);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        if (decodedBody != null && decodedBody['data'] != null) {
          final data = decodedBody['data'];

          // ব্যাকএন্ড থেকে আসা ডাটা প্রোভাইডারে সেট করা হচ্ছে
          if (data['weekend_days'] != null) {
            // লারাভেল থেকে লিস্ট বা স্ট্রিং যেভাবে আসুক তাকে List<String> এ কনভার্ট করা
            weekendDays = List<String>.from(data['weekend_days']);
          }

          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Fetch Settings Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class HolidayProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 📅 ডাটাবেজ থেকে আসা ছুটির দিনগুলো ক্যালেন্ডারে দেখানোর জন্য ম্যাপ ফরম্যাট: {'2026-06-15': 'ঈদের ছুটি'}
  Map<String, String> _holidayMap = {};
  Map<String, String> get holidayMap => _holidayMap;

  HolidayProvider() {
    fetchHolidaysFromApi();
  }

  /// 📥 ১. লারাভেল ব্যাকএন্ড থেকে সকল ছুটির দিন লোড করার ফাংশন
  Future<void> fetchHolidaysFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    _isLoading = true;
    notifyListeners();

    try {
      // লারাভেলের নতুন GET এপিআই রুট: /holidays
      final response = await ApiService.get('/holidays', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // লারাভেল কন্ট্রোলারের রিটার্ন করা 'holidays' অবজেক্টটি চেক করা
        if (responseBody['success'] == true &&
            responseBody['holidays'] != null) {
          Map<String, dynamic> incomingHolidays = responseBody['holidays'];
          Map<String, String> tempMap = {};

          // ডাইনামিক ম্যাপকে স্ট্রিং ম্যাপে কনভার্ট করা
          incomingHolidays.forEach((key, value) {
            tempMap[key] = value.toString();
          });

          _holidayMap = tempMap;
        }
      }
    } catch (e) {
      debugPrint("Fetch Holidays Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // ক্যালেন্ডার স্ক্রিনকে নতুন ডাটা দিয়ে রি-বিল্ড করবে
    }
  }

  /// 🚀 ২. নতুন ছুটির দিন (১ দিন বা টানা ছুটি) লারাভেল ব্যাকএন্ডে আপলোড করার ফাংশন
  Future<bool> uploadHolidayRangeToApi(
    String title,
    DateTime start,
    DateTime end,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    _isLoading = true;
    notifyListeners();

    bool isSuccess = false;

    // লারাভেলের রিকোয়েস্ট ফরম্যাট অনুযায়ী ডেট স্ট্রিং তৈরি (yyyy-MM-dd)
    String startDateStr = DateFormat('yyyy-MM-dd').format(start);
    String endDateStr = DateFormat('yyyy-MM-dd').format(end);

    try {
      // লারাভেলের নতুন POST এপিআই রুট: /holidays/upload
      final response = await ApiService.post(
        '/upload-holiday',
        token: token,
        body: {
          'title': title,
          'start_date': startDateStr,
          'end_date': endDateStr,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // সফলভাবে ডাটাবেজে সেভ হলে লোকাল ক্যালেন্ডার ম্যাপকেও আপডেট করে দেওয়া
        // এর ফলে নতুন করে এপিআই কল করা ছাড়াই ক্যালেন্ডারে ছুটির মার্কারটি সাথে সাথে ভেসে উঠবে

        DateTime current = start;
        while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
          String dateKey = DateFormat('yyyy-MM-dd').format(current);
          _holidayMap[dateKey] = title;
          current = current.add(const Duration(days: 1));
        }

        isSuccess = true;
      }
    } catch (e) {
      debugPrint("Holiday Range Upload Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}

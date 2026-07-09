import 'dart:convert';
import 'package:atten_fi/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../model/otp_model.dart'; // সঠিক পাথ দিন

class AdminOtpProvider extends ChangeNotifier {
  List<OtpRequest> _otpRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OtpRequest> get otpRequests => _otpRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ওটিপি রিকোয়েস্ট লিস্ট এপিআই থেকে নিয়ে আসার ফাংশন
  Future<void> fetchOtpRequests() async {
    _isLoading = true;
    _errorMessage = null;
    // রিফ্রেশ করার সময় UI আপডেট দেওয়ার জন্য
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(
        'auth_token',
      ); // 🔑 অটোমেটিক টোকেন রিড

      if (token == null) {
        debugPrint("❌ ড্যাশবোর্ড ডাটার জন্য টোকেন পাওয়া যায়নি");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await ApiService.get(
        '/admin/otp-requests',
        token: token,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> rawData = responseData['data'];

          _otpRequests = rawData.map((jsonMap) {
            return OtpRequest(
              id: jsonMap['id'],
              employeeName: jsonMap['employee_name'],
              employeeId: jsonMap['employee_id'],
              imageUrl: jsonMap['image_url'],
              otpCode: jsonMap['otp_code'],
              time: jsonMap['time'],
            );
          }).toList();
        }
      } else {
        _errorMessage =
            'Failed to load requests (Status: ${response.statusCode})';
      }
    } catch (error) {
      _errorMessage = 'Network error: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

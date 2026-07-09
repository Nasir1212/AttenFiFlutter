import 'dart:convert';
import 'package:atten_fi/core/constants/api_constants.dart';
import 'package:atten_fi/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/employee_model.dart';
import '../model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _currentEmployeeId;

  String? get currentEmployeeId => _currentEmployeeId;

  String? _selectedRange;
  String? get selectedRange => _selectedRange;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  String? _currentRole;
  String? get currentRole => _currentRole;

  bool _isOtpSent = false;
  bool get isOtpSent => _isOtpSent;

  void setSelectedRange(String? value) {
    _selectedRange = value;
    notifyListeners();
  }

  void setRole(String role) {
    _currentRole = role;
    notifyListeners();
  }

  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("${ApiConstants.baseUrl}/register");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(user.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'নিবন্ধন সফল হয়েছে!',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'নিবন্ধন ব্যর্থ হয়েছে।',
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'সার্ভারে সংযোগ করা যাচ্ছে না: $e'};
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse("${ApiConstants.baseUrl}/login");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        _token = responseData['token'];
        _currentRole = 'admin';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_role', 'admin');
        notifyListeners();
        return {
          'success': true,
          'message': responseData['message'] ?? 'লগইন সফল হয়েছে!',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'ইমেইল অথবা পাসওয়ার্ড ভুল।',
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': ' সার্ভারের সংযোগ করা যাচ্ছে না: $e',
      };
    }
  }

  Future<String?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('auth_token') || !prefs.containsKey('user_role')) {
      return null;
    }

    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (token == null || token.isEmpty) {
      return null;
    }

    _token = token;
    _currentRole = role;

    notifyListeners();
    return role;
  }

  Future<bool> logout(String token) async {
    try {
      await ApiService.post("/logout", token: token, body: {});
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_role');
      await prefs.remove('user_profile');
      _token = null;
      _currentRole = null;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Logout Error: $e");
      return false;
    }
  }

  void resetOtpState() {
    _isOtpSent = false;
    notifyListeners();
  }

  // 🚀 ১. ওটিপি পাঠানোর প্রোভাইডার মেথড
  Future<Map<String, dynamic>> sendOtp(String employeeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/employee/send-otp");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({'employee_id': employeeId}),
      );
      _isLoading = false;
      notifyListeners();
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isOtpSent = true;
        _currentEmployeeId = employeeId;
        notifyListeners();
        return {
          'success': true,
          'message': responseData['message'] ?? 'ধন্যবাদ! সফল হয়েছে',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? ' আবার চেষ্ট করুন',
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // এররটি স্ক্রিনে ক্যাচ করার জন্য রেথ্রো করা হলো
    }
  }

  Future<bool> verifyOtpAndLogin(String employeeId, String otpCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/employee/verify-otp");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({'employee_id': employeeId, 'otp_code': otpCode}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 && responseData['success'] == true) {
        _token = responseData['token'];
        _isOtpSent = false;

        EmployeeModel employee = EmployeeModel.fromJson(
          responseData['employee'],
        );
        final List<dynamic> bssidList = responseData['allowed_bssids'] ?? [];

        final prefs = await SharedPreferences.getInstance();
        List<String> stringBssidList = List<String>.from(bssidList);
        await prefs.setStringList(
          'allowed_bssids',
          stringBssidList,
        ); // 👈 আলাদাভাবে সেভ হলো

        Map<String, dynamic> userProfile = {
          ...employee.toMap(),
          'id': employee.id,
          'employee_id': employee.employeeId,
          'image_url': employee.imageUrl,
        };
        await prefs.setString('user_profile', jsonEncode(userProfile));
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_role', 'user');

        notifyListeners();
        return true;
      } else {
        final errorMessage =
            responseData['message'] ?? 'ভেরিফিকেশন ব্যর্থ হয়েছে';
        throw Exception(errorMessage);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

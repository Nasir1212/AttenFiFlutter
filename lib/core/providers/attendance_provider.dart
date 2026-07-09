import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:atten_fi/core/services/api_service.dart';

import '../model/employee_model.dart';

class AttendanceProvider with ChangeNotifier {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  double _animationProgress = 0.0;
  bool _isCheckedIn = false;
  bool _isSyncing = false;
  bool _isLoading = false;
  bool _isProfileLoaded = false;
  String _selectedFilter = 'All';

  // 👑 ড্যাশবোর্ডের জন্য ডাইনামিক স্টেট ভেরিয়েবল
  Map<String, String> _adminStats = {
    "total": "0",
    "present": "0",
    "absent": "0",
    "late": "0",
  };
  List<Map<String, dynamic>> _recentAttendanceList = [];

  Map<String, String> get adminStats => _adminStats;
  List<Map<String, dynamic>> get recentAttendanceList => _recentAttendanceList;

  String get selectedFilter => _selectedFilter;
  List<Map<String, dynamic>> _attendanceHistory = [];
  List<String> _todayLogs = [];
  EmployeeModel? _employeeProfile;

  // 📊 রিপোর্টের ভেরিয়েবলসমূহ
  int _totalPresentDays = 0;
  int _totalLateDays = 0;
  int _totalLeaveDays = 0;
  String _currentMonthText = "";

  // Getters
  double get animationProgress => _animationProgress;
  bool get isCheckedIn => _isCheckedIn;
  bool get isLoading => _isLoading;
  List<String> get todayLogs => _todayLogs;
  bool get isProfileLoaded => _isProfileLoaded;
  EmployeeModel? get employeeProfile => _employeeProfile;

  int get totalPresentDays => _totalPresentDays;
  int get totalLateDays => _totalLateDays;
  int get totalLeaveDays => _totalLeaveDays;
  String get currentMonthText => _currentMonthText.isEmpty
      ? "এই মাসের রিপোর্ট (${DateFormat('MMMM yyyy').format(DateTime.now())})"
      : "এই মাসের রিপোর্ট ($_currentMonthText)";

  List<Map<String, dynamic>> get attendanceHistory => _attendanceHistory;

  AttendanceProvider() {
    _initLogs();
    _monitorConnectivity();
  }

  Future<void> fetchAdminDashboardData() async {
    _isLoading = true;
    await Future.delayed(Duration.zero);
    notifyListeners();

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
        '/admin/dashboard-stats',
        token: token,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // পরিসংখ্যান ম্যাপিং
          _adminStats = {
            "total": data['stats']['total_employees'] ?? "0",
            "present": data['stats']['present'] ?? "0",
            "absent": data['stats']['absent'] ?? "0",
            "late": data['stats']['late'] ?? "0",
          };

          // সাম্প্রতিক তালিকা ম্যাপিং
          final List<dynamic> rawRecent = data['recent_attendance'] ?? [];
          _recentAttendanceList = List<Map<String, dynamic>>.from(rawRecent);
        }
      } else {
        debugPrint("⚠️ ড্যাশবোর্ড এপিআই রেসপন্স ফেইলড: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ ড্যাশবোর্ড রিকোয়েস্টে সমস্যা: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
        bool hasInternet = await InternetConnectionChecker().hasConnection;
        if (hasInternet) {
          syncOfflineAttendance();
        }
      }
    });
  }

  Future<void> _initLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      await fetchTodayLogs(token);
      await fetchMonthlyReport(token);
      fetchAttendanceHistory(userToken: token);
    }
  }

  Future<void> refreshProfileFromServer(String token) async {
    try {
      // 🌐 লারাভেলের কাস্টম রিফ্রেশ এন্ডপয়েন্টে হিট
      final response = await ApiService.get(
        '/employee/profile/refresh',
        token: token,
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // ১. নতুন ডাটা দিয়ে EmployeeModel পার্স করা
        EmployeeModel employee = EmployeeModel.fromJson(
          responseData['employee'],
        );
        _employeeProfile = employee; // রানটাইম মেমোরি স্টেট আপডেট

        // ২. নতুন allowed_bssids লিস্ট SharedPreferences-এ ওভাররাইট করা
        final List<dynamic> bssidList = responseData['allowed_bssids'] ?? [];
        List<String> stringBssidList = List<String>.from(bssidList);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('allowed_bssids', stringBssidList);

        // ৩. নতুন ইউজার প্রোফাইল ম্যাপ তৈরি করে SharedPreferences-এ সেভ করা
        Map<String, dynamic> userProfile = {
          ...employee.toMap(),
          'id': employee.id,
          'employee_id': employee.employeeId,
          'image_url': employee.imageUrl,
        };
        await prefs.setString('user_profile', jsonEncode(userProfile));

        _isProfileLoaded = true;
        notifyListeners(); // ড্যাশবোর্ড UI রেন্ডার করার জন্য

        debugPrint(
          "🔄 সার্ভার থেকে প্রোফাইল ও ওয়াইফাই লিস্ট সফলভাবে রিফ্রেশ ও সেভ হয়েছে!",
        );
      }
    } catch (e) {
      debugPrint("❌ প্রোফাইল রিফ্রেশ করতে সমস্যা হয়েছে: $e");
    }
  }

  // এনিমেশন প্রগ্রেস আপডেট মেথড
  void updateProgress(double value) {
    _animationProgress = value;
    notifyListeners();
  }

  // 📥 📤 হাজিরা সাবমিট করার মেথড (অনলাইন ও স্মার্ট অফলাইন হ্যান্ডলিং)
  Future<Map<String, dynamic>> submitAttendance({
    required String wifiBssid,
    required String userToken,
  }) async {
    _isLoading = true;
    notifyListeners();

    // 🌐 ১. ইন্টারনেট কানেক্টিভিটি চেক (List হ্যান্ডলিং সহ)
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool hasInternet = false;

    if (connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none)) {
      hasInternet = await InternetConnectionChecker().hasConnection;
    }

    // ==========================================
    // 🟢 সিনারিও ১: ইন্টারনেট আছে (লোকাল রাউটার চেক স্কিপ -> সরাসরি এপিআই-তে হিট)
    // ==========================================
    if (hasInternet) {
      try {
        final response = await ApiService.post(
          '/employee/attendance/store',
          token: userToken,
          body: {'wifi_bssid': wifiBssid},
        );

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['success'] == true) {
          // 🎯 ফিক্স ১: লারাভেলের রেসপন্স থেকে সরাসরি কারেন্ট স্ট্যাটাস আপডেট
          if (responseData.containsKey('is_checked_in')) {
            _isCheckedIn = responseData['is_checked_in'] ?? !_isCheckedIn;
          } else {
            // যদি এপিআই সরাসরি না পাঠায়, তবে স্টেট উল্টে দিন
            _isCheckedIn = !_isCheckedIn;
          }

          // 🎯 ফিক্স ২: await ব্যবহার করে টাইমলাইন ও লগস ফ্রেশ করে আনা
          await fetchTodayLogs(userToken);

          _isLoading = false;
          notifyListeners();

          return {
            'success': true,
            'is_offline': false,
            'message': responseData['message'] ?? 'হাজিরা সফল হয়েছে!',
          };
        } else {
          _isLoading = false;
          notifyListeners();
          return {
            'success': false,
            'is_offline': false,
            'message': responseData['message'] ?? 'হাজিরা সম্পন্ন করা যায়নি।',
          };
        }
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        return {
          'success': false,
          'is_offline': false,
          'message': 'সংযোগ সমস্যা: $e',
        };
      }
    }

    // ==========================================
    // 🔴 সিনারিও ২: ইন্টারনেট নেই (শুধুমাত্র তখনই লোকাল রাউটার চেক হবে)
    // ==========================================
    final prefs = await SharedPreferences.getInstance();
    List<String> allowedBssids = prefs.getStringList('allowed_bssids') ?? [];

    if (!allowedBssids.contains(wifiBssid)) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'is_offline': true,
        'message':
            'দুঃখিত, ইন্টারনেট নেই এবং আপনি অফিসের অনুমোদিত ওয়াইফাই জোনেও নেই।',
      };
    }

    // রাউটার মিলে গেলে অফলাইন লগের জন্য ডেটা তৈরি ও সেভ রাখা
    Map<String, String> offlineLog = {
      'wifi_bssid': wifiBssid,
      'offline_time': DateTime.now().toIso8601String(),
    };

    List<String> existingOfflineLogs =
        prefs.getStringList('offline_attendance_logs') ?? [];
    existingOfflineLogs.add(json.encode(offlineLog));
    await prefs.setStringList('offline_attendance_logs', existingOfflineLogs);

    // 🎯 ফিক্স ৩: অফলাইনেও ইনস্ট্যান্ট বাটন চেঞ্জ করার জন্য লোকাল স্টেট উল্টে দেওয়া এবং লোকাল টাইমলাইনে অ্যাড করা
    _isCheckedIn = !_isCheckedIn;

    String formattedTime =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    _todayLogs.insert(
      0,
      _isCheckedIn
          ? "$formattedTime - চেক-ইন (অফলাইন)"
          : "$formattedTime - চেক-আউট (অফলাইন)",
    );

    _isLoading = false;
    notifyListeners();

    return {
      'success': true,
      'is_offline': true,
      'message':
          'অফিস ওয়াইফাই ভেরিফাইড! ইন্টারনেট না থাকায় হাজিরা অফলাইনে সংরক্ষিত হলো।',
    };
  }

  // 🔄 পূর্বে থাকা টুডে লগস নিয়ে আসার মেথড
  Future<void> fetchTodayLogs(String userToken) async {
    _isLoading = true;
    // UI থ্রেড ফ্রি রাখতে সামান্য ডিলে দিয়ে নোটিফাই করা
    await Future.delayed(Duration.zero);
    notifyListeners();

    try {
      final response = await ApiService.get(
        '/employee/attendance/today-logs',
        token: userToken,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _isCheckedIn = data['is_checked_in'] ?? false;

        final List<dynamic> rawLogs = data['logs'] ?? [];
        _todayLogs = rawLogs.map((log) => log.toString()).toList();
      }
    } catch (e) {
      debugPrint("Error fetching today logs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncOfflineAttendance() async {
    if (_isSyncing) return;
    _isSyncing = true;

    final prefs = await SharedPreferences.getInstance();
    List<String> offlineLogsRaw =
        prefs.getStringList('offline_attendance_logs') ?? [];

    if (offlineLogsRaw.isEmpty) {
      _isSyncing = false;
      return;
    }

    final String? token = prefs.getString('auth_token');
    if (token == null) {
      _isSyncing = false;
      return;
    }

    // 🎯 সব র ডাটাকে ম্যাপ (Map) লিস্টে রূপান্তর করা যা লারাভেল গ্রহণ করবে
    List<Map<String, dynamic>> logsToSend = offlineLogsRaw.map((logStr) {
      return json.decode(logStr) as Map<String, dynamic>;
    }).toList();

    try {
      debugPrint(
        "🔄 নতুন এন্ডপয়েন্টে সিঙ্ক শুরু হচ্ছে... মোট রেকর্ড: ${logsToSend.length}",
      );

      // 🌐 নতুন ডেডিকেটেড এন্ডপয়েন্টে হিট করা হচ্ছে
      final response = await ApiService.post(
        '/employee/attendance/sync-offline',
        token: token,
        body: {
          'logs':
              logsToSend, // লারাভেলের রিকোয়েস্ট ভ্যালিডেশন অনুযায়ী 'logs' কি-তে পাঠানো হলো
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        debugPrint("✅ সব অফলাইন ডাটা একসাথে সিঙ্ক সাকসেসফুল!");

        // সিঙ্ক সফল হলে লোকাল মেমোরি খালি করে দেওয়া
        await prefs.remove('offline_attendance_logs');

        // আজকের টাইমলাইন রিফ্রেশ করা
        await fetchTodayLogs(token);
      } else {
        debugPrint("⚠️ সার্ভার রেসপন্স ফেইলড: ${responseData['message']}");
      }
    } catch (e) {
      debugPrint("❌ অফলাইন সিঙ্ক এপিআই কানেকশনে সমস্যা: $e");
      // ইন্টারনেট চলে গেলে বা এরর হলে ডাটা SharedPreferences-এই থাকবে, হারাবে না
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // 🔄 সার্ভার থেকে ডাইনামিক রিপোর্টের ডাটা আনা
  Future<void> fetchMonthlyReport(String userToken) async {
    _isLoading = true;
    // UI থ্রেড সেফ রাখার জন্য Duration.zero
    Future.delayed(Duration.zero, () => notifyListeners());

    try {
      final response = await ApiService.get(
        '/employee/attendance/monthly-report',
        token: userToken,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ব্যাকএন্ডের রেসপন্স অনুযায়ী ডাটা সেট করা হচ্ছে
        _totalPresentDays = data['total_present'] ?? 0;
        _totalLateDays = data['total_late'] ?? 0;
        _totalLeaveDays = data['total_leave'] ?? 0;
        _currentMonthText = data['month_year'] ?? "";
      }
    } catch (e) {
      debugPrint("Error fetching monthly report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================================
  // 📅 🎯 সার্ভার থেকে হাজিরা হিস্ট্রি ডাটা রিট্রিভ করা
  // =========================================================================
  Future<void> fetchAttendanceHistory({
    required String userToken,
    int? month,
    int? year,
  }) async {
    _isLoading = true;
    // UI ফ্রি রাখতে বিল্ড সাইকেলের বাইরে নোটিফাই করা হলো
    await Future.delayed(Duration.zero);
    notifyListeners();

    try {
      // কোয়েরি প্যারামিটার তৈরি (যদি নির্দিষ্ট মাস/বছর পাঠানো হয়)
      String url = '/employee/attendance/history';
      if (month != null && year != null) {
        url += '?month=$month&year=$year';
      }

      final response = await ApiService.get(url, token: userToken);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // ১. হিস্ট্রি ডাটা এ্যাসাইন করা
          final List<dynamic> rawHistory = data['history'] ?? [];
          _attendanceHistory = List<Map<String, dynamic>>.from(rawHistory);

          // ২. হিস্ট্রি এন্ডপয়েন্টের সামারি ডেটা দিয়ে ড্যাশবোর্ড রিপোর্টও সিঙ্ক করে নেওয়া
          if (data.containsKey('summary')) {
            _totalPresentDays = data['summary']['total_present'] ?? 0;
            _totalLateDays = data['summary']['total_late'] ?? 0;
            _totalLeaveDays = data['summary']['total_leave'] ?? 0;
          }
          if (data.containsKey('month_year')) {
            _currentMonthText = data['month_year'] ?? "";
          }
        }
      } else {
        debugPrint("⚠️ হিস্ট্রি এপিআই ফেইলড: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ হিস্ট্রি ডাটা আনতে সমস্যা হয়েছে: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // 🎯 ফিল্টার অনুযায়ী হিস্ট্রি ডাটা গেট করার জন্য Getter (নতুন যুক্ত করুন)
  List<Map<String, dynamic>> get filteredAttendanceHistory {
    if (_selectedFilter == 'All') {
      return _attendanceHistory;
    }
    return _attendanceHistory
        .where((log) => log['status'] == _selectedFilter)
        .toList();
  }
}

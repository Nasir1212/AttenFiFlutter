import 'dart:convert';
import 'package:atten_fi/core/services/api_service.dart';
import 'package:flutter/material.dart';
import '../model/office_model.dart';
import '../model/wifi_model.dart';

class OfficeProvider with ChangeNotifier {
  List<OfficeModel> _officesList = [];
  List<WifiModel> _globalWifiList = [];
  List<WifiModel> _unassignedWifisList = [];
  List<WifiModel> _assignedWifisList = [];

  bool _isLoading = false;

  List<OfficeModel> get officesList => _officesList;
  List<WifiModel> get globalWifiList => _globalWifiList;
  List<WifiModel> get unassignedWifisList => _unassignedWifisList;
  List<WifiModel> get assignedWifisList => _assignedWifisList;
  bool get isLoading => _isLoading;

  Future<void> fetchOfficesList({required String token}) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () => notifyListeners());

    try {
      final response = await ApiService.get('/offices', token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> officeData = data['data'] ?? [];
        _officesList = officeData
            .map((json) => OfficeModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unassignedWifis({required String token}) async {
    try {
      final response = await ApiService.get('/unassigned-wifis', token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> wifiData = data['data'] ?? [];
        _unassignedWifisList = wifiData
            .map((json) => WifiModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignedWifis({
    required String token,
    required int officeId,
  }) async {
    try {
      final response = await ApiService.post(
        '/assigned-wifis',
        token: token,
        body: {'office_id': officeId},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> wifiData = data['data'] ?? [];
        _assignedWifisList = wifiData
            .map((json) => WifiModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> assignWifiToOffice({
    required String token,
    required int wifiId,
    required int officeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/assign-wifi',
        token: token,
        body: {'wifi_id': wifiId, 'office_id': officeId},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          unassignedWifis(token: token);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("Assign Wifi Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> addOffice({
    required String token,
    required OfficeModel office,
  }) async {
    try {
      final response = await ApiService.post(
        '/offices/store',
        token: token,
        body: office.toJson(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'message': responseData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'কানেকশন সমস্যা!'};
    }
  }

  // গ্লোবাল ওয়াইফাই (যা কোনো অফিসের আন্ডারে না) নিয়ে আসার মেথড
  Future<void> fetchGlobalWifiList({required String token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // লারাভেলে এমন একটা এন্ডপয়েন্ট বানাতে পারেন যা শুধু office_id = null ওয়ালা ওয়াইফাই ব্যাক করবে
      final response = await ApiService.get('/global-wifis', token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> wifiData = data['data'] ?? [];
        _globalWifiList = wifiData
            .map((json) => WifiModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> saveWifi({
    required String token,
    int? officeId, // Nullable করা হলো গ্লোবাল ওয়াইফাই সাপোর্টের জন্য
    required String ssid,
    required String bssid,
  }) async {
    try {
      final response = await ApiService.post(
        '/offices/save-wifi',
        token: token,
        body: {
          'office_id': officeId, // null হলে ব্যাকএন্ডে null-ই পাস হবে
          'ssid': ssid,
          'bssid': bssid,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'সার্ভার এরর!',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'কানেকশন সমস্যা: $e'};
    }
  }

  Future<bool> updateOffice({
    required String token,
    required OfficeModel office,
  }) async {
    try {
      final response = await ApiService.post(
        '/offices/update/${office.id.toString()}',
        token: token,
        body: office.toJson(),
      );

      if (response.statusCode == 200) {
        // লোকাল লিস্ট থেকে ডাটা ইনস্ট্যান্ট আপডেট করে UI রিফ্রেশ করা
        final index = _officesList.indexWhere(
          (element) => element.id == office.id,
        );
        if (index != -1) {
          _officesList[index] = office;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Update Office Error: $e");
      return false;
    }
  }

  // ২. অফিস ডিলিট করার মেথড
  Future<bool> deleteOffice({required String token, required int id}) async {
    try {
      final response = await ApiService.delete('/offices/$id', token: token);

      if (response.statusCode == 200) {
        // লোকাল লিস্ট থেকে অবজেক্টটি রিমুভ করে দেওয়া
        _officesList.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Delete Office Error: $e");
      return false;
    }
  }

  Future<void> unassignWifiFromOffice({
    required String token,
    required int wifiId,
    required int officeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/unassign-wifi',
        token: token,
        body: {'wifi_id': wifiId},
      );

      if (response.statusCode == 200) {
        assignedWifis(officeId: officeId, token: token);
      }
    } catch (e) {
      debugPrint("Unassign Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteWifi({required String token, required int id}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 💡 এন্ডপয়েন্ট এখন ডাইনামিক ইউআরএল আকারে যাচ্ছে: /delete-wifi/5
      final response = await ApiService.delete(
        '/delete-wifi/$id',
        token: token,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // লোকাল লিস্ট থেকে ইনস্ট্যান্ট রিমুভ
          _unassignedWifisList.removeWhere((wifi) => wifi.id == id);

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("Delete Wifi Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

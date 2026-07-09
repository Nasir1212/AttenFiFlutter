import 'dart:convert';
import 'dart:io';
import 'package:atten_fi/core/services/api_service.dart';
import 'package:flutter/material.dart';
import '../model/employee_model.dart';

class EmployeeProvider with ChangeNotifier {
  List<EmployeeModel> _employeeList = [];
  bool _isLoading = false;

  List<EmployeeModel> get employeeList => _employeeList;
  bool get isLoading => _isLoading;

  // ১. এপিআই থেকে কর্মচারীদের তালিকা আনা (fetchOfficesList ফলো করে)
  Future<void> fetchEmployees(String userToken) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () => notifyListeners());

    try {
      final response = await ApiService.get('/employees', token: userToken);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rawList = data['data'] ?? [];
        _employeeList = rawList
            .map((json) => EmployeeModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching employees: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addEmployee({
    required Map<String, String> employeeData,
    required String userToken,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // সরাসরি ApiService.multipart কল করুন
      final response = await ApiService.multipart(
        '/employees/store',
        method: 'POST',
        fields: employeeData,
        token: userToken,
        file: imageFile,
        fileKey: 'image', // লারাভেলের ভ্যালিডেশন কী
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchEmployees(userToken);
        return {'success': true, 'message': responseData['message'] ?? 'সফল!'};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'ব্যর্থ!',
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'সংযোগ সমস্যা: $e'};
    }
  }

  Future<bool> updateEmployee({
    required int employeeId,
    required Map<String, String> employeeData,
    required String userToken,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // লারাভেলে ফাইলসহ আপডেটের ক্ষেত্রে বডিতে '_method': 'PUT' দিতে হয়
      final Map<String, String> fieldsWithMethod = Map.from(employeeData);
      fieldsWithMethod['_method'] = 'PUT';

      final response = await ApiService.multipart(
        '/employees/update/$employeeId',
        method: 'POST',
        fields: fieldsWithMethod,
        token: userToken,
        file: imageFile,
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        fetchEmployees(userToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Update Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ৪. কর্মচারী ডিলিট করার মেথড (deleteOffice ফলো করে)
  Future<bool> deleteEmployee({
    required String userToken,
    required int id,
  }) async {
    try {
      final response = await ApiService.delete(
        '/employees/$id',
        token: userToken,
      );

      if (response.statusCode == 200) {
        _employeeList.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Delete Employee Error: $e");
      return false;
    }
  }
}

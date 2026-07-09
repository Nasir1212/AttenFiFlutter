// lib/core/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:atten_fi/core/constants/api_constants.dart';

class ApiService {
  static Map<String, String> _getHeaders(String? token) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Map<String, String> _getMultipartHeaders(String? token) {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // 🔄 GET রিকোয়েস্ট মেথড
  static Future<http.Response> get(String path, {String? token}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$path');
    debugPrint("🌐 GET Request to: $url"); // ডিবাগিং এর জন্য সুবিধাজনক

    try {
      final response = await http.get(url, headers: _getHeaders(token));
      return response;
    } catch (e) {
      debugPrint("❌ GET Exception: $e");
      rethrow;
    }
  }

  // ✉️ POST রিকোয়েস্ট মেথড
  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$path');
    debugPrint("🌐 POST Request to: $url");
    if (body != null) debugPrint("📦 Body: ${json.encode(body)}");

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(token),
        body: body != null ? json.encode(body) : null,
      );
      return response;
    } catch (e) {
      debugPrint("❌ POST Exception: $e");
      rethrow;
    }
  }

  static Future<http.Response> delete(
    String path, {
    required String token,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$path');
    try {
      final response = await http.delete(url, headers: _getHeaders(token));
      return response;
    } catch (e) {
      throw Exception('ডিলিট রিকোয়েস্ট পাঠাতে ব্যর্থ হয়েছে: $e');
    }
  }

  static Future<http.Response> multipart(
    String path, {
    required String method,
    required Map<String, String> fields,
    String? token,
    File? file,
    String fileKey = 'image',
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$path');
    debugPrint("🌐 MULTIPART ($method) Request to: $url");
    debugPrint("📦 Fields: $fields");
    if (file != null) debugPrint("📁 File Path: ${file.path}");

    try {
      var request = http.MultipartRequest(method, url);

      request.headers.addAll(_getMultipartHeaders(token));

      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileKey, file.path),
        );
      }

      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📥 Status Code: ${response.statusCode}");
      return response;
    } catch (e) {
      debugPrint("❌ MULTIPART Exception: $e");
      rethrow;
    }
  }
}

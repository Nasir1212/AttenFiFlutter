// lib/core/models/wifi_model.dart

class WifiModel {
  final int id;
  final int? userId;
  final int? officeId;
  final String ssid;
  final String bssid;

  WifiModel({
    required this.id,
    this.userId,
    this.officeId,
    required this.ssid,
    required this.bssid,
  });

  // 🔄 JSON থেকে Dart অবজেক্টে রূপান্তর করার জন্য (API Response parsing)
  factory WifiModel.fromJson(Map<String, dynamic> json) {
    return WifiModel(
      id: json['id'],
      userId:
          json['user_id'], // লারাভেল ব্যাকএন্ডের snake_case কলামের সাথে মিল রেখে
      officeId: json['office_id'],
      ssid: json['ssid'] ?? '',
      bssid: json['bssid'] ?? '',
    );
  }

  // 🔄 Dart অবজেক্ট থেকে JSON-এ রূপান্তর করার জন্য (যদি কখনো বডিতে মডেল পাস করতে হয়)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'office_id': officeId,
      'ssid': ssid,
      'bssid': bssid,
    };
  }
}

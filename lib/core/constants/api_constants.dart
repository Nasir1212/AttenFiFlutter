// lib/core/constants/api_constants.dart

class ApiConstants {
  // 🌟 এখানে আপনার মেইন এপিআই বেস ইউআরএল একবারই লিখবেন
  // static const String baseUrl = "https://attenfi.live/api";
  static const String baseUrl =
      "https://yoga-figure-rebound.ngrok-free.dev/api";

  // 🔗 প্রয়োজনে এখানে আপনার এন্ডপয়েন্টগুলোও গুছিয়ে রাখতে পারেন
  static const String login = "$baseUrl/login";
  static const String offices = "$baseUrl/offices";
  static const String employees = "$baseUrl/employees";
}

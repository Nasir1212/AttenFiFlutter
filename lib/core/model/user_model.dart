class UserModel {
  final String ownerName;
  final String companyName;
  final String employeeRange;
  final String email;
  final String phone;
  final String password; // শুধুমাত্র সাইনআপের সময় পাঠানোর জন্য

  UserModel({
    required this.ownerName,
    required this.companyName,
    required this.employeeRange,
    required this.email,
    required this.phone,
    required this.password,
  });

  // মডেল অবজেক্ট থেকে সহজে JSON (Map) তৈরি করার মেথড (App to API)
  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'company_name': companyName,
      'employee_range': employeeRange,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

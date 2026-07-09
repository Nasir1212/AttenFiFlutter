class EmployeeModel {
  final int? id;
  final String? employeeId;
  final String name;
  final String? fatherName;
  final String? motherName;
  final String? nid;
  final String? dob;
  final String mobile;
  final String? address;
  final String? imageUrl;

  EmployeeModel({
    this.id,
    this.employeeId,
    required this.name,
    this.fatherName,
    this.motherName,
    this.nid,
    this.dob,
    required this.mobile,
    this.address,
    this.imageUrl,
  });

  // API থেকে ডাটা নেওয়ার সময় (JSON -> Object)
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      employeeId: json['employee_id'] ?? '',
      name: json['name'] ?? '',
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      nid: json['nid'],
      dob: json['dob'],
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  // API-তে ডাটা পাঠানোর সময় (Object -> Map)
  Map<String, String> toMap() {
    return {
      'name': name,
      'father_name': fatherName ?? '',
      'mother_name': motherName ?? '',
      'nid': nid ?? '',
      'dob': dob ?? '',
      'mobile': mobile,
      'address': address ?? '',
    };
  }
}

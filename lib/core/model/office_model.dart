class OfficeModel {
  final int id;
  final String name;
  final String? address;
  final String? startTime;
  final String? endTime;
  final String? graceTime;

  OfficeModel({
    required this.id,
    required this.name,
    this.address,
    this.startTime,
    this.endTime,
    this.graceTime,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    return OfficeModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      startTime: json['start_time'],
      endTime: json['grace_time'],
      graceTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'start_time': startTime,
      'grace_time': graceTime,
      'end_time': endTime,
    };
  }

  get wifis => null;
}

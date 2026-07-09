// ওটিপি ডাটার মডেল ক্লাস
class OtpRequest {
  final String id;
  final String employeeName;
  final String employeeId;
  final String imageUrl;
  final String otpCode;
  final String time;

  OtpRequest({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.imageUrl,
    required this.otpCode,
    required this.time,
  });
}

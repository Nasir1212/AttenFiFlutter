// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generalSettings => 'General Settings';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get other => 'Other';

  @override
  String get holidaySettings => 'Holiday Settings';

  @override
  String get changePassword => 'Change Password';

  @override
  String get version => 'Version';

  @override
  String get appName => 'AttenFI';

  @override
  String get adminManager => 'Admin/Manager';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out from your account?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get logOutTooltip => 'Log Out';

  @override
  String get todayStats => 'Today\'s Statistics';

  @override
  String get totalEmployee => 'Total Employee';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'Late';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get staff => 'Staff';

  @override
  String get router => 'Router';

  @override
  String get report => 'Report';

  @override
  String get office => 'Office';

  @override
  String get holiday => 'Holiday';

  @override
  String get otp => 'OTP';

  @override
  String get recentAttendance => 'Recent Attendance';

  @override
  String get seeAll => 'See All';

  @override
  String get noAttendanceLogs => 'No attendance logs for today yet.';

  @override
  String timeFormat(String time) {
    return 'Time: $time';
  }

  @override
  String get onTime => 'On Time';

  @override
  String get unknown => 'Unknown';

  @override
  String get addEmployeeTitle => 'Add New Employee';

  @override
  String get employeeName => 'Employee Name';

  @override
  String get fatherName => 'Father\'s Name';

  @override
  String get motherName => 'Mother\'s Name';

  @override
  String get nidNumber => 'NID Number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get dobHint => 'DD/MM/YYYY';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get fullAddress => 'Full Address';

  @override
  String get saveInformation => 'Save Information';

  @override
  String get validationRequiredFields =>
      '* Name, mobile, and address are required';

  @override
  String get sessionExpiredMessage => 'Session expired! Please login again.';

  @override
  String get employeeAddedSuccess => 'Employee added successfully';

  @override
  String get employeeDetailsTitle => 'Employee Details';

  @override
  String get employeeRole => 'Employee';

  @override
  String get institutionalInfo => 'Institutional Information';

  @override
  String get employeeId => 'Employee ID';

  @override
  String get idNotFound => 'ID not found';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get contactInfo => 'Contact Information';

  @override
  String get editInformation => 'Edit Information';

  @override
  String get editEmployeeTitle => 'Edit Information';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get takePhotoWithCamera => 'Take photo with camera';

  @override
  String employeeIdLabel(Object id) {
    return 'Employee ID: $id';
  }

  @override
  String get updateButton => 'Update';

  @override
  String get updateSuccess => 'Successfully updated';

  @override
  String get tryAgain => 'Please try again!';

  @override
  String get nameRequired => 'Name is mandatory';

  @override
  String get mobileRequired => 'Mobile is mandatory';

  @override
  String get confirmTitle => 'Confirm';

  @override
  String deleteEmployeeConfirmation(Object employeeName) {
    return 'Are you sure you want to delete \'$employeeName\' from the list?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Yes, Delete';

  @override
  String get deletedSuccessfully => 'Deleted successfully';

  @override
  String get allEmployeesList => 'All Employees List';

  @override
  String get noEmployeeDataFound => 'No employee data found.';

  @override
  String get searchHint => 'Search by name or ID...';

  @override
  String get notFound => 'Not found!';

  @override
  String get image => 'Image';

  @override
  String get details => 'Details';

  @override
  String get action => 'Action';

  @override
  String get noId => 'No ID';

  @override
  String get addEmployee => 'Add Employee';

  @override
  String get holidayUploadCalendarTitle => 'Holiday Upload Screen';

  @override
  String get singleDayGuidance =>
      '👉 Single day holiday: Select any date and press the button below.';

  @override
  String get multiDayGuidance =>
      '👉 Multiple days holiday: Select start and end dates and press the button below.';

  @override
  String get addSingleDayHolidayTitle => 'Add 1 Day Holiday';

  @override
  String get addMultiDayHolidayTitle => 'Add Consecutive Holidays';

  @override
  String singleDateText(Object date) {
    return 'Date: $date';
  }

  @override
  String dateRangeText(Object end, Object start) {
    return 'Duration: $start to $end';
  }

  @override
  String get holidayTitleHint => 'e.g., Eid Holiday, Independence Day';

  @override
  String get holidayTitleLabel => 'Holiday or Event Name';

  @override
  String get save => 'Save';

  @override
  String get addHoliday => 'Add Holiday';

  @override
  String get addConsecutiveHoliday => 'Add Consecutive Holidays';

  @override
  String holidayAddedSuccessfully(Object title) {
    return '\"$title\" added successfully! 🎉';
  }

  @override
  String get addOfficeTitle => 'Add New Office';

  @override
  String get officeNameLabel => 'Office Name';

  @override
  String get officeNameHint => 'e.g., Head Office';

  @override
  String get officeNameRequired => 'Name is required';

  @override
  String get officeAddressLabel => 'Office Address';

  @override
  String get officeAddressHint => 'e.g., Agrabad, Chattogram';

  @override
  String get officeAddressRequired => 'Address is required';

  @override
  String get officeStartTimeLabel => 'Office Start Time';

  @override
  String get officeStartTimeHint => 'e.g., 09:00:00';

  @override
  String get officeStartTimeRequired => 'Office start time is required';

  @override
  String get lateTrackingLabel => 'Late Tracking (Minutes)';

  @override
  String get lateTrackingHint => 'e.g., 09:15:00';

  @override
  String get lateTrackingRequired => 'Late tracking time is required';

  @override
  String get officeEndTimeLabel => 'Office End Time';

  @override
  String get officeEndTimeHint => '17:00:00';

  @override
  String get officeEndTimeRequired => 'Office end time is required';

  @override
  String get saveOfficeButton => 'Save Office';

  @override
  String get officeAddedSuccess => 'New office added successfully!';

  @override
  String get officeAddError => 'Failed to add office';

  @override
  String get routerSetSuccess => 'Router successfully set for the office!';

  @override
  String get routerSetFailed => 'Failed to set router';

  @override
  String get edit => 'Edit';

  @override
  String get setRouter => 'Set Router';

  @override
  String get routerList => 'Router List';

  @override
  String get noAddress => 'No address provided';

  @override
  String get startTime => 'Start';

  @override
  String get lateTracking => 'Late Tracking';

  @override
  String get endTime => 'End';

  @override
  String get noOfficeAdded => 'No office added!';

  @override
  String get noRouterSetup => 'No router setup for this office!';

  @override
  String get addNewWifi => 'Add New Wi-Fi';

  @override
  String setRouterForOffice(String officeName) {
    return 'Set Router for $officeName';
  }

  @override
  String configuredRoutersForOffice(String officeName) {
    return 'Configured Routers - $officeName';
  }

  @override
  String get confirmationTitle => 'Confirmation';

  @override
  String deleteOfficeConfirmation(String officeName) {
    return 'Are you sure you want to delete \'$officeName\'? All associated Wi-Fi data may also be deleted.';
  }

  @override
  String get officeDeleteSuccess => 'Office deleted successfully';

  @override
  String get officeDeleteFailed => 'Failed to delete office';

  @override
  String get editOfficeTitle => 'Edit Office Info';

  @override
  String get startTimeLabel => 'Office Start Time';

  @override
  String get startTimeHint => 'e.g., 09:00:00';

  @override
  String get startTimeRequired => 'Start time is required';

  @override
  String get endTimeLabel => 'Office End Time';

  @override
  String get endTimeHint => '17:00:00';

  @override
  String get endTimeRequired => 'End time is required';

  @override
  String get updateInfoButton => 'Update Info';

  @override
  String get officeUpdateSuccess => 'Office updated successfully!';

  @override
  String get officeUpdateFailed => 'Failed to update office';

  @override
  String get routerRemovedSuccess => 'Router removed successfully';

  @override
  String get officeListTitle => 'List of Offices';

  @override
  String get attendanceReportTitle => 'Attendance Report';

  @override
  String employeeReportTitle(Object name) {
    return '$name - Report';
  }

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get novembar => 'November';

  @override
  String get december => 'December';

  @override
  String get reportPeriodLabel => 'Report Period (Month/Year)';

  @override
  String get loading => 'Loading...';

  @override
  String get summaryTitle => 'Summary';

  @override
  String get averageAttendance => 'Avg. Attendance';

  @override
  String get averageLate => 'Avg. Late';

  @override
  String get detailedReportTitle => 'Detailed Report';

  @override
  String get totalTrackedDays => 'Total Tracked Days';

  @override
  String get onTimeAttendance => 'On-time Attendance';

  @override
  String get lateAttendance => 'Late Attendance';

  @override
  String get leaveDays => 'Leave';

  @override
  String get absentDays => 'Absence';

  @override
  String daysFormat(Object count) {
    return '$count Days';
  }

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get employeeReportListTitle => 'Employee Report List';

  @override
  String get loadingText => 'Loading...';

  @override
  String monthlyReportFormat(String monthYear) {
    return 'Report for $monthYear';
  }

  @override
  String totalEmployeesFormat(Object count) {
    return 'Total Employees: $count';
  }

  @override
  String get noDataFound => 'No data found';

  @override
  String get tableColumnId => 'ID';

  @override
  String get tableColumnName => 'Name';

  @override
  String get tableColumnAttendance => 'Attendance';

  @override
  String get tableColumnLate => 'Late';

  @override
  String get tableColumnPercentage => 'Percentage';

  @override
  String get tableColumnAction => 'Action';

  @override
  String get routerListTitle => 'Router List';

  @override
  String get deleteConfirmationTitle => 'Confirmation';

  @override
  String deleteRouterConfirmMessage(String ssid) {
    return 'Are you sure you want to delete \'$ssid\' router?';
  }

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Yes, Delete';

  @override
  String get officeDeletedSuccess => 'Office deleted successfully';

  @override
  String get deleteFailed => 'Failed to delete';

  @override
  String get noRouterSetupText => 'No router setup found!';

  @override
  String get setupNowButton => 'Setup Now';

  @override
  String bssidLabel(String bssid) {
    return 'BSSID: $bssid';
  }

  @override
  String get officeWifiSetupTitle => 'Office Wi-Fi Setup';

  @override
  String get globalWifiSetupTitle => 'Global Wi-Fi Setup';

  @override
  String get wifiAutoSyncedSuccess => 'Current Wi-Fi info auto-synced!';

  @override
  String get locationPermissionRequiredWifi =>
      'Location permission required to auto-sync Wi-Fi info.';

  @override
  String get wifiSaveSuccess => 'Wi-Fi saved successfully!';

  @override
  String get wifiSaveFailed => 'Failed to save Wi-Fi info';

  @override
  String get configureOfficeWifiTitle => 'Configure Office Wi-Fi';

  @override
  String get configureOfficeWifiSubtitle =>
      'Employees cannot mark attendance without connecting to the correct Wi-Fi.';

  @override
  String get wifiNameLabel => 'Wi-Fi Name (SSID)';

  @override
  String get wifiNameHint => 'e.g. Office_Guest_WiFi';

  @override
  String get wifiNameRequired => 'Wi-Fi name is required';

  @override
  String get routerBssidLabel => 'Router ID (BSSID)';

  @override
  String get routerBssidHint => 'e.g. 00:0a:95:9d:68:16';

  @override
  String get routerBssidRequired => 'Router MAC/BSSID is required';

  @override
  String get saveButton => 'Save';

  @override
  String get welcomeTitle => 'Welcome to AttenFI';

  @override
  String get selectAccountTypeSubtitle =>
      'Select your account type to continue';

  @override
  String get adminRoleTitle => 'Admin/Manager';

  @override
  String get adminRoleSubtitle => 'To manage employee attendance';

  @override
  String get employeeRoleTitle => 'Employee';

  @override
  String get employeeRoleSubtitle => 'To mark your attendance as an employee';

  @override
  String get securePlatformText => 'Secure & Encrypted Platform';

  @override
  String get adminLoginSubtitle => 'Login to Admin Panel';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter Password';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccountText => ' Don\'t have an account? ';

  @override
  String get createAccountText => 'Create Account';

  @override
  String get fillEmailAndPasswordValidation =>
      'Please fill in both email and password';

  @override
  String get registerTitle => 'Register';

  @override
  String get ownerNameLabel => 'Owner Name';

  @override
  String get companyNameLabel => 'Company Name';

  @override
  String get employeeRangeLabel => 'Employee Range';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get passwordLabelText => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get completeRegistrationButton => 'Complete Registration';

  @override
  String get fillAllFieldsValidation =>
      'Please fill in all information correctly';

  @override
  String get passwordsDoNotMatchValidation => 'Passwords do not match!';

  @override
  String get range1To10 => '1-10 Employees';

  @override
  String get range11To50 => '11-50 Employees';

  @override
  String get range51To100 => '51-100 Employees';

  @override
  String get range100Plus => '100+ Employees';

  @override
  String get permissionRequiredTitle => 'Permission Required';

  @override
  String get gpsDisabledMessage =>
      'GPS/Location Service is disabled on your phone. Please turn it on.';

  @override
  String get locationPermanentlyBlockedMessage =>
      'You have permanently denied location permission. Please enable it from settings to log in.';

  @override
  String get locationPermissionRequiredMessage =>
      'Location permission is mandatory for Wi-Fi verification.';

  @override
  String get okButton => 'OK';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get provideEmployeeIdError => 'Please enter your employee ID';

  @override
  String get otpSentSuccess => 'OTP has been sent to your registered number';

  @override
  String otpSendError(Object error) {
    return 'Failed to send OTP: $error';
  }

  @override
  String get enterValidOtpError => 'Please enter a valid OTP code';

  @override
  String verificationFailedError(Object error) {
    return 'Verification failed: $error';
  }

  @override
  String get employeeLoginTitle => 'Employee Login';

  @override
  String get enterOtpSubtitle =>
      'Enter the OTP code received on your mobile below';

  @override
  String get enterIdSubtitle => 'Log in with your unique employee ID';

  @override
  String get employeeIdHint => 'Employee ID (e.g., 001100)';

  @override
  String get otpCodeHint => '4 or 6 digit OTP code';

  @override
  String get verifyAndLoginButton => 'Verify & Login';

  @override
  String get sendOtpButton => 'Send OTP';

  @override
  String get changeIdButton => 'Wrong ID? Change here';

  @override
  String get noButton => 'No';

  @override
  String get yesLogoutButton => 'Yes, Logout';

  @override
  String get logoutError => 'Failed to log out. Please try again.';

  @override
  String get userDashboardTitle => 'User Dashboard';

  @override
  String get personalTrackingSection => 'Personal Tracking';

  @override
  String get myProfileMenu => 'My Profile';

  @override
  String get attendanceHistoryMenu => 'Attendance History';

  @override
  String get applicationsSection => 'Applications & Requests';

  @override
  String get leaveApplicationMenu => 'Leave Application';

  @override
  String get lateCondonationMenu => 'Late Condonation Request';

  @override
  String get othersSection => 'Others';

  @override
  String get companyPolicyMenu => 'Company Policy';

  @override
  String get helpAndSupportMenu => 'Help & Support';

  @override
  String get logoutMenu => 'Logout';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get defaultEmployeeName => 'Known Employee';

  @override
  String idLabel(String id) {
    return 'ID: $id';
  }

  @override
  String monthlyReportTitle(String monthYear) {
    return 'This Month\'s Report ($monthYear)';
  }

  @override
  String get statPresent => '✅ Present';

  @override
  String get statLate => '⚠️ Late';

  @override
  String get statLeave => '❌ Leave';

  @override
  String daysCount(Object count) {
    return '$count days';
  }

  @override
  String get latestNotice => 'Latest Notice';

  @override
  String get noticeContent =>
      'All-team weekly meeting will be held today at 4 PM.';

  @override
  String get sessionExpired => 'Login session has expired!';

  @override
  String get holdToCheckIn => 'Hold to Check-In';

  @override
  String get holdToCheckOut => 'Hold to Check-Out';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get checkInUpper => 'CHECK-IN';

  @override
  String get checkOutUpper => 'CHECK-OUT';

  @override
  String get todayLogsTitle => 'Today\'s Logs';

  @override
  String get noAttendanceToday => 'No attendance marked today';

  @override
  String get aths_attendanceHistoryTitle => 'Attendance History';

  @override
  String get aths_selectMonthTitle => 'Select Month';

  @override
  String get aths_navHome => 'Home';

  @override
  String get aths_navHistory => 'History';

  @override
  String get aths_navProfile => 'Profile';

  @override
  String get aths_summaryPresent => '✅ Present';

  @override
  String get aths_summaryLate => '⚠️ Late';

  @override
  String get aths_summaryLeave => '❌ Leave';

  @override
  String aths_daysFormat(String count) {
    return '$count Days';
  }

  @override
  String get aths_filterAll => 'All Days';

  @override
  String get aths_filterPresent => 'Present';

  @override
  String get aths_filterLate => 'Late';

  @override
  String get aths_filterLeave => 'Leave';

  @override
  String get aths_noAttendanceRecord =>
      'No attendance records found in this category.';

  @override
  String get aths_statusPresent => 'Present';

  @override
  String get aths_statusLate => 'Late';

  @override
  String get aths_statusLeave => 'Leave';

  @override
  String get aths_inTime => 'In Time';

  @override
  String get aths_outTime => 'Out Time';

  @override
  String get aths_monthJan => 'January';

  @override
  String get aths_monthFeb => 'February';

  @override
  String get aths_monthMar => 'March';

  @override
  String get aths_monthApr => 'April';

  @override
  String get aths_monthMay => 'May';

  @override
  String get aths_monthJun => 'June';

  @override
  String get aths_monthJul => 'July';

  @override
  String get aths_monthAug => 'August';

  @override
  String get aths_monthSep => 'September';

  @override
  String get aths_monthOct => 'October';

  @override
  String get aths_monthNov => 'November';

  @override
  String get aths_monthDec => 'December';

  @override
  String get eps_profile_title => 'My Profile';

  @override
  String get eps_nav_home => 'Home';

  @override
  String get eps_nav_history => 'History';

  @override
  String get eps_nav_profile => 'Profile';

  @override
  String get eps_default_name => 'Employee';

  @override
  String eps_id_label(Object id) {
    return 'ID: $id';
  }

  @override
  String get eps_not_available => 'N/A';

  @override
  String get eps_no_info => 'No Info';

  @override
  String get eps_mobile_not_found => 'Mobile number not found';

  @override
  String get eps_address_not_found => 'Address not found';

  @override
  String get eps_label_mobile => 'Mobile Number';

  @override
  String get eps_label_nid => 'NID Number';

  @override
  String get eps_label_dob => 'Date of Birth';

  @override
  String get eps_label_father_name => 'Father\'s Name';

  @override
  String get eps_label_mother_name => 'Mother\'s Name';

  @override
  String get eps_label_address => 'Current Address';

  @override
  String get cab_ad_load_error => 'Failed to load advertisement';

  @override
  String get cab_ad_badge => 'Ad';

  @override
  String get cab_admob_placeholder => 'Google AdMob will show here';

  @override
  String get cab_contact_for_ads => 'Contact for Advertisements';

  @override
  String get cab_ad_email => 'adds@AttenFi.live';
}

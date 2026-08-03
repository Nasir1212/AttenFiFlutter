// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get generalSettings => 'সাধারণ সেটিংস';

  @override
  String get settings => 'সেটিংস';

  @override
  String get appLanguage => 'অ্যাপের ভাষা';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get other => 'অন্যান্য';

  @override
  String get holidaySettings => 'ছুটির সেটিং';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get version => 'ভার্সন';

  @override
  String get appName => 'AttenFI';

  @override
  String get adminManager => 'অ্যাডমিন/ম্যানেজার';

  @override
  String get logoutConfirmTitle => 'লগআউট নিশ্চিত করুন';

  @override
  String get logoutConfirmMessage =>
      'আপনি কি নিশ্চিতভাবেই আপনার অ্যাকাউন্ট থেকে লগআউট করতে চান?';

  @override
  String get no => 'না';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get logOutTooltip => 'লগ আউট';

  @override
  String get todayStats => 'আজকের পরিসংখ্যান';

  @override
  String get totalEmployee => 'মোট কর্মচারী';

  @override
  String get present => 'উপস্থিত';

  @override
  String get absent => 'অনুপস্থিত';

  @override
  String get late => 'দেরি (Late)';

  @override
  String get quickActions => 'কুইক অ্যাকশন';

  @override
  String get staff => 'স্টাফ';

  @override
  String get router => 'রাউটার';

  @override
  String get report => 'রিপোর্ট';

  @override
  String get office => 'অফিস';

  @override
  String get holiday => 'ছুটি';

  @override
  String get otp => 'ওটিপি';

  @override
  String get recentAttendance => 'সাম্প্রতিক উপস্থিতি';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get noAttendanceLogs => 'আজকে এখনও কোনো হাজিরার লগ নেই।';

  @override
  String timeFormat(String time) {
    return 'সময়: $time';
  }

  @override
  String get onTime => 'সময়মতো';

  @override
  String get unknown => 'অজানা';

  @override
  String get addEmployeeTitle => 'নতুন কর্মচারী যোগ করুন';

  @override
  String get employeeName => 'কর্মচারীর নাম';

  @override
  String get fatherName => 'পিতার নাম';

  @override
  String get motherName => 'মাতার নাম';

  @override
  String get nidNumber => 'এনআইডি (NID) নম্বর';

  @override
  String get dateOfBirth => 'জন্ম তারিখ';

  @override
  String get dobHint => 'DD/MM/YYYY';

  @override
  String get mobileNumber => 'মোবাইল নম্বর';

  @override
  String get fullAddress => 'সম্পূর্ণ ঠিকানা';

  @override
  String get saveInformation => 'তথ্য সংরক্ষণ করুন';

  @override
  String get validationRequiredFields =>
      '* নাম, মোবাইল এবং ঠিকানা অবশ্যই পূরণ করুন';

  @override
  String get sessionExpiredMessage =>
      'সেশন শেষ হয়ে গেছে! অনুগ্রহ করে আবার লগইন করুন।';

  @override
  String get employeeAddedSuccess => 'কর্মচারী সফলভাবে যোগ করা হয়েছে';

  @override
  String get employeeDetailsTitle => 'কর্মচারীর তথ্য';

  @override
  String get employeeRole => 'কর্মচারী';

  @override
  String get institutionalInfo => 'প্রাতিষ্ঠানিক তথ্য';

  @override
  String get employeeId => 'এমপ্লয়ে আইডি';

  @override
  String get idNotFound => 'আইডি পাওয়া যায়নি';

  @override
  String get personalInfo => 'ব্যক্তিগত তথ্য';

  @override
  String get notSpecified => 'উল্লেখ নেই';

  @override
  String get contactInfo => 'যোগাযোগের তথ্য';

  @override
  String get editInformation => 'তথ্য পরিবর্তন করুন';

  @override
  String get editEmployeeTitle => 'তথ্য পরিবর্তন করুন';

  @override
  String get selectFromGallery => 'গ্যালারি থেকে সিলেক্ট করুন';

  @override
  String get takePhotoWithCamera => 'ক্যামেরা দিয়ে ছবি তুলুন';

  @override
  String employeeIdLabel(Object id) {
    return 'কর্মচারী আইডি: $id';
  }

  @override
  String get updateButton => 'হালনাগাদ করুন';

  @override
  String get updateSuccess => 'আপডেট করা হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন!';

  @override
  String get nameRequired => 'নাম আবশ্যক';

  @override
  String get mobileRequired => 'মোবাইল নম্বর আবশ্যক';

  @override
  String get confirmTitle => 'নিশ্চিত করুন';

  @override
  String deleteEmployeeConfirmation(Object employeeName) {
    return 'আপনি কি নিশ্চিত \'$employeeName\' কে তালিকা থেকে ডিলিট করতে চান?';
  }

  @override
  String get cancel => 'বাতিল';

  @override
  String get delete => 'হ্যাঁ, ডিলিট করুন';

  @override
  String get deletedSuccessfully => 'ডিলিট করা হয়েছে';

  @override
  String get allEmployeesList => 'সব কর্মচারীর তালিকা';

  @override
  String get noEmployeeDataFound => 'কোনো কর্মচারীর তথ্য পাওয়া যায়নি।';

  @override
  String get searchHint => 'নাম বা আইডি দিয়ে খুঁজুন...';

  @override
  String get notFound => 'পাওয়া যায়নি!';

  @override
  String get image => 'ছবি';

  @override
  String get details => 'বিবরণ';

  @override
  String get action => 'অ্যাকশন';

  @override
  String get noId => 'আইডি নেই';

  @override
  String get addEmployee => 'কর্মচারী যোগ করুন';

  @override
  String get holidayUploadCalendarTitle => 'ছুটির দিন আপলোড স্ক্রিন';

  @override
  String get singleDayGuidance =>
      '👉 ১ দিনের ছুটি: যেকোনো একটি তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।';

  @override
  String get multiDayGuidance =>
      '👉 একাধিক দিনের ছুটি: প্রথম ও শেষ তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।';

  @override
  String get addSingleDayHolidayTitle => '১ দিনের ছুটি যোগ করুন';

  @override
  String get addMultiDayHolidayTitle => 'টানা ছুটি যোগ করুন';

  @override
  String singleDateText(Object date) {
    return 'তারিখ: $date';
  }

  @override
  String dateRangeText(Object end, Object start) {
    return 'মেয়াদ: $start থেকে $end';
  }

  @override
  String get holidayTitleHint => 'উদা: ঈদের ছুটি, স্বাধীনতা দিবস';

  @override
  String get holidayTitleLabel => 'ছুটি বা উৎসবের নাম';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get addHoliday => 'ছুটি যোগ করুন';

  @override
  String get addConsecutiveHoliday => 'টানা ছুটি যোগ করুন';

  @override
  String holidayAddedSuccessfully(Object title) {
    return '\"$title\" সফলভাবে যুক্ত হয়েছে! 🎉';
  }

  @override
  String get addOfficeTitle => 'নতুন অফিস যুক্ত করুন';

  @override
  String get officeNameLabel => 'অফিসের নাম';

  @override
  String get officeNameHint => 'উদা: প্রধান কার্যালয়';

  @override
  String get officeNameRequired => 'নাম আবশ্যক';

  @override
  String get officeAddressLabel => 'অফিসের ঠিকানা';

  @override
  String get officeAddressHint => 'উদা: আগ্রাবাদ, চট্টগ্রাম';

  @override
  String get officeAddressRequired => 'ঠিকানা আবশ্যক';

  @override
  String get officeStartTimeLabel => 'অফিসের শুরুর সময়';

  @override
  String get officeStartTimeHint => 'উদা: 09:00:00';

  @override
  String get officeStartTimeRequired => 'অফিসের শুরুর সময় আবশ্যক';

  @override
  String get lateTrackingLabel => 'লেট ট্র্যাকিং কত মিনিট ?';

  @override
  String get lateTrackingHint => 'উদা: 09:15:00';

  @override
  String get lateTrackingRequired => 'লেট ট্র্যাকিং সময় আবশ্যক';

  @override
  String get officeEndTimeLabel => 'অফিসের ছুটির সময়';

  @override
  String get officeEndTimeHint => '17:00:00';

  @override
  String get officeEndTimeRequired => 'অফিসের ছুটির সময় আবশ্যক';

  @override
  String get saveOfficeButton => 'অফিস সংরক্ষণ করুন';

  @override
  String get officeAddedSuccess => 'নতুন অফিস সফলভাবে যুক্ত হয়েছে!';

  @override
  String get officeAddError => 'অফিস যুক্ত করতে সমস্যা হয়েছে';

  @override
  String get routerSetSuccess => 'অফিসে রাউটারটি সফলভাবে সেট করা হয়েছে!';

  @override
  String get routerSetFailed => 'রাউটার সেট করতে সমস্যা হয়েছে';

  @override
  String get edit => 'সংশোধন';

  @override
  String get setRouter => 'রাউটার সেট করুন';

  @override
  String get routerList => 'রাউটার লিস্ট';

  @override
  String get noAddress => 'ঠিকানা দেওয়া হয়নি';

  @override
  String get startTime => 'শুরু';

  @override
  String get lateTracking => 'লেট ট্র্যাকিং';

  @override
  String get endTime => 'ছুটি';

  @override
  String get noOfficeAdded => 'কোনো অফিস যুক্ত করা হয়নি!';

  @override
  String get noRouterSetup => 'এই অফিসের জন্য কোনো রাউটার সেটআপ করা নেই!';

  @override
  String get addNewWifi => 'নতুন ওয়াইফাই যুক্ত করুন';

  @override
  String setRouterForOffice(String officeName) {
    return '$officeName -তে রাউটার সেট করুন';
  }

  @override
  String configuredRoutersForOffice(String officeName) {
    return '$officeName - সেটকৃত রাউটার';
  }

  @override
  String get confirmationTitle => 'নিশ্চিতকরণ';

  @override
  String deleteOfficeConfirmation(String officeName) {
    return '\'$officeName\' অফিসটি ডিলিট করতে চান? এর সাথে যুক্ত সকল ওয়াইফাই ডাটাও মুছে যেতে পারে।';
  }

  @override
  String get officeDeleteSuccess => 'অফিসটি সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String get officeDeleteFailed => 'মুছে ফেলতে সমস্যা হয়েছে';

  @override
  String get editOfficeTitle => 'অফিস তথ্য সংশোধন';

  @override
  String get startTimeLabel => 'অফিসের শুরুর সময়';

  @override
  String get startTimeHint => 'উদা: 09:00:00';

  @override
  String get startTimeRequired => 'অফিসের শুরুর সময় আবশ্যক';

  @override
  String get endTimeLabel => 'অফিসের ছুটির সময়';

  @override
  String get endTimeHint => '17:00:00';

  @override
  String get endTimeRequired => 'অফিসের ছুটির সময় আবশ্যক';

  @override
  String get updateInfoButton => 'তথ্য আপডেট করুন';

  @override
  String get officeUpdateSuccess => 'অফিস সফলভাবে আপডেট হয়েছে!';

  @override
  String get officeUpdateFailed => 'আপডেট করতে সমস্যা হয়েছে';

  @override
  String get routerRemovedSuccess => 'রাউটারটি সফলভাবে রিমুভ করা হয়েছে';

  @override
  String get officeListTitle => 'অফিস সমূহের তালিকা';

  @override
  String get attendanceReportTitle => 'উপস্থিতি রিপোর্ট';

  @override
  String employeeReportTitle(Object name) {
    return '$name - রিপোর্ট';
  }

  @override
  String get january => 'জানুয়ারী';

  @override
  String get february => 'ফেব্রুয়ারী';

  @override
  String get march => 'মার্চ';

  @override
  String get april => 'এপ্রিল';

  @override
  String get may => 'মে';

  @override
  String get june => 'জুন';

  @override
  String get july => 'জুলাই';

  @override
  String get august => 'আগস্ট';

  @override
  String get september => 'সেপ্টেম্বর';

  @override
  String get october => 'অক্টোবর';

  @override
  String get novembar => 'নভেম্বর';

  @override
  String get december => 'ডিসেম্বর';

  @override
  String get reportPeriodLabel => 'রিপোর্টের সময়সীমা (মাস/বছর)';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get summaryTitle => 'সামারি (Summary)';

  @override
  String get averageAttendance => 'গড় উপস্থিতি';

  @override
  String get averageLate => 'গড় লেট';

  @override
  String get detailedReportTitle => 'বিস্তারিত রিপোর্ট';

  @override
  String get totalTrackedDays => 'মোট ট্র্যাকড দিন';

  @override
  String get onTimeAttendance => 'সময়মতো উপস্থিতি';

  @override
  String get lateAttendance => 'দেরিতে উপস্থিতি';

  @override
  String get leaveDays => 'ছুটি (Leave)';

  @override
  String get absentDays => 'অনুপস্থিতি';

  @override
  String daysFormat(Object count) {
    return '$count দিন';
  }

  @override
  String get downloadPdf => 'পিডিএফ (PDF) ডাউনলোড করুন';

  @override
  String get employeeReportListTitle => 'কর্মচারী রিপোর্ট তালিকা';

  @override
  String get loadingText => 'লোড হচ্ছে...';

  @override
  String monthlyReportFormat(String monthYear) {
    return '$monthYear-এর রিপোর্ট';
  }

  @override
  String totalEmployeesFormat(Object count) {
    return 'মোট কর্মচারী: $count জন';
  }

  @override
  String get noDataFound => 'কোনো ডাটা পাওয়া যায়নি';

  @override
  String get tableColumnId => 'আইডি';

  @override
  String get tableColumnName => 'নাম';

  @override
  String get tableColumnAttendance => 'উপস্থিতি';

  @override
  String get tableColumnLate => 'লেট';

  @override
  String get tableColumnPercentage => 'শতকরা';

  @override
  String get tableColumnAction => 'অ্যাকশন';

  @override
  String get routerListTitle => 'রাউটারের তালিকা';

  @override
  String get deleteConfirmationTitle => 'নিশ্চিতকরণ';

  @override
  String deleteRouterConfirmMessage(String ssid) {
    return '\'$ssid\' রাউটারটি ডিলিট করতে চাচ্ছেন?';
  }

  @override
  String get cancelButton => 'বাতিল';

  @override
  String get deleteButton => 'হ্যাঁ, ডিলিট করুন';

  @override
  String get officeDeletedSuccess => 'অফিসটি সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String get deleteFailed => 'মুছে ফেলতে সমস্যা হয়েছে';

  @override
  String get noRouterSetupText => 'রাউটার সেটআপ করা নেই!';

  @override
  String get setupNowButton => 'এখনই সেটআপ করুন';

  @override
  String bssidLabel(String bssid) {
    return 'BSSID: $bssid';
  }

  @override
  String get officeWifiSetupTitle => 'অফিস ওয়াইফাই সেটআপ';

  @override
  String get globalWifiSetupTitle => 'গ্লোবাল ওয়াইফাই সেটআপ';

  @override
  String get wifiAutoSyncedSuccess =>
      'বর্তমান ওয়াইফাই তথ্য অটো-সিঙ্ক করা হয়েছে!';

  @override
  String get locationPermissionRequiredWifi =>
      'ওয়াইফাই তথ্য অটো-সিঙ্ক করতে লোকেশন পারমিশন প্রয়োজন।';

  @override
  String get wifiSaveSuccess => 'ওয়াইফাই সফলভাবে সংরক্ষিত হয়েছে!';

  @override
  String get wifiSaveFailed => 'ওয়াইফাই সংরক্ষণ করতে সমস্যা হয়েছে';

  @override
  String get configureOfficeWifiTitle => 'অফিসের ওয়াইফাই কনফিগার করুন';

  @override
  String get configureOfficeWifiSubtitle =>
      'সঠিক ওয়াইফাই কানেক্ট না থাকলে কর্মচারীরা হাজিরা দিতে পারবে না।';

  @override
  String get wifiNameLabel => 'ওয়াইফাই নাম (SSID)';

  @override
  String get wifiNameHint => 'উদা: Office_Guest_WiFi';

  @override
  String get wifiNameRequired => 'ওয়াইফাই নাম আবশ্যক';

  @override
  String get routerBssidLabel => 'রাউটার আইডি (BSSID)';

  @override
  String get routerBssidHint => 'উদা: 00:0a:95:9d:68:16';

  @override
  String get routerBssidRequired => 'রাউটার ম্যাক/BSSID আবশ্যক';

  @override
  String get saveButton => 'সেভ করুন';

  @override
  String get welcomeTitle => 'স্বাগতম AttenFI-তে';

  @override
  String get selectAccountTypeSubtitle =>
      'অ্যাপটি ব্যবহার করতে আপনার অ্যাকাউন্ট টাইপ সিলেক্ট করুন';

  @override
  String get adminRoleTitle => 'এডমিন/ম্যানেজার';

  @override
  String get adminRoleSubtitle => 'কর্মচারিদের হাজিরা ম্যানেজমেন্ট করতে';

  @override
  String get employeeRoleTitle => 'কর্মচারি';

  @override
  String get employeeRoleSubtitle => 'কর্মচারি হিসাবে হাজিরা দিতে';

  @override
  String get securePlatformText => 'Secure & Encrypted Platform';

  @override
  String get adminLoginSubtitle => 'অ্যাডমিন প্যানেলে লগইন করুন';

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get emailHint => 'ইমেইল অ্যাড্রেস';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get passwordHint => 'পাসওয়ার্ড দিন';

  @override
  String get loginButton => 'লগইন';

  @override
  String get noAccountText => ' আপনার কি একাউন্ট নাই ? ';

  @override
  String get createAccountText => 'একাউন্ট তৈরী করুন';

  @override
  String get fillEmailAndPasswordValidation =>
      'ইমেইল এবং পাসওয়ার্ড দুটিই পূরণ করুন';

  @override
  String get registerTitle => 'নিবন্ধন করুন';

  @override
  String get ownerNameLabel => 'মালিকের নাম';

  @override
  String get companyNameLabel => 'প্রতিষ্ঠানের নাম';

  @override
  String get employeeRangeLabel => 'কতজন কর্মচারী';

  @override
  String get emailAddressLabel => 'ইমেইল অ্যাড্রেস';

  @override
  String get phoneNumberLabel => 'ফোন নম্বর';

  @override
  String get passwordLabelText => 'পাসওয়ার্ড';

  @override
  String get confirmPasswordLabel => 'কনফার্ম পাসওয়ার্ড';

  @override
  String get completeRegistrationButton => 'নিবন্ধন সম্পন্ন করুন';

  @override
  String get fillAllFieldsValidation => 'সবগুলো তথ্য সঠিকভাবে পূরণ করুন';

  @override
  String get passwordsDoNotMatchValidation => 'পাসওয়ার্ড দুটি মিলছে না!';

  @override
  String get range1To10 => '১-১০ জন';

  @override
  String get range11To50 => '১১-৫০ জন';

  @override
  String get range51To100 => '৫১-১০০ জন';

  @override
  String get range100Plus => '১০০+ জন';

  @override
  String get permissionRequiredTitle => 'অনুমতি প্রয়োজন';

  @override
  String get gpsDisabledMessage =>
      'আপনার ফোনের GPS/Location Service বন্ধ আছে। দয়া করে এটি অন করুন।';

  @override
  String get locationPermanentlyBlockedMessage =>
      'আপনি লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করেছেন। লগইন করতে ফোনের সেটিংস থেকে অনুমতি অন করুন।';

  @override
  String get locationPermissionRequiredMessage =>
      'ওয়াইফাই ভেরিফিকেশনের জন্য লোকেশন পারমিশন দেওয়া বাধ্যতামূলক।';

  @override
  String get okButton => 'ঠিক আছে';

  @override
  String get openSettingsButton => 'সেটিংস ওপেন করুন';

  @override
  String get tryAgainButton => 'আবার চেষ্টা করুন';

  @override
  String get provideEmployeeIdError => 'অনুগ্রহ করে আপনার আইডি প্রদান করুন';

  @override
  String get otpSentSuccess => 'আপনার রেজিস্টার্ড নাম্বারে ওটিপি পাঠানো হয়েছে';

  @override
  String otpSendError(Object error) {
    return 'ওটিপি পাঠাতে সমস্যা হয়েছে: $error';
  }

  @override
  String get enterValidOtpError => 'অনুগ্রহ করে সঠিক ওটিপি কোডটি দিন';

  @override
  String verificationFailedError(Object error) {
    return 'ভেরিফিকেশন ব্যর্থ হয়েছে: $error';
  }

  @override
  String get employeeLoginTitle => 'কর্মচারী লগইন';

  @override
  String get enterOtpSubtitle =>
      'আপনার মোবাইলে প্রাপ্ত ওটিপি কোডটি নিচে প্রদান করুন';

  @override
  String get enterIdSubtitle => 'আপনার ইউনিক কর্মচারী আইডি দিয়ে লগইন করুন';

  @override
  String get employeeIdHint => 'কর্মচারীর আইডি (যেমন: 001100)';

  @override
  String get otpCodeHint => '৪ বা ৬ ডিজিটের ওটিপি কোড';

  @override
  String get verifyAndLoginButton => 'ভেরিফাই ও লগইন';

  @override
  String get sendOtpButton => 'ওটিপি পাঠান';

  @override
  String get changeIdButton => 'আইডি ভুল হয়েছে? পরিবর্তন করুন';

  @override
  String get noButton => 'না';

  @override
  String get yesLogoutButton => 'হ্যাঁ, লগআউট করুন';

  @override
  String get logoutError => 'লগআউট করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get userDashboardTitle => 'ইউজার ড্যাশবোর্ড';

  @override
  String get personalTrackingSection => 'ব্যক্তিগত ট্র্যাকিং';

  @override
  String get myProfileMenu => 'আমার প্রোফাইল';

  @override
  String get attendanceHistoryMenu => 'হাজিরা হিস্ট্রি';

  @override
  String get applicationsSection => 'আবেদন ও অনুরোধ';

  @override
  String get leaveApplicationMenu => 'ছুটির আবেদন (Leave)';

  @override
  String get lateCondonationMenu => 'লেট কনডোন আবেদন';

  @override
  String get othersSection => 'অন্যান্য';

  @override
  String get companyPolicyMenu => 'কোম্পানি পলিসি';

  @override
  String get helpAndSupportMenu => 'হেল্প ও সাপোর্ট';

  @override
  String get logoutMenu => 'লগআউট';

  @override
  String get appVersion => 'ভার্সন ১.০.০';

  @override
  String get navHome => 'হোম';

  @override
  String get navHistory => 'হিস্ট্রি';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get defaultEmployeeName => 'পরিচিত কর্মী';

  @override
  String idLabel(String id) {
    return 'আইডি: $id';
  }

  @override
  String monthlyReportTitle(String monthYear) {
    return 'এই মাসের রিপোর্ট ($monthYear)';
  }

  @override
  String get statPresent => '✅ উপস্থিত';

  @override
  String get statLate => '⚠️ লেট';

  @override
  String get statLeave => '❌ ছুটি';

  @override
  String daysCount(Object count) {
    return '$count দিন';
  }

  @override
  String get latestNotice => 'সর্বশেষ নোটিশ';

  @override
  String get noticeContent => 'আজ বিকেল ৪টায় অল-টিম উইকলি মিটিং অনুষ্ঠিত হবে।';

  @override
  String get sessionExpired => 'লগইন সেশন শেষ হয়ে গেছে!';

  @override
  String get holdToCheckIn => 'চেক-ইন করতে চেপে ধরে রাখুন';

  @override
  String get holdToCheckOut => 'চেক-আউট করতে চেপে ধরে রাখুন';

  @override
  String get processingWait => 'প্রসেস হচ্ছে, অনুগ্রহ করে অপেক্ষা করুন...';

  @override
  String get checkInUpper => 'CHECK-IN';

  @override
  String get checkOutUpper => 'CHECK-OUT';

  @override
  String get todayLogsTitle => 'আজকের টাইমলাইন (Today\'s Logs)';

  @override
  String get noAttendanceToday => 'আজকে এখনও কোনো হাজিরা দেওয়া হয়নি';

  @override
  String get aths_attendanceHistoryTitle => 'হাজিরা হিস্ট্রি';

  @override
  String get aths_selectMonthTitle => 'মাস নির্বাচন করুন';

  @override
  String get aths_navHome => 'হোম';

  @override
  String get aths_navHistory => 'হিস্ট্রি';

  @override
  String get aths_navProfile => 'প্রোফাইল';

  @override
  String get aths_summaryPresent => '✅ উপস্থিত';

  @override
  String get aths_summaryLate => '⚠️ লেট';

  @override
  String get aths_summaryLeave => '❌ ছুটি';

  @override
  String aths_daysFormat(String count) {
    return '$count দিন';
  }

  @override
  String get aths_filterAll => 'সব দিন';

  @override
  String get aths_filterPresent => 'উপস্থিত';

  @override
  String get aths_filterLate => 'লেট';

  @override
  String get aths_filterLeave => 'ছুটি';

  @override
  String get aths_noAttendanceRecord =>
      'এই ক্যাটাগরিতে কোনো হাজিরা রেকর্ড নেই।';

  @override
  String get aths_statusPresent => 'উপস্থিত';

  @override
  String get aths_statusLate => 'লেট';

  @override
  String get aths_statusLeave => 'ছুটি';

  @override
  String get aths_inTime => 'ইন টাইম';

  @override
  String get aths_outTime => 'আউট টাইম';

  @override
  String get aths_monthJan => 'জানুয়ারি';

  @override
  String get aths_monthFeb => 'ফেব্রুয়ারি';

  @override
  String get aths_monthMar => 'মার্চ';

  @override
  String get aths_monthApr => 'এপ্রিল';

  @override
  String get aths_monthMay => 'মে';

  @override
  String get aths_monthJun => 'জুন';

  @override
  String get aths_monthJul => 'জুলাই';

  @override
  String get aths_monthAug => 'আগস্ট';

  @override
  String get aths_monthSep => 'সেপ্টেম্বর';

  @override
  String get aths_monthOct => 'অক্টোবর';

  @override
  String get aths_monthNov => 'নভেম্বর';

  @override
  String get aths_monthDec => 'ডিসেম্বর';

  @override
  String get eps_profile_title => 'আমার প্রোফাইল';

  @override
  String get eps_nav_home => 'হোম';

  @override
  String get eps_nav_history => 'হিস্ট্রি';

  @override
  String get eps_nav_profile => 'প্রোফাইল';

  @override
  String get eps_default_name => 'পরিচিত কর্মী';

  @override
  String eps_id_label(Object id) {
    return 'আইডি: $id';
  }

  @override
  String get eps_not_available => 'N/A';

  @override
  String get eps_no_info => 'তথ্য নেই';

  @override
  String get eps_mobile_not_found => 'মোবাইল নম্বর পাওয়া যায়নি';

  @override
  String get eps_address_not_found => 'ঠিকানা পাওয়া যায়নি';

  @override
  String get eps_label_mobile => 'মোবাইল নম্বর';

  @override
  String get eps_label_nid => 'এনআইডি (NID)';

  @override
  String get eps_label_dob => 'জন্ম তারিখ';

  @override
  String get eps_label_father_name => 'পিতার নাম';

  @override
  String get eps_label_mother_name => 'মাতার নাম';

  @override
  String get eps_label_address => 'বর্তমান ঠিকানা';

  @override
  String get cab_ad_load_error => 'বিজ্ঞাপন লোড হতে সমস্যা হয়েছে';

  @override
  String get cab_ad_badge => 'Ad';

  @override
  String get cab_admob_placeholder => 'এখানে গুগল এডমোব শো করবে';

  @override
  String get cab_contact_for_ads => 'বিজ্ঞাপনের জন্য যোগাযোগ করুন';

  @override
  String get cab_ad_email => 'adds@AttenFi.live';
}

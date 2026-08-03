import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @generalSettings.
  ///
  /// In bn, this message translates to:
  /// **'সাধারণ সেটিংস'**
  String get generalSettings;

  /// No description provided for @settings.
  ///
  /// In bn, this message translates to:
  /// **'সেটিংস'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাপের ভাষা'**
  String get appLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা নির্বাচন করুন'**
  String get selectLanguage;

  /// No description provided for @other.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get other;

  /// No description provided for @holidaySettings.
  ///
  /// In bn, this message translates to:
  /// **'ছুটির সেটিং'**
  String get holidaySettings;

  /// No description provided for @changePassword.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড পরিবর্তন'**
  String get changePassword;

  /// No description provided for @version.
  ///
  /// In bn, this message translates to:
  /// **'ভার্সন'**
  String get version;

  /// No description provided for @appName.
  ///
  /// In bn, this message translates to:
  /// **'AttenFI'**
  String get appName;

  /// No description provided for @adminManager.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিন/ম্যানেজার'**
  String get adminManager;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট নিশ্চিত করুন'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কি নিশ্চিতভাবেই আপনার অ্যাকাউন্ট থেকে লগআউট করতে চান?'**
  String get logoutConfirmMessage;

  /// No description provided for @no.
  ///
  /// In bn, this message translates to:
  /// **'না'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ'**
  String get yes;

  /// No description provided for @logOutTooltip.
  ///
  /// In bn, this message translates to:
  /// **'লগ আউট'**
  String get logOutTooltip;

  /// No description provided for @todayStats.
  ///
  /// In bn, this message translates to:
  /// **'আজকের পরিসংখ্যান'**
  String get todayStats;

  /// No description provided for @totalEmployee.
  ///
  /// In bn, this message translates to:
  /// **'মোট কর্মচারী'**
  String get totalEmployee;

  /// No description provided for @present.
  ///
  /// In bn, this message translates to:
  /// **'উপস্থিত'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In bn, this message translates to:
  /// **'অনুপস্থিত'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In bn, this message translates to:
  /// **'দেরি (Late)'**
  String get late;

  /// No description provided for @quickActions.
  ///
  /// In bn, this message translates to:
  /// **'কুইক অ্যাকশন'**
  String get quickActions;

  /// No description provided for @staff.
  ///
  /// In bn, this message translates to:
  /// **'স্টাফ'**
  String get staff;

  /// No description provided for @router.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার'**
  String get router;

  /// No description provided for @report.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্ট'**
  String get report;

  /// No description provided for @office.
  ///
  /// In bn, this message translates to:
  /// **'অফিস'**
  String get office;

  /// No description provided for @holiday.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি'**
  String get holiday;

  /// No description provided for @otp.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি'**
  String get otp;

  /// No description provided for @recentAttendance.
  ///
  /// In bn, this message translates to:
  /// **'সাম্প্রতিক উপস্থিতি'**
  String get recentAttendance;

  /// No description provided for @seeAll.
  ///
  /// In bn, this message translates to:
  /// **'সব দেখুন'**
  String get seeAll;

  /// No description provided for @noAttendanceLogs.
  ///
  /// In bn, this message translates to:
  /// **'আজকে এখনও কোনো হাজিরার লগ নেই।'**
  String get noAttendanceLogs;

  /// No description provided for @timeFormat.
  ///
  /// In bn, this message translates to:
  /// **'সময়: {time}'**
  String timeFormat(String time);

  /// No description provided for @onTime.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো'**
  String get onTime;

  /// No description provided for @unknown.
  ///
  /// In bn, this message translates to:
  /// **'অজানা'**
  String get unknown;

  /// No description provided for @addEmployeeTitle.
  ///
  /// In bn, this message translates to:
  /// **'নতুন কর্মচারী যোগ করুন'**
  String get addEmployeeTitle;

  /// No description provided for @employeeName.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারীর নাম'**
  String get employeeName;

  /// No description provided for @fatherName.
  ///
  /// In bn, this message translates to:
  /// **'পিতার নাম'**
  String get fatherName;

  /// No description provided for @motherName.
  ///
  /// In bn, this message translates to:
  /// **'মাতার নাম'**
  String get motherName;

  /// No description provided for @nidNumber.
  ///
  /// In bn, this message translates to:
  /// **'এনআইডি (NID) নম্বর'**
  String get nidNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In bn, this message translates to:
  /// **'জন্ম তারিখ'**
  String get dateOfBirth;

  /// No description provided for @dobHint.
  ///
  /// In bn, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dobHint;

  /// No description provided for @mobileNumber.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get mobileNumber;

  /// No description provided for @fullAddress.
  ///
  /// In bn, this message translates to:
  /// **'সম্পূর্ণ ঠিকানা'**
  String get fullAddress;

  /// No description provided for @saveInformation.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য সংরক্ষণ করুন'**
  String get saveInformation;

  /// No description provided for @validationRequiredFields.
  ///
  /// In bn, this message translates to:
  /// **'* নাম, মোবাইল এবং ঠিকানা অবশ্যই পূরণ করুন'**
  String get validationRequiredFields;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In bn, this message translates to:
  /// **'সেশন শেষ হয়ে গেছে! অনুগ্রহ করে আবার লগইন করুন।'**
  String get sessionExpiredMessage;

  /// No description provided for @employeeAddedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী সফলভাবে যোগ করা হয়েছে'**
  String get employeeAddedSuccess;

  /// No description provided for @employeeDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারীর তথ্য'**
  String get employeeDetailsTitle;

  /// No description provided for @employeeRole.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী'**
  String get employeeRole;

  /// No description provided for @institutionalInfo.
  ///
  /// In bn, this message translates to:
  /// **'প্রাতিষ্ঠানিক তথ্য'**
  String get institutionalInfo;

  /// No description provided for @employeeId.
  ///
  /// In bn, this message translates to:
  /// **'এমপ্লয়ে আইডি'**
  String get employeeId;

  /// No description provided for @idNotFound.
  ///
  /// In bn, this message translates to:
  /// **'আইডি পাওয়া যায়নি'**
  String get idNotFound;

  /// No description provided for @personalInfo.
  ///
  /// In bn, this message translates to:
  /// **'ব্যক্তিগত তথ্য'**
  String get personalInfo;

  /// No description provided for @notSpecified.
  ///
  /// In bn, this message translates to:
  /// **'উল্লেখ নেই'**
  String get notSpecified;

  /// No description provided for @contactInfo.
  ///
  /// In bn, this message translates to:
  /// **'যোগাযোগের তথ্য'**
  String get contactInfo;

  /// No description provided for @editInformation.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য পরিবর্তন করুন'**
  String get editInformation;

  /// No description provided for @editEmployeeTitle.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য পরিবর্তন করুন'**
  String get editEmployeeTitle;

  /// No description provided for @selectFromGallery.
  ///
  /// In bn, this message translates to:
  /// **'গ্যালারি থেকে সিলেক্ট করুন'**
  String get selectFromGallery;

  /// No description provided for @takePhotoWithCamera.
  ///
  /// In bn, this message translates to:
  /// **'ক্যামেরা দিয়ে ছবি তুলুন'**
  String get takePhotoWithCamera;

  /// No description provided for @employeeIdLabel.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী আইডি: {id}'**
  String employeeIdLabel(Object id);

  /// No description provided for @updateButton.
  ///
  /// In bn, this message translates to:
  /// **'হালনাগাদ করুন'**
  String get updateButton;

  /// No description provided for @updateSuccess.
  ///
  /// In bn, this message translates to:
  /// **'আপডেট করা হয়েছে'**
  String get updateSuccess;

  /// No description provided for @tryAgain.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন!'**
  String get tryAgain;

  /// No description provided for @nameRequired.
  ///
  /// In bn, this message translates to:
  /// **'নাম আবশ্যক'**
  String get nameRequired;

  /// No description provided for @mobileRequired.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর আবশ্যক'**
  String get mobileRequired;

  /// No description provided for @confirmTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিত করুন'**
  String get confirmTitle;

  /// No description provided for @deleteEmployeeConfirmation.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কি নিশ্চিত \'{employeeName}\' কে তালিকা থেকে ডিলিট করতে চান?'**
  String deleteEmployeeConfirmation(Object employeeName);

  /// No description provided for @cancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, ডিলিট করুন'**
  String get delete;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In bn, this message translates to:
  /// **'ডিলিট করা হয়েছে'**
  String get deletedSuccessfully;

  /// No description provided for @allEmployeesList.
  ///
  /// In bn, this message translates to:
  /// **'সব কর্মচারীর তালিকা'**
  String get allEmployeesList;

  /// No description provided for @noEmployeeDataFound.
  ///
  /// In bn, this message translates to:
  /// **'কোনো কর্মচারীর তথ্য পাওয়া যায়নি।'**
  String get noEmployeeDataFound;

  /// No description provided for @searchHint.
  ///
  /// In bn, this message translates to:
  /// **'নাম বা আইডি দিয়ে খুঁজুন...'**
  String get searchHint;

  /// No description provided for @notFound.
  ///
  /// In bn, this message translates to:
  /// **'পাওয়া যায়নি!'**
  String get notFound;

  /// No description provided for @image.
  ///
  /// In bn, this message translates to:
  /// **'ছবি'**
  String get image;

  /// No description provided for @details.
  ///
  /// In bn, this message translates to:
  /// **'বিবরণ'**
  String get details;

  /// No description provided for @action.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকশন'**
  String get action;

  /// No description provided for @noId.
  ///
  /// In bn, this message translates to:
  /// **'আইডি নেই'**
  String get noId;

  /// No description provided for @addEmployee.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী যোগ করুন'**
  String get addEmployee;

  /// No description provided for @holidayUploadCalendarTitle.
  ///
  /// In bn, this message translates to:
  /// **'ছুটির দিন আপলোড স্ক্রিন'**
  String get holidayUploadCalendarTitle;

  /// No description provided for @singleDayGuidance.
  ///
  /// In bn, this message translates to:
  /// **'👉 ১ দিনের ছুটি: যেকোনো একটি তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।'**
  String get singleDayGuidance;

  /// No description provided for @multiDayGuidance.
  ///
  /// In bn, this message translates to:
  /// **'👉 একাধিক দিনের ছুটি: প্রথম ও শেষ তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।'**
  String get multiDayGuidance;

  /// No description provided for @addSingleDayHolidayTitle.
  ///
  /// In bn, this message translates to:
  /// **'১ দিনের ছুটি যোগ করুন'**
  String get addSingleDayHolidayTitle;

  /// No description provided for @addMultiDayHolidayTitle.
  ///
  /// In bn, this message translates to:
  /// **'টানা ছুটি যোগ করুন'**
  String get addMultiDayHolidayTitle;

  /// No description provided for @singleDateText.
  ///
  /// In bn, this message translates to:
  /// **'তারিখ: {date}'**
  String singleDateText(Object date);

  /// No description provided for @dateRangeText.
  ///
  /// In bn, this message translates to:
  /// **'মেয়াদ: {start} থেকে {end}'**
  String dateRangeText(Object end, Object start);

  /// No description provided for @holidayTitleHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: ঈদের ছুটি, স্বাধীনতা দিবস'**
  String get holidayTitleHint;

  /// No description provided for @holidayTitleLabel.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি বা উৎসবের নাম'**
  String get holidayTitleLabel;

  /// No description provided for @save.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ করুন'**
  String get save;

  /// No description provided for @addHoliday.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি যোগ করুন'**
  String get addHoliday;

  /// No description provided for @addConsecutiveHoliday.
  ///
  /// In bn, this message translates to:
  /// **'টানা ছুটি যোগ করুন'**
  String get addConsecutiveHoliday;

  /// No description provided for @holidayAddedSuccessfully.
  ///
  /// In bn, this message translates to:
  /// **'\"{title}\" সফলভাবে যুক্ত হয়েছে! 🎉'**
  String holidayAddedSuccessfully(Object title);

  /// No description provided for @addOfficeTitle.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অফিস যুক্ত করুন'**
  String get addOfficeTitle;

  /// No description provided for @officeNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের নাম'**
  String get officeNameLabel;

  /// No description provided for @officeNameHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: প্রধান কার্যালয়'**
  String get officeNameHint;

  /// No description provided for @officeNameRequired.
  ///
  /// In bn, this message translates to:
  /// **'নাম আবশ্যক'**
  String get officeNameRequired;

  /// No description provided for @officeAddressLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ঠিকানা'**
  String get officeAddressLabel;

  /// No description provided for @officeAddressHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: আগ্রাবাদ, চট্টগ্রাম'**
  String get officeAddressHint;

  /// No description provided for @officeAddressRequired.
  ///
  /// In bn, this message translates to:
  /// **'ঠিকানা আবশ্যক'**
  String get officeAddressRequired;

  /// No description provided for @officeStartTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের শুরুর সময়'**
  String get officeStartTimeLabel;

  /// No description provided for @officeStartTimeHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: 09:00:00'**
  String get officeStartTimeHint;

  /// No description provided for @officeStartTimeRequired.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের শুরুর সময় আবশ্যক'**
  String get officeStartTimeRequired;

  /// No description provided for @lateTrackingLabel.
  ///
  /// In bn, this message translates to:
  /// **'লেট ট্র্যাকিং কত মিনিট ?'**
  String get lateTrackingLabel;

  /// No description provided for @lateTrackingHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: 09:15:00'**
  String get lateTrackingHint;

  /// No description provided for @lateTrackingRequired.
  ///
  /// In bn, this message translates to:
  /// **'লেট ট্র্যাকিং সময় আবশ্যক'**
  String get lateTrackingRequired;

  /// No description provided for @officeEndTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ছুটির সময়'**
  String get officeEndTimeLabel;

  /// No description provided for @officeEndTimeHint.
  ///
  /// In bn, this message translates to:
  /// **'17:00:00'**
  String get officeEndTimeHint;

  /// No description provided for @officeEndTimeRequired.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ছুটির সময় আবশ্যক'**
  String get officeEndTimeRequired;

  /// No description provided for @saveOfficeButton.
  ///
  /// In bn, this message translates to:
  /// **'অফিস সংরক্ষণ করুন'**
  String get saveOfficeButton;

  /// No description provided for @officeAddedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'নতুন অফিস সফলভাবে যুক্ত হয়েছে!'**
  String get officeAddedSuccess;

  /// No description provided for @officeAddError.
  ///
  /// In bn, this message translates to:
  /// **'অফিস যুক্ত করতে সমস্যা হয়েছে'**
  String get officeAddError;

  /// No description provided for @routerSetSuccess.
  ///
  /// In bn, this message translates to:
  /// **'অফিসে রাউটারটি সফলভাবে সেট করা হয়েছে!'**
  String get routerSetSuccess;

  /// No description provided for @routerSetFailed.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার সেট করতে সমস্যা হয়েছে'**
  String get routerSetFailed;

  /// No description provided for @edit.
  ///
  /// In bn, this message translates to:
  /// **'সংশোধন'**
  String get edit;

  /// No description provided for @setRouter.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার সেট করুন'**
  String get setRouter;

  /// No description provided for @routerList.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার লিস্ট'**
  String get routerList;

  /// No description provided for @noAddress.
  ///
  /// In bn, this message translates to:
  /// **'ঠিকানা দেওয়া হয়নি'**
  String get noAddress;

  /// No description provided for @startTime.
  ///
  /// In bn, this message translates to:
  /// **'শুরু'**
  String get startTime;

  /// No description provided for @lateTracking.
  ///
  /// In bn, this message translates to:
  /// **'লেট ট্র্যাকিং'**
  String get lateTracking;

  /// No description provided for @endTime.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি'**
  String get endTime;

  /// No description provided for @noOfficeAdded.
  ///
  /// In bn, this message translates to:
  /// **'কোনো অফিস যুক্ত করা হয়নি!'**
  String get noOfficeAdded;

  /// No description provided for @noRouterSetup.
  ///
  /// In bn, this message translates to:
  /// **'এই অফিসের জন্য কোনো রাউটার সেটআপ করা নেই!'**
  String get noRouterSetup;

  /// No description provided for @addNewWifi.
  ///
  /// In bn, this message translates to:
  /// **'নতুন ওয়াইফাই যুক্ত করুন'**
  String get addNewWifi;

  /// No description provided for @setRouterForOffice.
  ///
  /// In bn, this message translates to:
  /// **'{officeName} -তে রাউটার সেট করুন'**
  String setRouterForOffice(String officeName);

  /// No description provided for @configuredRoutersForOffice.
  ///
  /// In bn, this message translates to:
  /// **'{officeName} - সেটকৃত রাউটার'**
  String configuredRoutersForOffice(String officeName);

  /// No description provided for @confirmationTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিতকরণ'**
  String get confirmationTitle;

  /// No description provided for @deleteOfficeConfirmation.
  ///
  /// In bn, this message translates to:
  /// **'\'{officeName}\' অফিসটি ডিলিট করতে চান? এর সাথে যুক্ত সকল ওয়াইফাই ডাটাও মুছে যেতে পারে।'**
  String deleteOfficeConfirmation(String officeName);

  /// No description provided for @officeDeleteSuccess.
  ///
  /// In bn, this message translates to:
  /// **'অফিসটি সফলভাবে মুছে ফেলা হয়েছে'**
  String get officeDeleteSuccess;

  /// No description provided for @officeDeleteFailed.
  ///
  /// In bn, this message translates to:
  /// **'মুছে ফেলতে সমস্যা হয়েছে'**
  String get officeDeleteFailed;

  /// No description provided for @editOfficeTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফিস তথ্য সংশোধন'**
  String get editOfficeTitle;

  /// No description provided for @startTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের শুরুর সময়'**
  String get startTimeLabel;

  /// No description provided for @startTimeHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: 09:00:00'**
  String get startTimeHint;

  /// No description provided for @startTimeRequired.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের শুরুর সময় আবশ্যক'**
  String get startTimeRequired;

  /// No description provided for @endTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ছুটির সময়'**
  String get endTimeLabel;

  /// No description provided for @endTimeHint.
  ///
  /// In bn, this message translates to:
  /// **'17:00:00'**
  String get endTimeHint;

  /// No description provided for @endTimeRequired.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ছুটির সময় আবশ্যক'**
  String get endTimeRequired;

  /// No description provided for @updateInfoButton.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য আপডেট করুন'**
  String get updateInfoButton;

  /// No description provided for @officeUpdateSuccess.
  ///
  /// In bn, this message translates to:
  /// **'অফিস সফলভাবে আপডেট হয়েছে!'**
  String get officeUpdateSuccess;

  /// No description provided for @officeUpdateFailed.
  ///
  /// In bn, this message translates to:
  /// **'আপডেট করতে সমস্যা হয়েছে'**
  String get officeUpdateFailed;

  /// No description provided for @routerRemovedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'রাউটারটি সফলভাবে রিমুভ করা হয়েছে'**
  String get routerRemovedSuccess;

  /// No description provided for @officeListTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফিস সমূহের তালিকা'**
  String get officeListTitle;

  /// No description provided for @attendanceReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'উপস্থিতি রিপোর্ট'**
  String get attendanceReportTitle;

  /// No description provided for @employeeReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'{name} - রিপোর্ট'**
  String employeeReportTitle(Object name);

  /// No description provided for @january.
  ///
  /// In bn, this message translates to:
  /// **'জানুয়ারী'**
  String get january;

  /// No description provided for @february.
  ///
  /// In bn, this message translates to:
  /// **'ফেব্রুয়ারী'**
  String get february;

  /// No description provided for @march.
  ///
  /// In bn, this message translates to:
  /// **'মার্চ'**
  String get march;

  /// No description provided for @april.
  ///
  /// In bn, this message translates to:
  /// **'এপ্রিল'**
  String get april;

  /// No description provided for @may.
  ///
  /// In bn, this message translates to:
  /// **'মে'**
  String get may;

  /// No description provided for @june.
  ///
  /// In bn, this message translates to:
  /// **'জুন'**
  String get june;

  /// No description provided for @july.
  ///
  /// In bn, this message translates to:
  /// **'জুলাই'**
  String get july;

  /// No description provided for @august.
  ///
  /// In bn, this message translates to:
  /// **'আগস্ট'**
  String get august;

  /// No description provided for @september.
  ///
  /// In bn, this message translates to:
  /// **'সেপ্টেম্বর'**
  String get september;

  /// No description provided for @october.
  ///
  /// In bn, this message translates to:
  /// **'অক্টোবর'**
  String get october;

  /// No description provided for @novembar.
  ///
  /// In bn, this message translates to:
  /// **'নভেম্বর'**
  String get novembar;

  /// No description provided for @december.
  ///
  /// In bn, this message translates to:
  /// **'ডিসেম্বর'**
  String get december;

  /// No description provided for @reportPeriodLabel.
  ///
  /// In bn, this message translates to:
  /// **'রিপোর্টের সময়সীমা (মাস/বছর)'**
  String get reportPeriodLabel;

  /// No description provided for @loading.
  ///
  /// In bn, this message translates to:
  /// **'লোড হচ্ছে...'**
  String get loading;

  /// No description provided for @summaryTitle.
  ///
  /// In bn, this message translates to:
  /// **'সামারি (Summary)'**
  String get summaryTitle;

  /// No description provided for @averageAttendance.
  ///
  /// In bn, this message translates to:
  /// **'গড় উপস্থিতি'**
  String get averageAttendance;

  /// No description provided for @averageLate.
  ///
  /// In bn, this message translates to:
  /// **'গড় লেট'**
  String get averageLate;

  /// No description provided for @detailedReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত রিপোর্ট'**
  String get detailedReportTitle;

  /// No description provided for @totalTrackedDays.
  ///
  /// In bn, this message translates to:
  /// **'মোট ট্র্যাকড দিন'**
  String get totalTrackedDays;

  /// No description provided for @onTimeAttendance.
  ///
  /// In bn, this message translates to:
  /// **'সময়মতো উপস্থিতি'**
  String get onTimeAttendance;

  /// No description provided for @lateAttendance.
  ///
  /// In bn, this message translates to:
  /// **'দেরিতে উপস্থিতি'**
  String get lateAttendance;

  /// No description provided for @leaveDays.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি (Leave)'**
  String get leaveDays;

  /// No description provided for @absentDays.
  ///
  /// In bn, this message translates to:
  /// **'অনুপস্থিতি'**
  String get absentDays;

  /// No description provided for @daysFormat.
  ///
  /// In bn, this message translates to:
  /// **'{count} দিন'**
  String daysFormat(Object count);

  /// No description provided for @downloadPdf.
  ///
  /// In bn, this message translates to:
  /// **'পিডিএফ (PDF) ডাউনলোড করুন'**
  String get downloadPdf;

  /// No description provided for @employeeReportListTitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী রিপোর্ট তালিকা'**
  String get employeeReportListTitle;

  /// No description provided for @loadingText.
  ///
  /// In bn, this message translates to:
  /// **'লোড হচ্ছে...'**
  String get loadingText;

  /// No description provided for @monthlyReportFormat.
  ///
  /// In bn, this message translates to:
  /// **'{monthYear}-এর রিপোর্ট'**
  String monthlyReportFormat(String monthYear);

  /// No description provided for @totalEmployeesFormat.
  ///
  /// In bn, this message translates to:
  /// **'মোট কর্মচারী: {count} জন'**
  String totalEmployeesFormat(Object count);

  /// No description provided for @noDataFound.
  ///
  /// In bn, this message translates to:
  /// **'কোনো ডাটা পাওয়া যায়নি'**
  String get noDataFound;

  /// No description provided for @tableColumnId.
  ///
  /// In bn, this message translates to:
  /// **'আইডি'**
  String get tableColumnId;

  /// No description provided for @tableColumnName.
  ///
  /// In bn, this message translates to:
  /// **'নাম'**
  String get tableColumnName;

  /// No description provided for @tableColumnAttendance.
  ///
  /// In bn, this message translates to:
  /// **'উপস্থিতি'**
  String get tableColumnAttendance;

  /// No description provided for @tableColumnLate.
  ///
  /// In bn, this message translates to:
  /// **'লেট'**
  String get tableColumnLate;

  /// No description provided for @tableColumnPercentage.
  ///
  /// In bn, this message translates to:
  /// **'শতকরা'**
  String get tableColumnPercentage;

  /// No description provided for @tableColumnAction.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকশন'**
  String get tableColumnAction;

  /// No description provided for @routerListTitle.
  ///
  /// In bn, this message translates to:
  /// **'রাউটারের তালিকা'**
  String get routerListTitle;

  /// No description provided for @deleteConfirmationTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিতকরণ'**
  String get deleteConfirmationTitle;

  /// No description provided for @deleteRouterConfirmMessage.
  ///
  /// In bn, this message translates to:
  /// **'\'{ssid}\' রাউটারটি ডিলিট করতে চাচ্ছেন?'**
  String deleteRouterConfirmMessage(String ssid);

  /// No description provided for @cancelButton.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, ডিলিট করুন'**
  String get deleteButton;

  /// No description provided for @officeDeletedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'অফিসটি সফলভাবে মুছে ফেলা হয়েছে'**
  String get officeDeletedSuccess;

  /// No description provided for @deleteFailed.
  ///
  /// In bn, this message translates to:
  /// **'মুছে ফেলতে সমস্যা হয়েছে'**
  String get deleteFailed;

  /// No description provided for @noRouterSetupText.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার সেটআপ করা নেই!'**
  String get noRouterSetupText;

  /// No description provided for @setupNowButton.
  ///
  /// In bn, this message translates to:
  /// **'এখনই সেটআপ করুন'**
  String get setupNowButton;

  /// No description provided for @bssidLabel.
  ///
  /// In bn, this message translates to:
  /// **'BSSID: {bssid}'**
  String bssidLabel(String bssid);

  /// No description provided for @officeWifiSetupTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফিস ওয়াইফাই সেটআপ'**
  String get officeWifiSetupTitle;

  /// No description provided for @globalWifiSetupTitle.
  ///
  /// In bn, this message translates to:
  /// **'গ্লোবাল ওয়াইফাই সেটআপ'**
  String get globalWifiSetupTitle;

  /// No description provided for @wifiAutoSyncedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'বর্তমান ওয়াইফাই তথ্য অটো-সিঙ্ক করা হয়েছে!'**
  String get wifiAutoSyncedSuccess;

  /// No description provided for @locationPermissionRequiredWifi.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই তথ্য অটো-সিঙ্ক করতে লোকেশন পারমিশন প্রয়োজন।'**
  String get locationPermissionRequiredWifi;

  /// No description provided for @wifiSaveSuccess.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই সফলভাবে সংরক্ষিত হয়েছে!'**
  String get wifiSaveSuccess;

  /// No description provided for @wifiSaveFailed.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই সংরক্ষণ করতে সমস্যা হয়েছে'**
  String get wifiSaveFailed;

  /// No description provided for @configureOfficeWifiTitle.
  ///
  /// In bn, this message translates to:
  /// **'অফিসের ওয়াইফাই কনফিগার করুন'**
  String get configureOfficeWifiTitle;

  /// No description provided for @configureOfficeWifiSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ওয়াইফাই কানেক্ট না থাকলে কর্মচারীরা হাজিরা দিতে পারবে না।'**
  String get configureOfficeWifiSubtitle;

  /// No description provided for @wifiNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই নাম (SSID)'**
  String get wifiNameLabel;

  /// No description provided for @wifiNameHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: Office_Guest_WiFi'**
  String get wifiNameHint;

  /// No description provided for @wifiNameRequired.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই নাম আবশ্যক'**
  String get wifiNameRequired;

  /// No description provided for @routerBssidLabel.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার আইডি (BSSID)'**
  String get routerBssidLabel;

  /// No description provided for @routerBssidHint.
  ///
  /// In bn, this message translates to:
  /// **'উদা: 00:0a:95:9d:68:16'**
  String get routerBssidHint;

  /// No description provided for @routerBssidRequired.
  ///
  /// In bn, this message translates to:
  /// **'রাউটার ম্যাক/BSSID আবশ্যক'**
  String get routerBssidRequired;

  /// No description provided for @saveButton.
  ///
  /// In bn, this message translates to:
  /// **'সেভ করুন'**
  String get saveButton;

  /// No description provided for @welcomeTitle.
  ///
  /// In bn, this message translates to:
  /// **'স্বাগতম AttenFI-তে'**
  String get welcomeTitle;

  /// No description provided for @selectAccountTypeSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাপটি ব্যবহার করতে আপনার অ্যাকাউন্ট টাইপ সিলেক্ট করুন'**
  String get selectAccountTypeSubtitle;

  /// No description provided for @adminRoleTitle.
  ///
  /// In bn, this message translates to:
  /// **'এডমিন/ম্যানেজার'**
  String get adminRoleTitle;

  /// No description provided for @adminRoleSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারিদের হাজিরা ম্যানেজমেন্ট করতে'**
  String get adminRoleSubtitle;

  /// No description provided for @employeeRoleTitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারি'**
  String get employeeRoleTitle;

  /// No description provided for @employeeRoleSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারি হিসাবে হাজিরা দিতে'**
  String get employeeRoleSubtitle;

  /// No description provided for @securePlatformText.
  ///
  /// In bn, this message translates to:
  /// **'Secure & Encrypted Platform'**
  String get securePlatformText;

  /// No description provided for @adminLoginSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিন প্যানেলে লগইন করুন'**
  String get adminLoginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In bn, this message translates to:
  /// **'ইমেইল'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In bn, this message translates to:
  /// **'ইমেইল অ্যাড্রেস'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড দিন'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In bn, this message translates to:
  /// **'লগইন'**
  String get loginButton;

  /// No description provided for @noAccountText.
  ///
  /// In bn, this message translates to:
  /// **' আপনার কি একাউন্ট নাই ? '**
  String get noAccountText;

  /// No description provided for @createAccountText.
  ///
  /// In bn, this message translates to:
  /// **'একাউন্ট তৈরী করুন'**
  String get createAccountText;

  /// No description provided for @fillEmailAndPasswordValidation.
  ///
  /// In bn, this message translates to:
  /// **'ইমেইল এবং পাসওয়ার্ড দুটিই পূরণ করুন'**
  String get fillEmailAndPasswordValidation;

  /// No description provided for @registerTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিবন্ধন করুন'**
  String get registerTitle;

  /// No description provided for @ownerNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'মালিকের নাম'**
  String get ownerNameLabel;

  /// No description provided for @companyNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'প্রতিষ্ঠানের নাম'**
  String get companyNameLabel;

  /// No description provided for @employeeRangeLabel.
  ///
  /// In bn, this message translates to:
  /// **'কতজন কর্মচারী'**
  String get employeeRangeLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In bn, this message translates to:
  /// **'ইমেইল অ্যাড্রেস'**
  String get emailAddressLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In bn, this message translates to:
  /// **'ফোন নম্বর'**
  String get phoneNumberLabel;

  /// No description provided for @passwordLabelText.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড'**
  String get passwordLabelText;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In bn, this message translates to:
  /// **'কনফার্ম পাসওয়ার্ড'**
  String get confirmPasswordLabel;

  /// No description provided for @completeRegistrationButton.
  ///
  /// In bn, this message translates to:
  /// **'নিবন্ধন সম্পন্ন করুন'**
  String get completeRegistrationButton;

  /// No description provided for @fillAllFieldsValidation.
  ///
  /// In bn, this message translates to:
  /// **'সবগুলো তথ্য সঠিকভাবে পূরণ করুন'**
  String get fillAllFieldsValidation;

  /// No description provided for @passwordsDoNotMatchValidation.
  ///
  /// In bn, this message translates to:
  /// **'পাসওয়ার্ড দুটি মিলছে না!'**
  String get passwordsDoNotMatchValidation;

  /// No description provided for @range1To10.
  ///
  /// In bn, this message translates to:
  /// **'১-১০ জন'**
  String get range1To10;

  /// No description provided for @range11To50.
  ///
  /// In bn, this message translates to:
  /// **'১১-৫০ জন'**
  String get range11To50;

  /// No description provided for @range51To100.
  ///
  /// In bn, this message translates to:
  /// **'৫১-১০০ জন'**
  String get range51To100;

  /// No description provided for @range100Plus.
  ///
  /// In bn, this message translates to:
  /// **'১০০+ জন'**
  String get range100Plus;

  /// No description provided for @permissionRequiredTitle.
  ///
  /// In bn, this message translates to:
  /// **'অনুমতি প্রয়োজন'**
  String get permissionRequiredTitle;

  /// No description provided for @gpsDisabledMessage.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ফোনের GPS/Location Service বন্ধ আছে। দয়া করে এটি অন করুন।'**
  String get gpsDisabledMessage;

  /// No description provided for @locationPermanentlyBlockedMessage.
  ///
  /// In bn, this message translates to:
  /// **'আপনি লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করেছেন। লগইন করতে ফোনের সেটিংস থেকে অনুমতি অন করুন।'**
  String get locationPermanentlyBlockedMessage;

  /// No description provided for @locationPermissionRequiredMessage.
  ///
  /// In bn, this message translates to:
  /// **'ওয়াইফাই ভেরিফিকেশনের জন্য লোকেশন পারমিশন দেওয়া বাধ্যতামূলক।'**
  String get locationPermissionRequiredMessage;

  /// No description provided for @okButton.
  ///
  /// In bn, this message translates to:
  /// **'ঠিক আছে'**
  String get okButton;

  /// No description provided for @openSettingsButton.
  ///
  /// In bn, this message translates to:
  /// **'সেটিংস ওপেন করুন'**
  String get openSettingsButton;

  /// No description provided for @tryAgainButton.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন'**
  String get tryAgainButton;

  /// No description provided for @provideEmployeeIdError.
  ///
  /// In bn, this message translates to:
  /// **'অনুগ্রহ করে আপনার আইডি প্রদান করুন'**
  String get provideEmployeeIdError;

  /// No description provided for @otpSentSuccess.
  ///
  /// In bn, this message translates to:
  /// **'আপনার রেজিস্টার্ড নাম্বারে ওটিপি পাঠানো হয়েছে'**
  String get otpSentSuccess;

  /// No description provided for @otpSendError.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পাঠাতে সমস্যা হয়েছে: {error}'**
  String otpSendError(Object error);

  /// No description provided for @enterValidOtpError.
  ///
  /// In bn, this message translates to:
  /// **'অনুগ্রহ করে সঠিক ওটিপি কোডটি দিন'**
  String get enterValidOtpError;

  /// No description provided for @verificationFailedError.
  ///
  /// In bn, this message translates to:
  /// **'ভেরিফিকেশন ব্যর্থ হয়েছে: {error}'**
  String verificationFailedError(Object error);

  /// No description provided for @employeeLoginTitle.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারী লগইন'**
  String get employeeLoginTitle;

  /// No description provided for @enterOtpSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার মোবাইলে প্রাপ্ত ওটিপি কোডটি নিচে প্রদান করুন'**
  String get enterOtpSubtitle;

  /// No description provided for @enterIdSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ইউনিক কর্মচারী আইডি দিয়ে লগইন করুন'**
  String get enterIdSubtitle;

  /// No description provided for @employeeIdHint.
  ///
  /// In bn, this message translates to:
  /// **'কর্মচারীর আইডি (যেমন: 001100)'**
  String get employeeIdHint;

  /// No description provided for @otpCodeHint.
  ///
  /// In bn, this message translates to:
  /// **'৪ বা ৬ ডিজিটের ওটিপি কোড'**
  String get otpCodeHint;

  /// No description provided for @verifyAndLoginButton.
  ///
  /// In bn, this message translates to:
  /// **'ভেরিফাই ও লগইন'**
  String get verifyAndLoginButton;

  /// No description provided for @sendOtpButton.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পাঠান'**
  String get sendOtpButton;

  /// No description provided for @changeIdButton.
  ///
  /// In bn, this message translates to:
  /// **'আইডি ভুল হয়েছে? পরিবর্তন করুন'**
  String get changeIdButton;

  /// No description provided for @noButton.
  ///
  /// In bn, this message translates to:
  /// **'না'**
  String get noButton;

  /// No description provided for @yesLogoutButton.
  ///
  /// In bn, this message translates to:
  /// **'হ্যাঁ, লগআউট করুন'**
  String get yesLogoutButton;

  /// No description provided for @logoutError.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।'**
  String get logoutError;

  /// No description provided for @userDashboardTitle.
  ///
  /// In bn, this message translates to:
  /// **'ইউজার ড্যাশবোর্ড'**
  String get userDashboardTitle;

  /// No description provided for @personalTrackingSection.
  ///
  /// In bn, this message translates to:
  /// **'ব্যক্তিগত ট্র্যাকিং'**
  String get personalTrackingSection;

  /// No description provided for @myProfileMenu.
  ///
  /// In bn, this message translates to:
  /// **'আমার প্রোফাইল'**
  String get myProfileMenu;

  /// No description provided for @attendanceHistoryMenu.
  ///
  /// In bn, this message translates to:
  /// **'হাজিরা হিস্ট্রি'**
  String get attendanceHistoryMenu;

  /// No description provided for @applicationsSection.
  ///
  /// In bn, this message translates to:
  /// **'আবেদন ও অনুরোধ'**
  String get applicationsSection;

  /// No description provided for @leaveApplicationMenu.
  ///
  /// In bn, this message translates to:
  /// **'ছুটির আবেদন (Leave)'**
  String get leaveApplicationMenu;

  /// No description provided for @lateCondonationMenu.
  ///
  /// In bn, this message translates to:
  /// **'লেট কনডোন আবেদন'**
  String get lateCondonationMenu;

  /// No description provided for @othersSection.
  ///
  /// In bn, this message translates to:
  /// **'অন্যান্য'**
  String get othersSection;

  /// No description provided for @companyPolicyMenu.
  ///
  /// In bn, this message translates to:
  /// **'কোম্পানি পলিসি'**
  String get companyPolicyMenu;

  /// No description provided for @helpAndSupportMenu.
  ///
  /// In bn, this message translates to:
  /// **'হেল্প ও সাপোর্ট'**
  String get helpAndSupportMenu;

  /// No description provided for @logoutMenu.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট'**
  String get logoutMenu;

  /// No description provided for @appVersion.
  ///
  /// In bn, this message translates to:
  /// **'ভার্সন ১.০.০'**
  String get appVersion;

  /// No description provided for @navHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In bn, this message translates to:
  /// **'হিস্ট্রি'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get navProfile;

  /// No description provided for @defaultEmployeeName.
  ///
  /// In bn, this message translates to:
  /// **'পরিচিত কর্মী'**
  String get defaultEmployeeName;

  /// No description provided for @idLabel.
  ///
  /// In bn, this message translates to:
  /// **'আইডি: {id}'**
  String idLabel(String id);

  /// No description provided for @monthlyReportTitle.
  ///
  /// In bn, this message translates to:
  /// **'এই মাসের রিপোর্ট ({monthYear})'**
  String monthlyReportTitle(String monthYear);

  /// No description provided for @statPresent.
  ///
  /// In bn, this message translates to:
  /// **'✅ উপস্থিত'**
  String get statPresent;

  /// No description provided for @statLate.
  ///
  /// In bn, this message translates to:
  /// **'⚠️ লেট'**
  String get statLate;

  /// No description provided for @statLeave.
  ///
  /// In bn, this message translates to:
  /// **'❌ ছুটি'**
  String get statLeave;

  /// No description provided for @daysCount.
  ///
  /// In bn, this message translates to:
  /// **'{count} দিন'**
  String daysCount(Object count);

  /// No description provided for @latestNotice.
  ///
  /// In bn, this message translates to:
  /// **'সর্বশেষ নোটিশ'**
  String get latestNotice;

  /// No description provided for @noticeContent.
  ///
  /// In bn, this message translates to:
  /// **'আজ বিকেল ৪টায় অল-টিম উইকলি মিটিং অনুষ্ঠিত হবে।'**
  String get noticeContent;

  /// No description provided for @sessionExpired.
  ///
  /// In bn, this message translates to:
  /// **'লগইন সেশন শেষ হয়ে গেছে!'**
  String get sessionExpired;

  /// No description provided for @holdToCheckIn.
  ///
  /// In bn, this message translates to:
  /// **'চেক-ইন করতে চেপে ধরে রাখুন'**
  String get holdToCheckIn;

  /// No description provided for @holdToCheckOut.
  ///
  /// In bn, this message translates to:
  /// **'চেক-আউট করতে চেপে ধরে রাখুন'**
  String get holdToCheckOut;

  /// No description provided for @processingWait.
  ///
  /// In bn, this message translates to:
  /// **'প্রসেস হচ্ছে, অনুগ্রহ করে অপেক্ষা করুন...'**
  String get processingWait;

  /// No description provided for @checkInUpper.
  ///
  /// In bn, this message translates to:
  /// **'CHECK-IN'**
  String get checkInUpper;

  /// No description provided for @checkOutUpper.
  ///
  /// In bn, this message translates to:
  /// **'CHECK-OUT'**
  String get checkOutUpper;

  /// No description provided for @todayLogsTitle.
  ///
  /// In bn, this message translates to:
  /// **'আজকের টাইমলাইন (Today\'s Logs)'**
  String get todayLogsTitle;

  /// No description provided for @noAttendanceToday.
  ///
  /// In bn, this message translates to:
  /// **'আজকে এখনও কোনো হাজিরা দেওয়া হয়নি'**
  String get noAttendanceToday;

  /// No description provided for @aths_attendanceHistoryTitle.
  ///
  /// In bn, this message translates to:
  /// **'হাজিরা হিস্ট্রি'**
  String get aths_attendanceHistoryTitle;

  /// No description provided for @aths_selectMonthTitle.
  ///
  /// In bn, this message translates to:
  /// **'মাস নির্বাচন করুন'**
  String get aths_selectMonthTitle;

  /// No description provided for @aths_navHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get aths_navHome;

  /// No description provided for @aths_navHistory.
  ///
  /// In bn, this message translates to:
  /// **'হিস্ট্রি'**
  String get aths_navHistory;

  /// No description provided for @aths_navProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get aths_navProfile;

  /// No description provided for @aths_summaryPresent.
  ///
  /// In bn, this message translates to:
  /// **'✅ উপস্থিত'**
  String get aths_summaryPresent;

  /// No description provided for @aths_summaryLate.
  ///
  /// In bn, this message translates to:
  /// **'⚠️ লেট'**
  String get aths_summaryLate;

  /// No description provided for @aths_summaryLeave.
  ///
  /// In bn, this message translates to:
  /// **'❌ ছুটি'**
  String get aths_summaryLeave;

  /// No description provided for @aths_daysFormat.
  ///
  /// In bn, this message translates to:
  /// **'{count} দিন'**
  String aths_daysFormat(String count);

  /// No description provided for @aths_filterAll.
  ///
  /// In bn, this message translates to:
  /// **'সব দিন'**
  String get aths_filterAll;

  /// No description provided for @aths_filterPresent.
  ///
  /// In bn, this message translates to:
  /// **'উপস্থিত'**
  String get aths_filterPresent;

  /// No description provided for @aths_filterLate.
  ///
  /// In bn, this message translates to:
  /// **'লেট'**
  String get aths_filterLate;

  /// No description provided for @aths_filterLeave.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি'**
  String get aths_filterLeave;

  /// No description provided for @aths_noAttendanceRecord.
  ///
  /// In bn, this message translates to:
  /// **'এই ক্যাটাগরিতে কোনো হাজিরা রেকর্ড নেই।'**
  String get aths_noAttendanceRecord;

  /// No description provided for @aths_statusPresent.
  ///
  /// In bn, this message translates to:
  /// **'উপস্থিত'**
  String get aths_statusPresent;

  /// No description provided for @aths_statusLate.
  ///
  /// In bn, this message translates to:
  /// **'লেট'**
  String get aths_statusLate;

  /// No description provided for @aths_statusLeave.
  ///
  /// In bn, this message translates to:
  /// **'ছুটি'**
  String get aths_statusLeave;

  /// No description provided for @aths_inTime.
  ///
  /// In bn, this message translates to:
  /// **'ইন টাইম'**
  String get aths_inTime;

  /// No description provided for @aths_outTime.
  ///
  /// In bn, this message translates to:
  /// **'আউট টাইম'**
  String get aths_outTime;

  /// No description provided for @aths_monthJan.
  ///
  /// In bn, this message translates to:
  /// **'জানুয়ারি'**
  String get aths_monthJan;

  /// No description provided for @aths_monthFeb.
  ///
  /// In bn, this message translates to:
  /// **'ফেব্রুয়ারি'**
  String get aths_monthFeb;

  /// No description provided for @aths_monthMar.
  ///
  /// In bn, this message translates to:
  /// **'মার্চ'**
  String get aths_monthMar;

  /// No description provided for @aths_monthApr.
  ///
  /// In bn, this message translates to:
  /// **'এপ্রিল'**
  String get aths_monthApr;

  /// No description provided for @aths_monthMay.
  ///
  /// In bn, this message translates to:
  /// **'মে'**
  String get aths_monthMay;

  /// No description provided for @aths_monthJun.
  ///
  /// In bn, this message translates to:
  /// **'জুন'**
  String get aths_monthJun;

  /// No description provided for @aths_monthJul.
  ///
  /// In bn, this message translates to:
  /// **'জুলাই'**
  String get aths_monthJul;

  /// No description provided for @aths_monthAug.
  ///
  /// In bn, this message translates to:
  /// **'আগস্ট'**
  String get aths_monthAug;

  /// No description provided for @aths_monthSep.
  ///
  /// In bn, this message translates to:
  /// **'সেপ্টেম্বর'**
  String get aths_monthSep;

  /// No description provided for @aths_monthOct.
  ///
  /// In bn, this message translates to:
  /// **'অক্টোবর'**
  String get aths_monthOct;

  /// No description provided for @aths_monthNov.
  ///
  /// In bn, this message translates to:
  /// **'নভেম্বর'**
  String get aths_monthNov;

  /// No description provided for @aths_monthDec.
  ///
  /// In bn, this message translates to:
  /// **'ডিসেম্বর'**
  String get aths_monthDec;

  /// No description provided for @eps_profile_title.
  ///
  /// In bn, this message translates to:
  /// **'আমার প্রোফাইল'**
  String get eps_profile_title;

  /// No description provided for @eps_nav_home.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get eps_nav_home;

  /// No description provided for @eps_nav_history.
  ///
  /// In bn, this message translates to:
  /// **'হিস্ট্রি'**
  String get eps_nav_history;

  /// No description provided for @eps_nav_profile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get eps_nav_profile;

  /// No description provided for @eps_default_name.
  ///
  /// In bn, this message translates to:
  /// **'পরিচিত কর্মী'**
  String get eps_default_name;

  /// No description provided for @eps_id_label.
  ///
  /// In bn, this message translates to:
  /// **'আইডি: {id}'**
  String eps_id_label(Object id);

  /// No description provided for @eps_not_available.
  ///
  /// In bn, this message translates to:
  /// **'N/A'**
  String get eps_not_available;

  /// No description provided for @eps_no_info.
  ///
  /// In bn, this message translates to:
  /// **'তথ্য নেই'**
  String get eps_no_info;

  /// No description provided for @eps_mobile_not_found.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর পাওয়া যায়নি'**
  String get eps_mobile_not_found;

  /// No description provided for @eps_address_not_found.
  ///
  /// In bn, this message translates to:
  /// **'ঠিকানা পাওয়া যায়নি'**
  String get eps_address_not_found;

  /// No description provided for @eps_label_mobile.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর'**
  String get eps_label_mobile;

  /// No description provided for @eps_label_nid.
  ///
  /// In bn, this message translates to:
  /// **'এনআইডি (NID)'**
  String get eps_label_nid;

  /// No description provided for @eps_label_dob.
  ///
  /// In bn, this message translates to:
  /// **'জন্ম তারিখ'**
  String get eps_label_dob;

  /// No description provided for @eps_label_father_name.
  ///
  /// In bn, this message translates to:
  /// **'পিতার নাম'**
  String get eps_label_father_name;

  /// No description provided for @eps_label_mother_name.
  ///
  /// In bn, this message translates to:
  /// **'মাতার নাম'**
  String get eps_label_mother_name;

  /// No description provided for @eps_label_address.
  ///
  /// In bn, this message translates to:
  /// **'বর্তমান ঠিকানা'**
  String get eps_label_address;

  /// No description provided for @cab_ad_load_error.
  ///
  /// In bn, this message translates to:
  /// **'বিজ্ঞাপন লোড হতে সমস্যা হয়েছে'**
  String get cab_ad_load_error;

  /// No description provided for @cab_ad_badge.
  ///
  /// In bn, this message translates to:
  /// **'Ad'**
  String get cab_ad_badge;

  /// No description provided for @cab_admob_placeholder.
  ///
  /// In bn, this message translates to:
  /// **'এখানে গুগল এডমোব শো করবে'**
  String get cab_admob_placeholder;

  /// No description provided for @cab_contact_for_ads.
  ///
  /// In bn, this message translates to:
  /// **'বিজ্ঞাপনের জন্য যোগাযোগ করুন'**
  String get cab_contact_for_ads;

  /// No description provided for @cab_ad_email.
  ///
  /// In bn, this message translates to:
  /// **'adds@AttenFi.live'**
  String get cab_ad_email;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

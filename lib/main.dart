import 'package:atten_fi/core/providers/admin_otp_provider.dart';
import 'package:atten_fi/core/providers/admin_report_provider.dart';
import 'package:atten_fi/core/providers/attendance_report_provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/holiday_provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/presentation/screens/User/history/attendance_history.dart';
import 'package:atten_fi/presentation/screens/User/profile/user_profile.dart';
import 'package:atten_fi/presentation/screens/auth/signup_screen.dart';
import 'package:atten_fi/presentation/screens/dashboard/admin_dashboard.dart';
import 'package:atten_fi/presentation/screens/employee/add_employee_screen.dart';
import 'package:atten_fi/presentation/screens/employee/employee_details.dart';
import 'package:atten_fi/presentation/screens/employee/employee_edit.dart';
import 'package:atten_fi/presentation/screens/employee/employee_list_table.dart';
import 'package:atten_fi/presentation/screens/holiday/holiday_screen.dart';
import 'package:atten_fi/presentation/screens/offices/office_add.dart';
import 'package:atten_fi/presentation/screens/offices/office_list.dart';
import 'package:atten_fi/presentation/screens/otp/admin_otp.dart';
import 'package:atten_fi/presentation/screens/report/attendance_report.dart';
import 'package:atten_fi/presentation/screens/report/employee_report_table.dart';
import 'package:atten_fi/presentation/screens/settings/settings.dart';
import 'package:atten_fi/presentation/screens/wifi/wifi_list.dart';
import 'package:atten_fi/presentation/screens/wifi/wifi_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/theme/app_themes.dart';
import 'core/providers/attendance_provider.dart';
import 'core/providers/employee_provider.dart';
import 'presentation/screens/User/dashboard/user_dashboard.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/auth/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => EmployeeProvider()),
          ChangeNotifierProvider(create: (_) => OfficeProvider()),
          ChangeNotifierProvider(create: (_) => AttendanceProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => HolidayProvider()),
          ChangeNotifierProvider(create: (_) => AdminReportProvider()),
          ChangeNotifierProvider(create: (_) => AdminEmployeeReportProvider()),
          ChangeNotifierProvider(create: (_) => AdminOtpProvider()),
        ],
        child: const AttenFiAdmin(),
      ),
    );
  });
}

class AttenFiAdmin extends StatelessWidget {
  const AttenFiAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRole = context.watch<AuthProvider>().currentRole;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AttenFI',

      theme: currentRole == 'admin'
          ? AppThemes.adminTheme
          : AppThemes.userTheme,

      // আপনার প্রথম স্ক্রিন (লগইন/রেজিস্ট্রেশন)
      //home: AuthScreen(),
      home: const SplashScreen(),

      // রাউটিং ম্যানেজমেন্ট (ভবিষ্যতের জন্য)
      // initialRoute: '/login',
      routes: {
        '/login': (context) => AuthScreen(),
        '/dashboard': (context) => const AdminDashboard(),
        '/sign-up': (context) => SignupScreen(),
        '/add-employee': (context) => AddEmployeeScreen(),
        '/employee-details': (context) => EmployeeDetails(),
        '/edit-employee': (context) => EmployeeEditScreen(),
        '/employee-list-table': (context) => EmployeeListTable(),
        '/attendance-report': (context) => AttendanceReportScreen(),
        '/employee-report-table': (context) => EmployeeReportTable(),
        '/wifi-setup': (context) => WifiSetupScreen(),
        '/wifi-list': (context) => WifiListScreen(),
        '/office-add': (context) => OfficeAddScreen(),
        '/office-list': (context) => OfficeListScreen(),
        '/settings': (context) => SettingsScreen(),
        '/holiday': (context) => HolidayUploadCalendarScreen(),
        '/employee_profile': (context) => EmployeeProfileScreen(),
        '/attendance_history': (context) => AttendanceHistoryScreen(),
        '/user-dashboard': (context) => UserDashboard(),
        '/admin-otp': (context) => AdminOtpDashboard(),
      },
    );
  }
}

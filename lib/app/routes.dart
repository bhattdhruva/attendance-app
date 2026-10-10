import 'package:get/get.dart';
import '../views/superadmin_views/screens/dashboard_view.dart';
import '../views/superadmin_views/screens/security_settings_view.dart';
import '../auth/view/login_screen.dart';
import '../auth/view/forgotpassword.dart';
import '../auth/view/resetpassword.dart';
import '../auth/view/mfa_setup_screen.dart';
import '../auth/view/mfa_verify_screen.dart';
import '../auth/view/changepassword_screen.dart';
import '../auth/view/pin_setup_screen.dart';
import '../auth/view/pin_verify_screen.dart';

abstract class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String securitySettings = '/security-settings';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String mfaSetup = '/mfa-setup';
  static const String mfaVerify = '/mfa-verify';
  static const String changePassword = '/change-password';
  static const String pinSetup = '/pin-setup';
  static const String pinVerify = '/pin-verify';
}

abstract class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardView()),
    GetPage(name: AppRoutes.securitySettings, page: () => const SecuritySettingsView()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
      name: AppRoutes.resetPassword, 
      page: () => ResetPasswordScreen(
        email: Get.parameters['email'] ?? '', 
        token: Get.parameters['token'] ?? ''
      )
    ),
    GetPage(name: AppRoutes.mfaSetup, page: () => const MfaSetupScreen()),
    GetPage(name: AppRoutes.mfaVerify, page: () => const MfaVerifyScreen()),
    GetPage(name: AppRoutes.changePassword, page: () => const ChangePasswordScreen()),
    GetPage(name: AppRoutes.pinSetup, page: () => const PinSetupScreen()),
    GetPage(name: AppRoutes.pinVerify, page: () => const PinVerifyScreen()),
  ];
}

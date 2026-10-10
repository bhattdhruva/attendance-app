class ApiEndpoints {
  // Note: If using Android Emulator, use 10.0.2.2 instead of localhost
  // For iOS Simulator or Web, use localhost or 127.0.0.1
  static const String baseUrl = 'http://192.168.1.5:5000/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String mfaSetup = '/auth/mfa/setup';
  static const String mfaEnable = '/auth/mfa/enable';
  static const String mfaVerify = '/auth/mfa/verify';
  static const String mfaDisable = '/auth/mfa/disable';
  static const String getMe = '/auth/me';
  static const String dashboard = '/dashboard/superadmin';
  static const String profile = '/profile';

  // Future Attendance endpoints can go here
  static const String checkIn = '/attendance/check-in';
  static const String checkOut = '/attendance/check-out';
}

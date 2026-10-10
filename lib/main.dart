import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/colors.dart';
import 'app/routes.dart';
import 'app/theme.dart';
import 'bindings/app_binding.dart';
import 'views/superadmin_views/screens/dashboard_view.dart';
import 'auth/view/login_screen.dart';
import 'auth/controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance & HR App',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Obx(() {
        final auth = Get.find<AuthController>();
        // Return login if not authenticated, else dashboard
        return auth.isAuthenticated.value ? const DashboardView() : const LoginScreen();
      }),
      getPages: AppPages.pages,
    );
  }
}

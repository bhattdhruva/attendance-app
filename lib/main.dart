import 'package:flutter/material.dart';
import 'app/colors.dart';
import 'app/routes.dart';
import 'views/superadmin_views/screens/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance & HR App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.superAdminPrimary,
          surface: AppColors.surface,
        ),
      ),
      home: const DashboardView(),
      routes: AppRoutes.routes,
    );
  }
}

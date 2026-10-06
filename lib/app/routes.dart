import 'package:flutter/material.dart';
import '../views/superadmin_views/screens/dashboard_view.dart';

abstract class AppRoutes {
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
        dashboard: (context) => const DashboardView(),
      };
}

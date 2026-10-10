import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'home_tab.dart';
import '../../../widgets/bottomnavbar.dart';
import '../../../app/colors.dart';
import '../../../app/routes.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => _buildBody(controller.currentIndex.value, controller)),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (index == 3) {
            // Route to Profile / Settings
            Get.toNamed(AppRoutes.securitySettings);
          } else {
            controller.changeTab(index);
          }
        },
        items: const [
          CustomNavBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          CustomNavBarItem(
            icon: Icons.business_outlined,
            activeIcon: Icons.business_rounded,
            label: 'Organization',
          ),
          CustomNavBarItem(
            icon: Icons.card_membership_outlined,
            activeIcon: Icons.card_membership_rounded,
            label: 'Subscription',
          ),
          CustomNavBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      )),
    );
  }

  Widget _buildBody(int index, DashboardController controller) {
    switch (index) {
      case 0:
        return HomeTab(controller: controller);
      case 1:
        return const Center(child: Text('Organizations Screen (WIP)'));
      case 2:
        return const Center(child: Text('Subscriptions Screen (WIP)'));
      default:
        return const Center(child: Text('WIP'));
    }
  }
}


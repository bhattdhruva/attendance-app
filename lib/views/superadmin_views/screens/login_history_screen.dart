import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/colors.dart';
import '../../../../app/colors.dart';
import '../../../../widgets/appbar.dart';
import '../../../../app/routes.dart';
import '../controllers/login_history_controller.dart';

class LoginHistoryScreen extends StatelessWidget {
  const LoginHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Log in History',
        onNotificationTap: () => Get.toNamed(AppRoutes.notifications),
        onSettingsTap: () => Get.toNamed(AppRoutes.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.inkDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final controller = Get.put(LoginHistoryController());
        
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.logs.isEmpty) {
          return const Center(child: Text('No login history found', style: TextStyle(color: AppColors.neutralGrey)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
            itemCount: controller.logs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = controller.logs[index];
              final isRecent = index == 0; // Or check timestamp
              final date = DateTime.parse(log['timestamp']).toLocal();
              
              final month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1];
              final dateStr = '$month ${date.day}, ${date.year}';
              
              int h = date.hour;
              final period = h >= 12 ? 'PM' : 'AM';
              if (h == 0) h = 12;
              if (h > 12) h -= 12;
              final m = date.minute.toString().padLeft(2, '0');
              final timeStr = '$h:$m $period';
              
              final isSuccess = log['success'] == true;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSuccess ? AppColors.accentTealDark : AppColors.accentRedDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$dateStr at $timeStr',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.inkDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'IP: ${log['ipAddress'] ?? 'Unknown'} • ${log['eventType']}',
                            style: const TextStyle(color: AppColors.neutralGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSuccess ? 'Success' : 'Failed',
                        style: TextStyle(color: isSuccess ? AppColors.accentTealDark : AppColors.accentRedDark, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

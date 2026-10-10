import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/colors.dart';
import '../../../../app/routes.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/textfield.dart';
import '../controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top colorful background from palette
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryIndigo, AppColors.primaryViolet],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              // Custom Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(Icons.arrow_back, () {
                    if (Get.isRegistered<DashboardController>()) {
                      Get.find<DashboardController>().changeTab(0);
                    } else {
                      Get.back();
                    }
                  }),
                  _buildIconButton(Icons.edit_outlined, () {
                    _showEditBottomSheet(context, controller);
                  }),
                ],
              ),
              const SizedBox(height: 8),

              // Avatar
              GestureDetector(
                onTap: () => controller.updateAvatar(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 24,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        image: controller.avatarUrl.value.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(controller.avatarUrl.value.startsWith('http') ? controller.avatarUrl.value : 'http://192.168.1.5:5000${controller.avatarUrl.value}'),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: controller.avatarUrl.value.isEmpty
                          ? const Icon(Icons.person, size: 60, color: AppColors.neutralGrey)
                          : null,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryViolet,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Name and Email
              Obx(() => Text(
                controller.fullName.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              )),
              const SizedBox(height: 2),
              Obx(() => Text(
                controller.email.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutralGrey,
                ),
              )),

              const SizedBox(height: 16),

              // Theme Options
              Row(
                children: [
                  Expanded(child: Obx(() => _buildThemeCard(
                    Icons.settings_suggest_outlined,
                    'System',
                    isActive: controller.themeMode.value == 'System',
                    onTap: () => controller.setThemeMode('System'),
                  ))),
                  const SizedBox(width: 16),
                  Expanded(child: Obx(() => _buildThemeCard(
                    Icons.light_mode_outlined,
                    'Light',
                    isActive: controller.themeMode.value == 'Light',
                    onTap: () => controller.setThemeMode('Light'),
                  ))),
                  const SizedBox(width: 16),
                  Expanded(child: Obx(() => _buildThemeCard(
                    Icons.dark_mode_outlined,
                    'Dark',
                    isActive: controller.themeMode.value == 'Dark',
                    onTap: () => controller.setThemeMode('Dark'),
                  ))),
                ],
              ),
              const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
              // Personal Settings Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Personal Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.neutralGrey)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Obx(() => _buildListTile(
                        icon: Icons.person_outline,
                        iconColor: AppColors.accentIndigoLight,
                        title: 'Full Name',
                        subtitle: controller.fullName.value,
                        onTap: () {},
                        showTrailingArrow: false,
                      )),
                      _buildDivider(),
                      Obx(() => _buildListTile(
                        icon: Icons.alternate_email,
                        iconColor: AppColors.accentTealLight,
                        title: 'Username',
                        subtitle: controller.username.value.isNotEmpty ? controller.username.value : controller.email.value,
                        onTap: () {},
                        showTrailingArrow: false,
                      )),
                      _buildDivider(),
                      Obx(() => _buildListTile(
                        icon: Icons.phone_outlined,
                        iconColor: AppColors.accentBlueLight,
                        title: 'Phone Number',
                        subtitle: controller.phoneNumber.value,
                        onTap: () {},
                        showTrailingArrow: false,
                      )),
                      _buildDivider(),
                      Obx(() => _buildListTile(
                        icon: Icons.calendar_today_outlined,
                        iconColor: AppColors.primaryViolet,
                        title: 'Account Created',
                        subtitle: controller.createdAt.value,
                        onTap: () {},
                        showTrailingArrow: false,
                      )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Account & Security Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Account & Security', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.neutralGrey)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.lock_outline,
                        iconColor: AppColors.accentRedLight,
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        onTap: () => Get.toNamed(AppRoutes.changePassword),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.security_outlined,
                        iconColor: AppColors.accentTealDark,
                        title: 'Two Factor Authentication',
                        subtitle: 'Protect your account',
                        onTap: () => Get.toNamed(AppRoutes.mfaSetup),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.pin_outlined,
                        iconColor: AppColors.primaryViolet,
                        title: 'App PIN Setup',
                        subtitle: 'Set up quick access PIN',
                        onTap: () => Get.toNamed(AppRoutes.pinSetup),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.devices_outlined,
                        iconColor: AppColors.accentIndigoLight,
                        title: 'Active Sessions',
                        subtitle: 'Manage your logged in devices',
                        onTap: () => Get.toNamed(AppRoutes.activeSessions),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.history_outlined,
                        iconColor: AppColors.neutralGrey,
                        title: 'Log in History',
                        subtitle: 'Review past logins',
                        onTap: () => Get.toNamed(AppRoutes.loginHistory),
                      ),
                      _buildDivider(),
                      Obx(() {
                        List<String> notifs = [];
                        if (controller.notificationsMute.value) notifs.add('Mute');
                        if (controller.notificationsPush.value) notifs.add('Push');
                        if (controller.notificationsEmail.value) notifs.add('Email');
                        return _buildListTile(
                          icon: Icons.notifications_none_outlined,
                          iconColor: AppColors.accentBlueLight,
                          title: 'Notifications',
                          subtitle: notifs.isNotEmpty ? notifs.join(', ') : 'None',
                          onTap: () => Get.toNamed(AppRoutes.notifications),
                        );
                      }),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.settings_outlined,
                        iconColor: AppColors.neutralGrey,
                        title: 'Settings',
                        subtitle: 'General app preferences',
                        onTap: () => Get.toNamed(AppRoutes.settings),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Logout',
                icon: Icons.logout,
                onPressed: () {
                  // Navigate to Login, clearing the stack
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
              const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.inkDark, size: 20),
      ),
    );
  }

  Widget _buildThemeCard(IconData icon, String label, {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentIndigoLight : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accentIndigoLight.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isActive ? Colors.white : AppColors.inkDark,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white.withValues(alpha: 0.95) : AppColors.neutralGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showTrailingArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.inkDark,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.neutralGrey,
          ),
        ),
      ),
      trailing: showTrailingArrow ? const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.inkDark) : null,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(color: Color(0x1A8385A1), height: 1),
    );
  }

  void _showEditBottomSheet(BuildContext context, ProfileController controller) {
    final TextEditingController nameController = TextEditingController(text: controller.fullName.value);
    final TextEditingController usernameController = TextEditingController(text: controller.username.value);
    final TextEditingController phoneController = TextEditingController(text: controller.phoneNumber.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 32,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextField('Full Name', nameController),
              const SizedBox(height: 16),
              _buildTextField('Username', usernameController),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', phoneController),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Changes',
                onPressed: () {
                  final updates = <String, dynamic>{};
                  if (nameController.text.trim() != controller.fullName.value) {
                    updates['fullName'] = nameController.text.trim();
                  }
                  if (usernameController.text.trim() != controller.username.value) {
                    updates['username'] = usernameController.text.trim();
                  }
                  if (phoneController.text.trim() != controller.phoneNumber.value) {
                    updates['phoneNumber'] = phoneController.text.trim();
                  }

                  if (updates.isNotEmpty) {
                    controller.updateProfileData(updates);
                  }
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: 'Enter new $label',
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/colors.dart';

class HrmsAuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String headerTitle;
  final String headerSubtitle;
  final bool showBackButton;
  final bool showProfile;
  final bool showRings;
  final bool isScrollable;
  final double headerHeight;

  const HrmsAuthScaffold({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.headerTitle = 'People Nest',
    this.headerSubtitle = 'by Lokmanya HRMS',
    this.showBackButton = false,
    this.showProfile = false,
    this.showRings = true,
    this.isScrollable = true,
    this.headerHeight = 220.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryIndigo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top branding area with concentric circles
            SizedBox(
              height: headerHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Circle
                  if (showRings)
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                      ),
                    ),
                  // Middle Circle
                  if (showRings)
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                    ),
                  // Inner branding elements
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (headerTitle == 'People Nest') ...[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.people_alt, color: AppColors.surfaceCard, size: 36),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        headerTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.surfaceCard,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (headerSubtitle.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            headerSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.surfaceCard.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // App Bar overlays
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        showBackButton
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Get.back(),
                              )
                            : const SizedBox(width: 48, height: 48),
                        showProfile
                            ? GestureDetector(
                                onTap: () => Get.toNamed('/profile'),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.background,
                                  child: Icon(Icons.person, color: AppColors.primaryIndigo, size: 20),
                                ),
                              )
                            : const SizedBox(width: 36, height: 36),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom sheet area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: isScrollable
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                        child: _buildContent(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                        child: _buildContent(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.inkDark),
          ),
          const SizedBox(height: 8),
        ],
        if (subtitle.isNotEmpty) ...[
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.neutralGrey),
          ),
          const SizedBox(height: 32),
        ],
        // Inject the specific form content here
        if (isScrollable) child else Expanded(child: child),
      ],
    );
  }
}

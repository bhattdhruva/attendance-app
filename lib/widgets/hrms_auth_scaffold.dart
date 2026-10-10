import 'package:flutter/material.dart';
import '../app/colors.dart';

class HrmsAuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const HrmsAuthScaffold({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
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
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Circle
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                    ),
                  ),
                  // Middle Circle
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
                      const Text(
                        'People Nest',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.surfaceCard,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                  child: Column(
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
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/validations/app_validators.dart';
import '../../widgets/textfield.dart';
import '../../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscureText = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _authController.login(email, password);
    if (success) {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryIndigo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top branding area
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people_alt, color: AppColors.surfaceCard, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'People Nest',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.surfaceCard),
            ),
            const SizedBox(height: 40),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.inkDark),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Login to People Nest to continue',
                          style: TextStyle(fontSize: 14, color: AppColors.neutralGrey),
                        ),
                        const SizedBox(height: 32),

                        // Email Label
                        const Text(
                          'Mobile number',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.inkDark),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'e.g. EMP-3000',
                          validator: AppValidators.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.neutralGrey),
                        ),
                        const SizedBox(height: 24),
                        
                        // Password Label
                        const Text(
                          'Password',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.inkDark),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.neutralGrey),
                          validator: AppValidators.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.neutralGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Next Button
                  Obx(() => CustomButton(
                    text: 'Continue',
                    icon: Icons.arrow_forward,
                    isLoading: _authController.isLoading.value,
                    onPressed: _login,
                  )),
                  const SizedBox(height: 32),

                  // Forgot Password
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.inkDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
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

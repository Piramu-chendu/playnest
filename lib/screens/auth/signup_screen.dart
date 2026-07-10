import 'package:flutter/material.dart';
import '../../services/email_service.dart';
import '../../services/otp_service.dart';

import 'verification.dart';

import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/social_button.dart';
import '../../utils/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  final EmailService _emailService = EmailService();

  final OtpService _otpService = OtpService();

  late AnimationController _controller;

  late Animation<double> _floatAnimation;

  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 18,
      end: 40,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> signUpUser() async {
    if (nameController.text.trim().isEmpty) {
      _showMessage("Please enter your full name");

      return;
    }

    if (emailController.text.trim().isEmpty) {
      _showMessage("Please enter your email");

      return;
    }

    if (!emailController.text.contains("@")) {
      _showMessage("Please enter a valid email");

      return;
    }

    if (passwordController.text.isEmpty) {
      _showMessage("Please enter your password");

      return;
    }

    if (passwordController.text.length < 6) {
      _showMessage("Password must be at least 6 characters");

      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      _showMessage("Please confirm your password");

      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showMessage("Passwords do not match");

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String otp = _otpService.generateOtp();

      await _otpService.saveOtp(email: emailController.text.trim(), otp: otp);

      bool sent = await _emailService.sendOtp(
        userName: nameController.text.trim(),

        email: emailController.text.trim(),

        otp: otp,
      );

      if (!sent) {
        _showMessage("Unable to send OTP.");

        setState(() {
          isLoading = false;
        });

        return;
      }

      if (!mounted) return;

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => VerificationScreen(
            name: nameController.text.trim(),

            email: emailController.text.trim(),

            password: passwordController.text,
          ),
        ),
      );
    } catch (e) {
      _showMessage(e.toString());
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        behavior: SnackBarBehavior.floating,

        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -180,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: .12),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withValues(alpha: .10),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, _) => Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withValues(
                                  alpha: .45,
                                ),
                                blurRadius: _glowAnimation.value,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/Playnest logo.jpg',
                            width: 95,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFE5B8FF),
                          Color(0xFFB56CFF),
                          Colors.white,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        "PlayNest",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      "Your Entertainment Nest",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Create Your Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Create your account to receive a secure email verification code.",
                    style: TextStyle(color: Colors.white60, fontSize: 15),
                  ),
                  const SizedBox(height: 28),

                  CustomTextField(
                    hint: "Full Name",
                    icon: Icons.person_outline,
                    controller: nameController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hint: "Password",
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hint: "Confirm Password",
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 28),

                  isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              color: Color(0xFFB56CFF),
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : CustomButton(
                          text: "Send OTP",
                          showArrow: true,
                          onPressed: signUpUser,
                        ),
                  const SizedBox(height: 24),

                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SocialButton(
                    onPressed: () {
                      _showMessage("Google Sign-In is coming soon!");
                    },
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFFB56CFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

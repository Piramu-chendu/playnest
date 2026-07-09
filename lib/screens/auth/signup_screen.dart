import 'package:flutter/material.dart';

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
                color: Colors.purple.withOpacity(.12),
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
                color: Colors.deepPurple.withOpacity(.10),
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
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(.45),
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
                    "Create New Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Join thousands of movie lovers today.",
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

                  CustomButton(
                    text: "Create Account",
                    showArrow: true,
                    onPressed: () {},
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

                  SocialButton(onPressed: () {}),

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
                          onTap: () => Navigator.pop(context),
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

import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../../components/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _loopController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _entranceScale;

  late Animation<double> _floatingAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in Animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Loop Animation
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _entranceScale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 20, end: 45).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _entranceController.forward();

    // Uncomment when Login Screen is ready
    /*
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
    */
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// -------- Animated Logo --------
              AnimatedBuilder(
                animation: Listenable.merge([
                  _entranceController,
                  _loopController,
                ]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: Transform.scale(
                        scale: _entranceScale.value * _breathingAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: _glowAnimation.value,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/Playnest logo.jpg',
                            width: 180,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              /// -------- Welcome Text --------
              FadeTransition(
                opacity: _fadeAnimation,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFE5B8FF),
                        Color(0xFFB56CFF),
                        Colors.white,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "Welcome to PlayNest",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              FadeTransition(
                opacity: _fadeAnimation,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Dive into unlimited movies,\nTV shows and endless entertainment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 55),

              /// -------- Static Buttons --------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomButton(
                  text: "Sign Up",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomButton(
                  text: "Sign In",
                  isOutlined: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

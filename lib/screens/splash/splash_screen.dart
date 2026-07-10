import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  String _displayText = "";
  bool _showText = true;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 20, end: 45).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _type(String text) async {
    setState(() {
      _displayText = "";
      _showText = true;
    });

    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 55));

      if (!mounted) return;

      setState(() {
        _displayText += text[i];
      });
    }
  }

  Future<void> _startSequence() async {
    // Wait while logo floats
    await Future.delayed(const Duration(milliseconds: 1200));

    // First typing
    await _type("Welcome to PlayNest");

    await Future.delayed(const Duration(milliseconds: 900));

    // Fade out
    if (mounted) {
      setState(() {
        _showText = false;
      });
    }

    await Future.delayed(const Duration(milliseconds: 600));

    // Second typing
    await _type("Watch.\nStream.\nEnjoy.");

    // Keep text visible
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to Login
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, _) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
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
                    );
                  },
                ),

                const SizedBox(height: 45),

                AnimatedOpacity(
                  opacity: _showText ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
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
                    child: Text(
                      _displayText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

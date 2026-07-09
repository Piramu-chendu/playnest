import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.onPressed});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.97 : 1,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF171320),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3E3358)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google Logo
              Image.asset("assets/icons/google.png", width: 24, height: 24),

              const SizedBox(width: 14),

              const Text(
                "Continue with Google",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

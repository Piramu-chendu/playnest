import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../services/email_service.dart';
import '../../services/otp_service.dart';
import 'login_screen.dart';
import '../home/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const VerificationScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthService _authService = AuthService();

  final EmailService _emailService = EmailService();

  final OtpService _otpService = OtpService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  int seconds = 60;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    seconds = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  String get enteredOtp {
    return controllers.map((e) => e.text).join();
  }

  Future<void> verifyOtp() async {
    if (enteredOtp.length != 6) {
      showMessage("Enter complete OTP");

      return;
    }

    setState(() {
      isLoading = true;
    });

    bool verified = await _otpService.verifyOtp(
      email: widget.email,

      enteredOtp: enteredOtp,
    );

    if (!verified) {
      setState(() {
        isLoading = false;
      });

      for (final c in controllers) {
        c.clear();
      }
      FocusScope.of(context).requestFocus(focusNodes.first);
      showMessage("Invalid or expired OTP");

      return;
    }

    try {
      UserCredential credential = await _authService.signUp(
        email: widget.email,

        password: widget.password,
      );

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "uid": credential.user!.uid,

        "name": widget.name,

        "email": widget.email,

        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage("Account Verified Successfully 🎉");

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "Verification Failed");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {
    String otp = await _otpService.resendOtp(email: widget.email);

    bool sent = await _emailService.sendOtp(
      userName: widget.name,

      email: widget.email,

      otp: otp,
    );

    if (sent) {
      showMessage("OTP Sent Again");

      startTimer();
    } else {
      showMessage("Unable to send OTP");
    }
  }

  void showMessage(String message) {
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
    timer?.cancel();

    for (var controller in controllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 25),

              Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/images/Playnest logo.jpg",
                  width: 95,
                ),
              ),

              const SizedBox(height: 20),

              ShaderMask(
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
                  "Email Verification",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "We've sent a verification code to",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .75),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFB56CFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 45),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xFF1A1525),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF3A2F55),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFB56CFF),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(
                            context,
                          ).requestFocus(focusNodes[index + 1]);
                        }

                        if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 35),
              Text(
                seconds > 0
                    ? "Resend OTP in ${seconds}s"
                    : "Didn't receive the OTP?",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .75),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: seconds == 0 && !isLoading
                    ? () async {
                        await resendOtp();
                      }
                    : null,
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Color(0xFFB56CFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              isLoading
                  ? const CircularProgressIndicator(color: Color(0xFFB56CFF))
                  : SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB56CFF),
                          elevation: 10,
                          shadowColor: const Color(0xFFB56CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 25),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to Sign Up",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class OtpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate 6-digit OTP
  String generateOtp() {
    Random random = Random();

    return (100000 + random.nextInt(900000)).toString();
  }

  /// Save OTP in Firestore
  Future<void> saveOtp({required String email, required String otp}) async {
    await _firestore.collection("otp_verifications").doc(email).set({
      "otp": otp,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 5)),
      ),
    });
  }

  /// Verify OTP
  Future<bool> verifyOtp({
    required String email,
    required String enteredOtp,
  }) async {
    final document = await _firestore
        .collection("otp_verifications")
        .doc(email)
        .get();

    if (!document.exists) {
      return false;
    }

    final data = document.data();

    if (data == null) {
      return false;
    }

    final String savedOtp = data["otp"];

    final Timestamp expiry = data["expiresAt"];

    if (DateTime.now().isAfter(expiry.toDate())) {
      await document.reference.delete();

      return false;
    }

    if (savedOtp != enteredOtp) {
      return false;
    }

    await document.reference.delete();

    return true;
  }

  /// Resend OTP
  Future<String> resendOtp({required String email}) async {
    String otp = generateOtp();

    await saveOtp(email: email, otp: otp);

    return otp;
  }
}

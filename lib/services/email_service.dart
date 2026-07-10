import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = "service_s11zx3o";
  static const String _templateId = "template_hq31h15";
  static const String _publicKey = "Su8DbB2Ns36zWzP_m";

  static const String _url = "https://api.emailjs.com/api/v1.0/email/send";

  Future<bool> sendOtp({
    required String userName,
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "origin": "http://localhost",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "service_id": _serviceId,
          "template_id": _templateId,
          "user_id": _publicKey,
          "template_params": {
            "user_name": userName,
            "to_email": email,
            "otp": otp,
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }

      print(response.body);

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

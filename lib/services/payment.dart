import 'dart:async';
import 'dart:convert';

import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:http/http.dart' as http;

class PaymentService {

  // 🔥 CREATE ORDER
 static Future<Map<String, dynamic>> createOrder({
  required double amount,
  required String name,
  required String email,
  required String phone,
}) async {

    try {

      final response = await http.post(
        Uri.parse("https://createorder-csauglwufa-uc.a.run.app"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
  "amount": amount,
  "customer_name": name,
  "customer_email": email,
  "customer_phone": phone,
}),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {

        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw Exception("Invalid JSON response");
        }

      } else {
        throw Exception("Server Error: ${response.body}");
      }

    } catch (e) {
      throw Exception("CreateOrder Error: $e");
    }
  }

  // 🔥 START PAYMENT
  static Future<void> startPayment({
    required String orderId,
    required String sessionId,
    required Function onSuccess,
    required Function onError,
  }) async {

    final completer = Completer<void>();

    var service = CFPaymentGatewayService();

    service.setCallback(

      (orderId) async {

        print("✅ Payment Success: $orderId");

        await onSuccess();

        if (!completer.isCompleted) {
          completer.complete();
        }
      },

      (CFErrorResponse error, orderId) async {

        print("❌ Payment Error: ${error.getMessage()}");

        await onError(error.getMessage());

        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    try {

      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.PRODUCTION)
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .build();

      var payment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      service.doPayment(payment);

      // 🔥 WAIT UNTIL PAYMENT COMPLETE
      await completer.future;

    } catch (e) {

      print("❌ Payment Exception: $e");

      await onError(e.toString());

      if (!completer.isCompleted) {
        completer.complete();
      }
    }
  }
}


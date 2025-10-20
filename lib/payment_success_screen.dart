import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String paymentId;

  const PaymentSuccessScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: Text("Payment Success"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Payment ID: $paymentId",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Go Back to Home",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

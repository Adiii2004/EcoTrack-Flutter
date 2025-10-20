import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'delivery_Address_screen.dart';
import 'payment_success_screen.dart';
import 'view/delivery_Address_screen.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';


class PaymentScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double totalPrice;
  final int quantity;
  final double basePrice;
  final String customerName;
  final String customerMobile;
  final String deliveryAddress;
  final AddressType addressType;
  final String deliveryInstructions;

  const PaymentScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.totalPrice,
    required this.quantity,
    required this.basePrice,
    required this.customerName,
    required this.customerMobile,
    required this.deliveryAddress,
    required this.addressType,
    required this.deliveryInstructions,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // ⚠️ Dummy test key
      'amount': widget.totalPrice*100, // in paise = ₹500
      'name': 'EcoTrack AI',
      'description': 'Eco Product Purchase',
      'prefill': {'contact': '7774086343', 'email': 'pawaraniketr@gmail.com'},
      'theme': {'color': '#0F3D6C'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentSuccessScreen(paymentId: response.paymentId!),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment Failed ❌")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("External Wallet Selected")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
        backgroundColor: Colors.green.shade600,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Amount: ₹${widget.totalPrice}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Proceed to Pay 💳",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

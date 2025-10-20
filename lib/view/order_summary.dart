import 'dart:math';
import 'package:flutter/material.dart';
import '../razorPayment.dart';
import 'delivery_Address_screen.dart';
//import 'razorPayment.dart';

// Placeholder Enums and Screens to make the code runnable.
// NOTE: You must ensure 'delivery_Address_screen.dart' and 'razorPayment.dart' 
// contain the necessary definitions for AddressType and PaymentScreen.

//enum AddressType { home, office, other }

// Placeholder screen for the payment process (from razorPayment.dart)
// class PaymentScreen extends StatelessWidget {
//   final String productName;
//   final String productImage;
//   final double totalPrice;
//   final int quantity;
//   final double basePrice;
//   final String customerName;
//   final String customerMobile;
//   final String deliveryAddress;
//   final AddressType addressType;
//   final String deliveryInstructions;

//   const PaymentScreen({
//     super.key,
//     required this.productName,
//     required this.productImage,
//     required this.totalPrice,
//     required this.quantity,
//     required this.basePrice,
//     required this.customerName,
//     required this.customerMobile,
//     required this.deliveryAddress,
//     required this.addressType,
//     required this.deliveryInstructions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment Gateway'),
//         backgroundColor: Colors.green.shade100,
//       ),
//       body: Center(child: Text('Paying ₹${totalPrice.toStringAsFixed(2)} for $productName')),
//     );
//   }
// }

// void main() {
//   // Example data to launch the OrderSummaryScreen directly
//   const exampleOrder = OrderSummaryScreen(
//     productName: 'Organic Compost 5kg',
//     productImage: 'https://5.imimg.com/data5/SELLER/Default/2023/11/361907764/JP/HF/BQ/182617830/urea-fertilizer-500x500.jpg',
//     totalPrice: 617.0, // This value is recalculated inside the State
//     quantity: 2,
//     basePrice: 299.0, // price per item (299 * 2 = 598)
//     customerName: 'Rahul Sharma',
//     customerMobile: '+91 98765 43210',
//     deliveryAddress: 'A-204, Green Valley Apartments\nMG Road, Sector 15\nMumbai, Maharashtra - 400001',
//     addressType: AddressType.home,
//     deliveryInstructions: 'Leave package with security if no answer.',
//   );

//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Order Summary',
//       theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Poppins'),
//       home: exampleOrder,
//     ),
//   );
// }

class OrderSummaryScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double totalPrice; // Note: This value is effectively ignored as it's recalculated
  final int quantity;
  final double basePrice;
  final String customerName;
  final String customerMobile;
  final String deliveryAddress;
  final AddressType addressType;
  final String deliveryInstructions;

  const OrderSummaryScreen({
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
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  // Calculated properties based on widget data
  double get deliveryCharges => 49.0;
  double get ecoDiscount => 30.0;
  double get subtotal => widget.basePrice * widget.quantity;
  double get grandTotal => subtotal + deliveryCharges - ecoDiscount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      body: Stack(
        children: [
          const AnimatedBubbleBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildGlossyCard(child: _buildProductDetailsCard()),
                    const SizedBox(height: 16),
                    _buildGlossyCard(child: _buildDeliveryAddressCard()), // NOW CORRECT
                    const SizedBox(height: 16),
                    _buildGlossyCard(child: _buildPriceBreakdownCard()),
                    const SizedBox(height: 16),
                    _buildGlossyCard(child: const PaymentMethodCard()),
                    const SizedBox(height: 24),
                    _buildProceedButton(),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          '100% Secure & Encrypted Payment',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGlossyCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  Widget _buildProductDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.productImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium quality organic fertilizer', // Placeholder description
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Qty: ${widget.quantity}',
                          style: TextStyle(color: Colors.grey.shade600)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Compost', // Placeholder category
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              // Display base price * quantity (subtotal)
              '₹${subtotal.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  // CORRECTED: This method is now inside the State class
  Widget _buildDeliveryAddressCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () {

                  Navigator.pop(context);
                // TODO: Implement navigation to ChangeAddressScreen
              },
              child: Text(
                'Change',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, color: Colors.green.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.customerName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.addressType.name.toUpperCase(),
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.deliveryAddress,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(widget.customerMobile,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  if (widget.deliveryInstructions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Instructions: ${widget.deliveryInstructions}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBreakdownCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _PriceRow(
            label: 'Subtotal (${widget.quantity} items)',
            amount: '₹${subtotal.toStringAsFixed(2)}'),
        _PriceRow(
            label: 'Delivery Charges',
            amount: '₹${deliveryCharges.toStringAsFixed(2)}'),
        _PriceRow(
          label: 'Eco Discount',
          amount: '-₹${ecoDiscount.toStringAsFixed(2)}',
          amountColor: Colors.green,
        ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Grand Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('₹${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Passing all data to the next screen (PaymentScreen)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  productName: widget.productName,
                  productImage: widget.productImage,
                  totalPrice: grandTotal,
                  quantity: widget.quantity,
                  basePrice: widget.basePrice,
                  customerName: widget.customerName,
                  customerMobile: widget.customerMobile,
                  deliveryAddress: widget.deliveryAddress,
                  addressType: widget.addressType,
                  deliveryInstructions: widget.deliveryInstructions,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Proceed to Payment  ₹${grandTotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final Color? amountColor;

  const _PriceRow({required this.label, required this.amount, this.amountColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(amount,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: amountColor ?? Colors.black87)),
        ],
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.credit_card, color: Colors.green.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Credit/Debit Card', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Secure payment via Razorpay',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // TODO: Implement navigation to ChangePaymentMethodScreen
              },
              child: Text('Change',
                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// Animated Background Classes (No changes made here)
// ------------------------------------------------------------------

class AnimatedBubbleBackground extends StatefulWidget {
  const AnimatedBubbleBackground({super.key});

  @override
  State<AnimatedBubbleBackground> createState() =>
      _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> bubbles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 20; i++) {
      bubbles.add(Bubble(random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: BubblePainter(bubbles, _controller.value),
        );
      },
    );
  }
}

class Bubble {
  final double x;
  double y;
  final double radius;
  final Color color;
  final double speed;
  final Random random;

  Bubble(this.random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        radius = random.nextDouble() * 10 + 5,
        color = Colors.green.withOpacity(random.nextDouble() * 0.2 + 0.05),
        speed = random.nextDouble() * 0.005 + 0.001;

  void move() {
    y -= speed;
    if (y < -0.1) y = 1.1;
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblePainter(this.bubbles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      bubble.move();
      final paint = Paint()..color = bubble.color;
      canvas.drawCircle(Offset(bubble.x * size.width, bubble.y * size.height),
          bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
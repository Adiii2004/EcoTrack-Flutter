import 'dart:math';
import 'package:flutter/material.dart';
import '../global_cart.dart';
//import 'global_cart.dart'; // <-- Import global cart

class CartItem {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final double originalPrice;
  final List<String> tags;
  int quantity;

  CartItem({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.originalPrice,
    required this.tags,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey _summaryKey = GlobalKey();
  double _summaryHeight = 380;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSummaryHeight());
  }

  void _getSummaryHeight() {
    final RenderBox? renderBox =
        _summaryKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _summaryHeight = renderBox.size.height;
      });
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      globalCart[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (globalCart[index].quantity > 1) {
        globalCart[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      globalCart.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      globalCart.clear();
    });
  }

  double get _subtotal =>
      globalCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get _deliveryFee => _subtotal > 500 ? 0.0 : 50.0;
  double get _taxes => _subtotal * 0.05;
  double get _grandTotal => _subtotal + _deliveryFee + _taxes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Cart (${globalCart.length})',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white.withOpacity(0.5),
        elevation: 0,
        actions: [
          if (globalCart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text(
                        'Are you sure you want to remove all items?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _clearCart();
                          Navigator.pop(context);
                        },
                        child:
                            const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedBubbleBackground(),
          globalCart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 100, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        "Your cart is empty!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add some products to get started",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Continue Shopping'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.all(16.0)
                          .copyWith(bottom: _summaryHeight + 20),
                      itemCount: globalCart.length,
                      itemBuilder: (context, index) {
                        final item = globalCart[index];
                        return _buildCartItemCard(item, index);
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildPriceSummaryAndActions(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  Widget _buildGlossyCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.85),
            Colors.white.withOpacity(0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.lightGreenAccent.shade400.withOpacity(0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.lightGreenAccent.shade400.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    return _buildGlossyCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    item.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: -10,
                  left: -10,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
                    onPressed: () => _removeItem(index),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildQuantityButton(
                            Icons.remove,
                            () => _decrementQuantity(index),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            Icons.add,
                            () => _incrementQuantity(index),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (item.originalPrice != item.price)
                            Text(
                              '₹${(item.originalPrice * item.quantity).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          Text(
                            '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: icon == Icons.add ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: icon == Icons.add ? Colors.white : Colors.black54,
          size: 18,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPriceSummaryAndActions() {
    return Container(
      key: _summaryKey,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriceRow('Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildPriceRow(
            'Delivery Fee',
            _deliveryFee > 0 ? '₹${_deliveryFee.toStringAsFixed(0)}' : 'FREE',
            valueColor: _deliveryFee > 0 ? Colors.black87 : Colors.green,
          ),
          const SizedBox(height: 8),
          _buildPriceRow('Taxes (5%)', '₹${_taxes.toStringAsFixed(0)}'),
          const Divider(height: 32, thickness: 1),
          _buildPriceRow(
            'Grand Total',
            '₹${_grandTotal.toStringAsFixed(0)}',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                _deliveryFee > 0
                    ? 'Add ₹${(500 - _subtotal).toStringAsFixed(0)} more for FREE delivery'
                    : 'Estimated delivery: 2-3 days',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight:
                      _deliveryFee > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            'Proceed to Checkout',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proceeding to checkout...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            isPrimary: true,
            icon: Icons.payment,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Continue Shopping',
            onPressed: () => Navigator.pop(context),
            isPrimary: false,
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isTotal ? Colors.black : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text,
      {required VoidCallback onPressed,
      bool isPrimary = true,
      required IconData icon}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : Colors.green.shade700,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.white : Colors.green.shade700,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isPrimary ? Colors.green.shade600 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.green.shade600, width: 2),
          ),
          elevation: isPrimary ? 5 : 0,
          shadowColor:
              isPrimary ? Colors.green.withOpacity(0.4) : Colors.transparent,
        ),
      ),
    );
  }
}

// ==================== ANIMATED BUBBLE BACKGROUND ====================
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
      duration: const Duration(seconds: 15),
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
          painter: BubblePainter(bubbles),
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
        radius = random.nextDouble() * 12 + 5,
        color = Colors.green.withOpacity(random.nextDouble() * 0.2 + 0.05),
        speed = random.nextDouble() * 0.003 + 0.001;

  void move() {
    y -= speed;
    if (y < -0.1) {
      y = 1.1;
    }
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      bubble.move();
      final paint = Paint()..color = bubble.color;
      canvas.drawCircle(
        Offset(bubble.x * size.width, bubble.y * size.height),
        bubble.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

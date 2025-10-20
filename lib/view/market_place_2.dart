import 'package:flutter/material.dart';
import 'dart:ui'; // Required for ImageFilter and BackdropFilter
// Required for Timer
import 'dart:math'; // Required for Random

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final double _basePrice = 1450.00;
  double _totalPrice = 1450.00;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = _basePrice * _quantity;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _totalPrice = _basePrice * _quantity;
      }
    });
  }

  void _showProductImageFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.black.withOpacity(0.9),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: const SizedBox.shrink(),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: Center(
            child: Hero(
              tag: 'productImage',
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  "https://5.imimg.com/data5/SELLER/Default/2023/11/361907764/JP/HF/BQ/182617830/urea-fertilizer-500x500.jpg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set main Scaffold background to white
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // ***** ANIMATED BUBBLE BACKGROUND ADDED HERE *****
          const AnimatedBubbleBackground(),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 20),
                _buildGlassyCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'productImage',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            'https://5.imimg.com/data5/SELLER/Default/2023/11/361907764/JP/HF/BQ/182617830/urea-fertilizer-500x500.jpg',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 250,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(color: Colors.green),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _buildCategoryChip(),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _showProductImageFullScreen(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: const Icon(Icons.fullscreen, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildGlassyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Urea Nitrogen Fertilizer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('High-quality imported urea fertilizer with 46% Nitrogen.', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
                      const SizedBox(height: 16),
                      _buildStoreAndPriceRow(),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          _buildFeatureChip(Icons.science_outlined, '46% Nitrogen'),
                          _buildFeatureChip(Icons.eco_outlined, 'Imported'),
                          _buildFeatureChip(Icons.verified_outlined, 'ISO Certified'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildGlassyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('About This Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('This is a high-quality imported Urea fertilizer containing 46% nitrogen, essential for plant growth and development.', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
                      const SizedBox(height: 16),
                      _buildProductInfoRow('Weight', '50 kg'),
                      const Divider(height: 16, color: Colors.black12),
                      _buildProductInfoRow('Type', 'Urea Fertilizer'),
                      const Divider(height: 16, color: Colors.black12),
                      _buildProductInfoRow('Delivery', '3-5 days'),
                      const Divider(height: 16, color: Colors.black12),
                      _buildProductInfoRow('Return Policy', 'Non-returnable'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildGlassyCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          _buildQuantityButton(Icons.remove, _decrementQuantity),
                          SizedBox(
                            width: 40,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                              child: Text('$_quantity', key: ValueKey<int>(_quantity), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          _buildQuantityButton(Icons.add, _incrementQuantity),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                            child: Text('₹${_totalPrice.toStringAsFixed(0)}', key: ValueKey<double>(_totalPrice), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF8BC34A), Color(0xFF689F38)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: const Color(0xFF689F38).withOpacity(0.6), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 22),
                          label: const Text('Buy Now', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: EdgeInsets.zero),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF4CAF50), size: 22),
                        label: const Text('Add to Cart', style: TextStyle(fontSize: 18, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2, backgroundColor: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassyCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: Colors.green.shade50.withOpacity(0.8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.shade300, width: 1), boxShadow: [BoxShadow(color: Colors.green.shade100.withOpacity(0.4), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 8),
          Text('Fertilizer', style: TextStyle(color: Colors.green.shade800, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStoreAndPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          radius: 22,
          backgroundColor: Colors.green.shade100,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Agri Supply Co.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Row(
                children: List.generate(5, (i) => Icon(i < 4 ? Icons.star : Icons.star_half, color: Colors.amber, size: 18))
                  ..add(const Text(' (4.9)', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500))),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${_basePrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            const Text('₹1899', style: TextStyle(fontSize: 15, color: Colors.grey, decoration: TextDecoration.lineThrough)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(IconData i, String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9).withOpacity(0.7), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.green.shade100, width: 1), boxShadow: [BoxShadow(color: Colors.green.shade50.withOpacity(0.3), spreadRadius: 0, blurRadius: 5, offset: const Offset(0, 2))]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(t, style: TextStyle(fontSize: 14, color: Colors.green.shade800, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProductInfoRow(String l, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
          Text(v, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData i, VoidCallback o) {
    return GestureDetector(
      onTap: o,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.green.shade100.withOpacity(0.8), shape: BoxShape.circle, border: Border.all(color: Colors.green.shade300, width: 1.2), boxShadow: [BoxShadow(color: Colors.green.shade50.withOpacity(0.3), spreadRadius: 0, blurRadius: 5, offset: const Offset(0, 2))]),
        child: Icon(i, color: Colors.green.shade700, size: 20),
      ),
    );
  }
}

// ***** NEW WIDGET FOR ANIMATED BUBBLE BACKGROUND *****
class AnimatedBubbleBackground extends StatefulWidget {
  const AnimatedBubbleBackground({super.key});

  @override
  State<AnimatedBubbleBackground> createState() => _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;
  final Random _random = Random();
  final int _numberOfBubbles = 8; // Number of bubbles to animate

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Animation cycle duration
    )..repeat(); // Repeat indefinitely

    _bubbles = List.generate(_numberOfBubbles, (index) => Bubble(random: _random));

    _controller.addListener(() {
      setState(() {
        // Update bubble positions and properties on each frame
        for (var bubble in _bubbles) {
          bubble.update(_controller.value);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color (can be a light subtle color or white)
        Container(color: Colors.white),
        // Animated bubbles
        ..._bubbles.map((bubble) => Positioned(
              left: bubble.x * MediaQuery.of(context).size.width,
              top: bubble.y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: bubble.opacity,
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        bubble.color.withOpacity(bubble.opacity),
                        Colors.white.withOpacity(0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            )),
        // Optional: A very subtle blur layer over the bubbles for extra softness
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Lighter blur
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

// Helper class to manage individual bubble properties
class Bubble {
  final Random random;
  late double x, y, size, speed, opacity, directionX, directionY;
  late Color color;

  Bubble({required this.random}) {
    _reset();
  }

  void _reset() {
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 100 + 50; // Bubbles from 50 to 150
    speed = random.nextDouble() * 0.005 + 0.001; // Slower speed
    opacity = random.nextDouble() * 0.3 + 0.1; // More subtle opacity
    directionX = (random.nextBool() ? 1 : -1) * (random.nextDouble() * 0.0005 + 0.0001);
    directionY = (random.nextBool() ? 1 : -1) * (random.nextDouble() * 0.0005 + 0.0001);
    color = _getRandomBubbleColor();
  }

  Color _getRandomBubbleColor() {
    final colors = [
      Colors.green.shade50.withOpacity(0.8),
      Colors.green.shade100.withOpacity(0.8),
      Colors.teal.shade50.withOpacity(0.8),
      Colors.white.withOpacity(0.9), // More white bubbles
    ];
    return colors[random.nextInt(colors.length)];
  }

  void update(double animationValue) {
    x += directionX * (1 + sin(animationValue * pi * 2)); // Oscillate movement
    y += directionY * (1 + cos(animationValue * pi * 2)); // Oscillate movement

    // Wrap around screen edges
    if (x > 1.2 || x < -0.2 || y > 1.2 || y < -0.2) {
      _reset(); // Reset bubble if it goes too far off-screen
    }

    // Subtle size and opacity changes
    size = (random.nextDouble() * 100 + 50) * (0.8 + 0.2 * sin(animationValue * pi * 4));
    opacity = (random.nextDouble() * 0.3 + 0.1) * (0.7 + 0.3 * cos(animationValue * pi * 2));
  }
}
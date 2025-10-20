import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

//import 'cart_screen.dart';
//import 'delivery_Address_screen.dart';
import 'global_cart.dart';
import 'view/cart_screen.dart';
import 'view/delivery_Address_screen.dart';

// Note: Removed 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
// and replaced its usage in _buildGlassyCard with standard BoxShadows.

// ============================================================================
// MAIN NAVIGATION FLOW: Product Detail → Address → Payment
// ============================================================================

class ProductDetailScreenWithParams extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final double oldPrice;
  final List<String> features;
  final String category;
  final String storeName;
  final double rating;

  const ProductDetailScreenWithParams({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.oldPrice,
    required this.features,
    required this.category,
    required this.storeName,
    required this.rating,
  });

  @override
  State<ProductDetailScreenWithParams> createState() =>
      _ProductDetailScreenWithParamsState();
}

class _ProductDetailScreenWithParamsState
    extends State<ProductDetailScreenWithParams> {
  int _quantity = 1;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.basePrice;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = widget.basePrice * _quantity;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _totalPrice = widget.basePrice * _quantity;
      }
    });
  }

  void _showProductImageFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => Scaffold(
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
              )
            ],
          ),
          body: Center(
            child: Hero(
              tag: widget.imageUrl,
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  widget.imageUrl,
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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Enhanced Frosted Glass AppBar
        backgroundColor: Colors.white.withOpacity(0.4),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Stronger blur
            child: Container(
              color: Colors.white.withOpacity(0.1), // Subtle color layer
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // New Animated Background
          const AnimatedWavyGradientBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        20),
                _buildGlassyCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Hero(
                        tag: widget.imageUrl,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20.0), // More rounded corners
                          child: Image.network(
                            widget.imageUrl,
                            height: 280, // Slightly taller image area
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 280,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                    color: Colors.green),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _buildCategoryChip(widget.category),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _showProductImageFullScreen(context),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(15), // Bigger radius
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10), // Stronger blur for control
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5)),
                                ),
                                child: const Icon(Icons.fullscreen,
                                    color: Colors.white,
                                    size: 28), // Larger icon
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
                      Text(widget.name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87)),
                      const SizedBox(height: 10),
                      _buildStoreAndPriceRow(),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.black12, height: 1),
                      const SizedBox(height: 16),
                      Text(
                        'Key Features',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10.0, // Increased spacing
                        runSpacing: 10.0,
                        children: widget.features
                            .map((f) => _buildFeatureChip(
                                Icons.check_circle_outline, f))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildGlassyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Product Description',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 12),
                      Text(widget.description,
                          style: TextStyle(
                              fontSize: 15, // Slightly larger text
                              color: Colors.grey.shade800,
                              height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Combined Quantity and Buy/Cart buttons into one final glossy section
                _buildFinalActionCard(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== WIDGETS ====================

  Widget _buildFinalActionCard(BuildContext context) {
    return _buildGlassyCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Quantity Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Row(
                children: [
                  _buildQuantityButton(Icons.remove, _decrementQuantity),
                  SizedBox(
                    width: 40,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: Text('$_quantity',
                          key: ValueKey<int>(_quantity),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ),
                  ),
                  _buildQuantityButton(Icons.add, _incrementQuantity),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Price',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.5), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text('₹${_totalPrice.toStringAsFixed(0)}',
                        key: ValueKey<double>(_totalPrice),
                        style: TextStyle(
                            fontSize: 26, // Highlighted price
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade600)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Buttons
          Row(
            children: [
              // ADD TO CART BUTTON (Glossy Outlined)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final cartItem = CartItem(
                        name: widget.name,
                        description: widget.description,
                        imagePath: widget.imageUrl,
                        price: widget.basePrice,
                        originalPrice: widget.oldPrice,
                        tags: [widget.category, 'In Stock'],
                        quantity: _quantity,
                      );

                      globalCart.add(cartItem); // Add to global cart

                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.name} added to cart!'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Color(0xFF4CAF50), size: 24),
                    label: const Text('Add to Cart',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: const Color(0xFF4CAF50).withOpacity(0.6),
                          width: 1.5),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 0, // Removed elevation for glossy outline look
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.green.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // BUY NOW BUTTON (Glossy Gradient)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF689F38).withOpacity(0.7),
                          blurRadius: 15,
                          offset: const Offset(0, 8))
                    ],
                    gradient: const LinearGradient(
                        colors: [Color(0xFF8BC34A), Color(0xFF689F38)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DeliveryAddressScreen(
                            productName: widget.name,
                            productImage: widget.imageUrl,
                            totalPrice: _totalPrice,
                            quantity: _quantity,
                            basePrice: widget.basePrice,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 24),
                    label: const Text('Buy Now',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.zero),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassyCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20), // Slightly larger for a softer look
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Stronger blur
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4), // More transparency
              borderRadius: BorderRadius.circular(20),
              // Glossy border effect
              border:
                  Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
              boxShadow: [
                // Only using outer shadows since the inset package is removed.
                const BoxShadow(
                  color: Color.fromARGB(128, 255, 255, 255),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
                // Replaced custom inset shadow with a subtle highlight effect
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(-5, -5),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8), // Larger chip
      decoration: BoxDecoration(
        color: Colors.green.shade50.withOpacity(0.9), // More opaque
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200, width: 1),
      ),
      child: Text(category,
          style: TextStyle(
              color: Colors.green.shade900, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStoreAndPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade100,
          radius: 25, // Slightly larger avatar
          child: Icon(Icons.storefront_outlined, color: Colors.green.shade600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.storeName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: Colors.black87)),
              Row(
                children: [
                  ...List.generate(
                      5,
                      (i) => Icon(
                          i < widget.rating.floor()
                              ? Icons.star
                              : Icons.star_half,
                          color: Colors.amber,
                          size: 18)),
                  const SizedBox(width: 8),
                  Text('(${widget.rating.toStringAsFixed(1)})',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${widget.oldPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.redAccent, // Red for better contrast/sales feel
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500)),
            Text('₹${widget.basePrice.toStringAsFixed(0)}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.green.shade600)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10), // Larger padding
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.green.shade100, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  color: Colors.green.shade800, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10), // Slightly larger
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: Colors.green.shade700, size: 22), // Larger icon
      ),
    );
  }
}

// ==================== NEW ANIMATED BACKGROUND WIDGET ====================

class AnimatedWavyGradientBackground extends StatefulWidget {
  const AnimatedWavyGradientBackground({super.key});

  @override
  State<AnimatedWavyGradientBackground> createState() =>
      _AnimatedWavyGradientBackgroundState();
}

class _AnimatedWavyGradientBackgroundState
    extends State<AnimatedWavyGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Slow, soothing animation
    )..repeat(reverse: true);

    // Creates a smooth, infinite loop motion for gradient points
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
              colors: [
                Colors.green.shade50,
                Colors.teal.shade50.withOpacity(0.7),
                Colors.green.shade100.withOpacity(0.5),
                Colors.white,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
}
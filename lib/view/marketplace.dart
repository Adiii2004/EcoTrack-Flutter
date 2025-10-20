import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../product_details.dart';
//import 'product_details.dart';

void main() {
  runApp(const EcoMarketplaceApp());
}

class EcoMarketplaceApp extends StatelessWidget {
  const EcoMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2D5F3F),
        scaffoldBackgroundColor: const Color(0xFFF5F9F5),
      ),
      home: const EcoMarketplaceScreen(),
    );
  }
}

// *UPDATED Product Model* to include fields for the detail screen
class Product {
  final String title;
  final String subtitle;
  final String category;
  final double price; // Changed from String to double for detail screen logic
  final double oldPrice; // Added for detail screen
  final List<String> features; // Added for detail screen
  final double rating; // Added for detail screen
  final String storeName; // Added for detail screen
  final IconData icon;
  final Color color;
  final String imageUrl;

  Product({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.features,
    required this.rating,
    required this.storeName,
    required this.icon,
    required this.color,
    required this.imageUrl,
  });
}

class EcoMarketplaceScreen extends StatefulWidget {
  const EcoMarketplaceScreen({super.key});

  @override
  State<EcoMarketplaceScreen> createState() => _EcoMarketplaceScreenState();
}

class _EcoMarketplaceScreenState extends State<EcoMarketplaceScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late AnimationController _shimmerController;
  late AnimationController _overlayController;
  bool _showOverlay = false;
  String _selectedCategory = 'All';

  // *UPDATED Product Data* to include all required fields
  final List<Product> allProducts = [
    Product(
      title: 'Organic Compost',
      subtitle: '100% natural, nutrient-rich soil booster.',
      category: 'Compost',
      price: 450.0,
      oldPrice: 599.0,
      features: ['100% Natural', 'Odor-free', 'Soil Booster'],
      rating: 4.5,
      storeName: 'EcoFarm India',
      icon: Icons.eco,
      color: Colors.green,
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
    ),
    Product(
      title: 'Recycled Paper Notebook',
      subtitle: 'A5, 120 pages, 100% recycled fibers.',
      category: 'Stationery',
      price: 299.0,
      oldPrice: 350.0,
      features: ['Recycled Paper', 'A5 Size', 'Biodegradable'],
      rating: 4.8,
      storeName: 'GreenWrite Supplies',
      icon: Icons.book,
      color: Colors.blue,
      imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=300&fit=crop',
    ),
    Product(
      title: 'Bamboo Utensils',
      subtitle: 'Fork, spoon, and knife set with linen pouch.',
      category: 'Kitchen',
      price: 350.0,
      oldPrice: 400.0,
      features: ['Sustainable Bamboo', 'Travel Kit', 'Reusable'],
      rating: 4.3,
      storeName: 'Bamboo Bliss',
      icon: Icons.restaurant,
      color: Colors.brown,
      imageUrl: 'https://images.unsplash.com/photo-1596040033229-a0b55ee2d2e9?w=400&h=300&fit=crop',
    ),
    Product(
      title: 'Organic Veggie Seeds Pack',
      subtitle: 'Heirloom variety, non-GMO, 10-pack assortment.',
      category: 'Seeds',
      price: 199.0,
      oldPrice: 250.0,
      features: ['Non-GMO', 'Heirloom', 'High Germination'],
      rating: 4.9,
      storeName: 'Seedling Dreams',
      icon: Icons.local_florist,
      color: Colors.pink,
      imageUrl: 'https://images.unsplash.com/photo-1592150621744-aca64f48394a?w=400&h=300&fit=crop',
    ),
    Product(
      title: 'Organic Cotton Jute Bag',
      subtitle: 'Large size, durable, perfect for shopping.',
      category: 'Fashion',
      price: 450.0,
      oldPrice: 550.0,
      features: ['Organic Cotton', 'Durable Jute', 'Reuasable'],
      rating: 4.1,
      storeName: 'Aura Bags',
      icon: Icons.shopping_bag,
      color: Colors.orange,
      imageUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=400&h=300&fit=crop',
    ),
    Product(
      title: 'Solar LED Lights',
      subtitle: 'Automatic outdoor path lights, pack of 4.',
      category: 'Garden',
      price: 799.0,
      oldPrice: 999.0,
      features: ['Solar Powered', 'Weatherproof', 'Easy Install'],
      rating: 4.6,
      storeName: 'SunLight Innovations',
      icon: Icons.light_mode,
      color: Colors.amber,
      imageUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=400&h=300&fit=crop',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _shimmerController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
      if (_showOverlay) {
        _overlayController.forward();
      } else {
        _overlayController.reverse();
      }
    });
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') return allProducts;
    return allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  // *New* Navigation method
  void _navigateToDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreenWithParams(
          name: product.title,
          description: product.subtitle, // Using subtitle as description
          imageUrl: product.imageUrl,
          basePrice: product.price,
          oldPrice: product.oldPrice,
          features: product.features,
          category: product.category,
          storeName: product.storeName,
          rating: product.rating,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildFeaturedProducts(),
                  _buildAllProducts(),
                  _buildSellProducts(),
                  _buildSupportButton(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          if (_showOverlay) _buildOverlay(),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
        child: FloatingActionButton(
          onPressed: () {
            _fabController.reverse().then((_) => _fabController.forward());
          },
          backgroundColor: const Color(0xFF2D5F3F),
          elevation: 8,
          child: AnimatedBuilder(
            animation: _fabController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _fabController.value * 2 * math.pi,
                child: const Icon(Icons.add, size: 32),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return AnimatedBuilder(
      animation: _overlayController,
      builder: (context, child) {
        return Opacity(
          opacity: _overlayController.value,
          child: Container(
            color: Colors.black.withOpacity(0.5 * _overlayController.value),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _overlayController,
                curve: Curves.easeOutCubic,
              )),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF5F9F5),
                      Colors.green.shade50,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildOverlayHeader(),
                      _buildCategoryFilter(),
                      Expanded(child: _buildOverlayProductGrid()),
                    ],
                  ),
                ),
              ),
            ),
        ));
      },
    );
  }

  Widget _buildOverlayHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'All Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F3F),
            ),
          ),
          GestureDetector(
            onTap: _toggleOverlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Color(0xFF2D5F3F)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Compost', 'Stationery', 'Kitchen', 'Seeds', 'Fashion', 'Garden'];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF2D5F3F).withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2D5F3F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverlayProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _buildEnhancedProductCard(product),
              ),
            );
          },
        );
      },
    );
  }

  // *UPDATED* to be tappable
  Widget _buildEnhancedProductCard(Product product) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Hero( // Added Hero for animation
                    tag: product.imageUrl,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  product.color.withOpacity(0.7),
                                  product.color,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(product.icon, size: 40, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(Icons.favorite_border, size: 16, color: product.color),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade100, Colors.orange.shade200],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.subtitle,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D5F3F),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}', // Updated to double
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D5F3F),
                          ),
                        ),
                        _buildSmallGlossyButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    ));
  }

  Widget _buildSmallGlossyButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D5F3F).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        'Buy',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlossyIconBox(Icons.shopping_bag, Colors.orange, 0),
                  const SizedBox(width: 8),
                  _buildGlossyIconBox(Icons.eco, Colors.green, 200),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlossyIconBox(IconData icon, Color color, int delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(Colors.white.withOpacity(0.7), color),
                  Color.alphaBlend(Colors.white.withOpacity(0.5), color),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 8,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF2D5F3F), Color(0xFF1a3d28)],
                    ).createShader(bounds),
                    child: const Text(
                      'Eco Marketplace',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buy and Support Eco-Friendly Living',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.grey.shade50],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.9),
                                blurRadius: 10,
                                offset: const Offset(-4, -4),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search eco-products, categories...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2D5F3F).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(-2, -2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedProducts() {
    // Using dummy data structure here, since the featured cards are hardcoded widgets
    final featuredProduct1 = Product(
      title: 'Premium Organic Compost',
      subtitle: '100% natural, nutrient-rich soil booster.',
      category: 'Compost',
      price: 500.0,
      oldPrice: 650.0,
      features: ['100% Natural', 'Odor-free', 'Soil Booster'],
      rating: 4.5,
      storeName: 'EcoFarm India',
      icon: Icons.grass,
      color: Colors.green.shade700,
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
    );

    final featuredProduct2 = Product(
      title: 'Bamboo Garden Tools Set',
      subtitle: 'Essential, durable, and eco-friendly gardening set.',
      category: 'Garden',
      price: 899.0,
      oldPrice: 1100.0,
      features: ['Sustainable Bamboo', 'Durable', 'Toxin-Free'],
      rating: 4.7,
      storeName: 'Crafty Co.',
      icon: Icons.yard,
      color: Colors.brown.shade700,
      imageUrl: 'https://images.unsplash.com/photo-1617576683096-00fc8eecb3af?w=400&h=300&fit=crop',
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.orange,
                              Colors.orange.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.6 * _shimmerController.value),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5F3F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnimatedProductCard(
                  featuredProduct1.category,
                  featuredProduct1.title,
                  featuredProduct1.storeName,
                  '₹${featuredProduct1.price.toStringAsFixed(0)}',
                  featuredProduct1.color,
                  featuredProduct1.icon,
                  featuredProduct1.imageUrl,
                  0,
                  onTap: () => _navigateToDetail(context, featuredProduct1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnimatedProductCard(
                  featuredProduct2.category,
                  featuredProduct2.title,
                  featuredProduct2.storeName,
                  '₹${featuredProduct2.price.toStringAsFixed(0)}',
                  featuredProduct2.color,
                  featuredProduct2.icon,
                  featuredProduct2.imageUrl,
                  200,
                  onTap: () => _navigateToDetail(context, featuredProduct2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // *UPDATED* to accept onTap callback
  Widget _buildAnimatedProductCard(
      String tag,
      String title,
      String seller,
      String price,
      Color color,
      IconData icon,
      String imageUrl,
      int delay, {
      required VoidCallback onTap,
      }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: _buildProductCard(tag, title, seller, price, color, icon, imageUrl, onTap),
        );
      },
    );
  }

  // *UPDATED* to be tappable with Hero animation tag
  Widget _buildProductCard(
      String tag,
      String title,
      String seller,
      String price,
      Color color,
      IconData icon,
      String imageUrl,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 12,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero( // Added Hero for animation
                  tag: imageUrl,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withOpacity(0.8),
                                color,
                                color.withOpacity(0.9),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Center(
                            child: Icon(icon, size: 48, color: Colors.white.withOpacity(0.9)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade100, Colors.orange.shade200],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5F3F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seller,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D5F3F),
                        ),
                      ),
                      _buildGlossyButton('Buy Now'),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildGlossyButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F), Color(0xFF1a3d28)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D5F3F).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: Colors.white24,
            blurRadius: 4,
            offset: Offset(-1, -1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green,
                              Colors.green.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.6 * (1 - _shimmerController.value)),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5F3F),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _toggleOverlay,
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFF2D5F3F), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final displayProducts = allProducts.take(6).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 1200 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildGridProductCard(product),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // *UPDATED* to be tappable
  Widget _buildGridProductCard(Product product) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 10,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero( // Added Hero for animation
                  tag: product.imageUrl,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                product.color.withOpacity(0.7),
                                product.color,
                                product.color.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Center(
                            child: Icon(product.icon, size: 40, color: Colors.white.withOpacity(0.9)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade100, Colors.orange.shade200],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5F3F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${product.storeName}', // Used actual store name
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}', // Updated to double
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5F3F),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F), Color(0xFF1a3d28)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2D5F3F).withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
     ) );
  }

  Widget _buildSellProducts() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade50,
                    Colors.orange.shade100,
                    Colors.orange.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 12,
                    offset: const Offset(-4, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade200, Colors.orange.shade300],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.storefront, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sell Your Eco Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5F3F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reach out to eco-conscious buyers',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                          Colors.orange.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                        const BoxShadow(
                          color: Colors.white24,
                          blurRadius: 6,
                          offset: Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Upload Your Eco Product',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3d7f5f), Color(0xFF2D5F3F), Color(0xFF1a3d28)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D5F3F).withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-4, -4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_shimmerController.value * 0.2),
                              child: const Icon(Icons.favorite, size: 20),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Support Local Sellers - Shop Green!',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
         ) );
      },
    );
  }
}
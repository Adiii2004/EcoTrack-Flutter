import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  bool _deliveryAvailable = true;

  final List<String> _categories = [
    'Organic Compost',
    'Bio Fertilizer',
    'Eco Products',
    'Seeds',
    'Tools',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background - same as dashboard
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final t = _backgroundController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      -1.0 + math.sin(t * 2 * math.pi) * 0.3,
                      -1.0 + math.cos(t * 2 * math.pi) * 0.3,
                    ),
                    end: Alignment(
                      1.0 - math.sin(t * 2 * math.pi) * 0.3,
                      1.0 - math.cos(t * 2 * math.pi) * 0.3,
                    ),
                    colors: [
                      Color.lerp(
                        const Color(0xFFFFFBEA),
                        const Color(0xFFFFF4E0),
                        math.sin(t * math.pi) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFFFFF8DC),
                        const Color(0xFFFFEFCE),
                        math.cos(t * math.pi * 1.3) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFFFFEECC),
                        const Color(0xFFFFE8BA),
                        math.sin(t * math.pi * 0.7) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFFFFF5E1),
                        const Color(0xFFFFFBEA),
                        math.cos(t * math.pi * 1.7) * 0.5 + 0.5,
                      )!,
                    ],
                    stops: const [0.0, 0.33, 0.66, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating Orbs
          ...List.generate(15, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final t = _backgroundController.value;
                final speed = 0.3 + (index * 0.15);
                final phase = index * 0.628;

                final offsetX = math.sin((t * speed + phase) * 2 * math.pi);
                final offsetY = math.cos(
                  (t * speed * 0.8 + phase * 1.4) * 2 * math.pi,
                );

                final x = size.width * (0.5 + offsetX * 0.45);
                final y = size.height * (0.5 + offsetY * 0.45);

                final orbSize = 80.0 + (index * 25.0);
                final opacity = (0.025 +
                        (0.035 * math.sin((t * 3 + index) * math.pi)))
                    .clamp(0.0, 1.0);

                return Positioned(
                  left: x - orbSize / 2,
                  top: y - orbSize / 2,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: orbSize,
                        height: orbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF66BB6A).withOpacity(0.5),
                              const Color(0xFF66BB6A).withOpacity(0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProductImageSection(),
                                const SizedBox(height: 24),
                                _buildProductNameField(),
                                const SizedBox(height: 20),
                                _buildCategoryDropdown(),
                                const SizedBox(height: 20),
                                _buildPriceStockRow(),
                                const SizedBox(height: 20),
                                _buildDescriptionField(),
                                const SizedBox(height: 24),
                                _buildDeliveryOption(),
                                const SizedBox(height: 30),
                                _buildAddProductButton(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Product',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D32),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'EcoTrack AI',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43A047).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Add Product Photo',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Camera or Gallery',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Name',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _productNameController,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF212121),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Organic Compost',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9E9E9E),
              ),
              prefixIcon: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF757575),
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            hint: Text(
              'Select Category',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9E9E9E),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF757575),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.category_outlined,
                color: Color(0xFF757575),
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items:
                _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStockRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price (₹)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                  decoration: InputDecoration(
                    hintText: '2',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9E9E9E),
                    ),
                    prefixIcon: const Icon(
                      Icons.currency_rupee,
                      color: Color(0xFF757575),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stock Qty',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                  decoration: InputDecoration(
                    hintText: '3',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9E9E9E),
                    ),
                    prefixIcon: const Icon(
                      Icons.inventory_outlined,
                      color: Color(0xFF757575),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 4,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF212121),
            ),
            decoration: InputDecoration(
              hintText: 'Describe your eco-friendly product...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9E9E9E),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(
                  Icons.description_outlined,
                  color: Color(0xFF757575),
                  size: 22,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF2196F3),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available for delivery?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Enable home delivery option',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _deliveryAvailable,
            onChanged: (value) {
              setState(() {
                _deliveryAvailable = value;
              });
            },
            activeThumbColor: const Color(0xFF43A047),
            activeTrackColor: const Color(0xFF81C784),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43A047).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add product logic
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Add Product',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Dashboard', false),
              _buildNavItem(Icons.inventory_2, 'Products', true),
              _buildNavItem(Icons.shopping_bag_outlined, 'Orders', false),
              _buildNavItem(Icons.notifications_outlined, 'Alerts', false),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF43A047) : const Color(0xFF9E9E9E),
          size: isSelected ? 26 : 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected ? const Color(0xFF43A047) : const Color(0xFF9E9E9E),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

import 'dart:ui' show PathMetric, PathMetrics;

import 'package:flutter/material.dart';
import 'dart:math'; // For the rotation calculation

// --- Global Constants for Theming ---
final Color kPrimaryGreen = Colors.green;
final MaterialColor kPrimarySwatch = Colors.green;
const double kCardElevation = 3.0;
const double kBorderRadius = 10.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack Edit Product',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kPrimarySwatch,
        scaffoldBackgroundColor: Color(0xFFF0FFF0), // Very light green background
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
      ),
      home: EditProductScreen(),
    );
  }
}

// --- 1. EditProductScreen (Stateful for Animation and State Management) ---

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> with TickerProviderStateMixin { // Changed to TickerProviderStateMixin for multiple controllers
  // State variables for the inputs
  String productName = 'Organic Compost Bag';
  double price = 299.0;
  int stockQuantity = 25;
  String description = 'Premium quality organic compost made from kitchen waste and garden materials. Rich in nutrients, perfect for home gardening and plant growth. 100% natural and chemical-free.';
  String category = 'Compost';
  bool isAvailableForDelivery = true; // State for the switch

  // Animation controller for screen fade-in
  late AnimationController _screenFadeController;
  late Animation<double> _screenFadeAnimation;

  // Animation controller for the button border beam
  late AnimationController _borderBeamController;
  late Animation<double> _borderBeamAnimation;

  @override
  void initState() {
    super.initState();

    // Setup for initial screen fade-in animation
    _screenFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _screenFadeAnimation = CurvedAnimation(
      parent: _screenFadeController,
      curve: Curves.easeOut,
    );
    _screenFadeController.forward();

    // Setup for border beam animation
    _borderBeamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Speed of the beam
    )..repeat(); // Repeat indefinitely
    
    _borderBeamAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _borderBeamController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _screenFadeController.dispose();
    _borderBeamController.dispose(); // Dispose the new controller
    super.dispose();
  }

  void _saveChanges() {
    // Implement save logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product updated successfully!'),
        backgroundColor: kPrimaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context); // Actual navigation logic
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: kPrimaryGreen),
            onPressed: () {
              // Action for adding/changing product image, e.g., show image picker
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image picker functionality goes here!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      // Use FadeTransition for a smooth entrance animation
      body: FadeTransition(
        opacity: _screenFadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Product Image Section ---
              _buildProductImageCard(context),
              const SizedBox(height: 20),

              // --- Product Name ---
              _buildInputLabel('Product Name'),
              CustomTextField(initialValue: productName, onChanged: (v) => productName = v, isEnabled: true),
              const SizedBox(height: 15),

              // --- Price ---
              _buildInputLabel('Price (₹)'),
              CustomTextField(
                initialValue: price.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => price = double.tryParse(v) ?? price,
                prefixIcon: Text('₹ ', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              ),
              const SizedBox(height: 15),

              // --- Stock Quantity ---
              _buildInputLabel('Stock Quantity'),
              CustomTextField(
                initialValue: stockQuantity.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => stockQuantity = int.tryParse(v) ?? stockQuantity,
              ),
              const SizedBox(height: 15),

              // --- Description ---
              _buildInputLabel('Description'),
              CustomTextField(
                initialValue: description,
                maxLines: 5,
                onChanged: (v) => description = v,
              ),
              const SizedBox(height: 15),

              // --- Category Dropdown ---
              _buildInputLabel('Category'),
              _buildCategoryDropdown(),
              const SizedBox(height: 15),

              // --- Available for Delivery Toggle (Animated Widget) ---
              _buildDeliveryToggle(),
              const SizedBox(height: 30),

              // --- Save Changes Button with Glossy Effect and Running Border Beam ---
              AnimatedBuilder(
                animation: _borderBeamAnimation,
                builder: (context, child) {
                  return Container(
                    height: 50, // Fixed height for the button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      // Inner glossy effect gradient
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
    (kPrimaryGreen as MaterialColor).shade300, // FIX applied here
    (kPrimaryGreen as MaterialColor).shade700, // FIX applied here
    (kPrimaryGreen as MaterialColor).shade900, // FIX applied here
  ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryGreen.withOpacity(0.4),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      // Running border beam effect
                      border: Border.all(
                        color: Colors.transparent, // Invisible base border
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent, // Make Material transparent to show Container's decoration
                      child: InkWell(
                        onTap: _saveChanges,
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        child: CustomPaint(
                          painter: _BorderBeamPainter(animationValue: _borderBeamAnimation.value, buttonColor: kPrimaryGreen),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              // --- Cancel Button ---
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Simulate cancel/back
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  side: BorderSide(color: Colors.grey[300]!, width: 1),
                  backgroundColor: Colors.white,
                ),
                child: Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              ),
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
      
      // Bottom navigation bar from the original design
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- Helper Widgets ---

  Widget _buildProductImageCard(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://5.imimg.com/data5/RR/RR/GLADMIN-/data4-ro-fd-my-4839144-light-cees-jute-bag-500x500-250x250.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonFormField<String>(
        initialValue: category,
        decoration: InputDecoration(
          border: InputBorder.none, // Removes the default underline
          isDense: true,
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: kPrimaryGreen),
        style: TextStyle(color: Colors.black, fontSize: 16),
        items: <String>['Compost', 'Fertilizer', 'Seeds', 'Tools']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            category = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildDeliveryToggle() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          'Available for Delivery',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        subtitle: Text('Enable home delivery option', style: TextStyle(color: Colors.grey[600])),
        value: isAvailableForDelivery,
        onChanged: (bool value) {
          setState(() {
            isAvailableForDelivery = value;
          });
        },
        activeThumbColor: kPrimaryGreen,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryGreen,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      currentIndex: 1, // 'Products' is the current page
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet_travel), label: 'Wallet'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// --- Custom Painter for the Running Border Beam ---
class _BorderBeamPainter extends CustomPainter {
  final double animationValue; // 0.0 to 1.0
  final Color buttonColor;

  _BorderBeamPainter({required this.animationValue, required this.buttonColor});

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(kBorderRadius),
    );

    // Define the gradient for the beam
    final beamGradient = LinearGradient(
      colors: [
        Colors.transparent,
        buttonColor.withOpacity(0.8), // Visible part of the beam
        Colors.transparent,
      ],
      stops: [0.0, 0.5, 1.0], // Position the visible part in the middle
    );

    // Create a shader with the gradient
    final Shader shader = beamGradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    // Path for the border
    final Path borderPath = Path()
      ..addRRect(rrect);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 // Thickness of the beam
      ..shader = shader;

    // Calculate the start position of the beam along the border path
    // The animationValue controls where the beam is.
    // We'll create a "moving window" for the gradient
    final PathMetrics pathMetrics = borderPath.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final double totalLength = pathMetric.length;
      final double segmentLength = totalLength * 0.2; // The length of the visible beam segment
      
      // Calculate start and end tangents for the beam based on animationValue
      final double startFraction = (animationValue * totalLength - segmentLength / 2) / totalLength;
      final double endFraction = (animationValue * totalLength + segmentLength / 2) / totalLength;

      // Ensure fractions wrap around correctly for seamless looping
      final Path extractPath = pathMetric.extractPath(
        totalLength * (startFraction < 0 ? startFraction + 1 : startFraction),
        totalLength * (endFraction > 1 ? endFraction - 1 : endFraction),
      );
      
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// --- Custom Reusable Text Field Widget (for consistent styling) ---

class CustomTextField extends StatelessWidget {
  final String initialValue;
  final int? maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final bool isEnabled;

  const CustomTextField({super.key, 
    required this.initialValue,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: isEnabled,
      style: TextStyle(color: isEnabled ? Colors.black : Colors.grey[600]),
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: prefixIcon != null ? Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 4.0),
          child: prefixIcon,
        ) : null,
      ),
    );
  }
}
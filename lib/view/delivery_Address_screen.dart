import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'order_summary.dart'; 

// --- ENUM (UNMODIFIED) ---
enum AddressType { home, office, other }

// --- SCREEN WIDGET (UNMODIFIED FUNCTIONALITY) ---
class DeliveryAddressScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double totalPrice;
  final int quantity;
  final double basePrice;

  const DeliveryAddressScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.totalPrice,
    required this.quantity,
    required this.basePrice,
  });

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _houseController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  // Correction: Ensure correct type declaration for TextEditingController
  final _pincodeController = TextEditingController(); 
  final _stateController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _saveAddress = false;
  AddressType _selectedAddressType = AddressType.home;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryScreen(
            productName: widget.productName,
            productImage: widget.productImage,
            totalPrice: widget.totalPrice,
            quantity: widget.quantity,
            basePrice: widget.basePrice,
            customerName: _nameController.text,
            customerMobile: _mobileController.text,
            deliveryAddress:
                '${_houseController.text}, ${_streetController.text}, ${_cityController.text}, ${_stateController.text} - ${_pincodeController.text}',
            addressType: _selectedAddressType,
            deliveryInstructions: _instructionsController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Changed background to transparent to let the Stack's background show through
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _buildContinueButton(),
      body: Stack(
        children: [
          // Background: Animated Bubbles + Subtle Gradient
          const AnimatedBubbleBackground(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.green.shade50.withOpacity(0.2),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Where should we deliver your eco product?',
                      style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildOrderSummaryCard(),
                  const SizedBox(height: 20),
                  _buildAddressFormCard(),
                  const SizedBox(height: 20),
                  _buildAddressTypeCard(),
                  const SizedBox(height: 20),
                  _buildInstructionsCard(),
                  const SizedBox(height: 40), // Extra space for bottom button clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS (REFINED GLOSSINESS) ---

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Increased blur
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // Frosted glass effect
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 26, // Slightly larger
            fontWeight: FontWeight.w900, // Thicker font weight
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard() {
    return _buildGlassyCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.productImage,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    'Qty: ${widget.quantity} • ₹${widget.totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.receipt_long, color: Colors.green, size: 28),
        ],
      ),
    );
  }

  Widget _buildAddressFormCard() {
    return _buildGlassyCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildSectionTitle('Contact Details'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _nameController,
              hintText: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _mobileController,
              hintText: 'Mobile Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter mobile number';
                if (value.length != 10) return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Address Details'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _houseController,
              hintText: 'House / Building Number',
              icon: Icons.home_outlined,
              validator: (value) => value!.isEmpty ? 'Please enter house/building number' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _streetController,
              hintText: 'Street / Area / Locality',
              icon: Icons.location_on_outlined,
              validator: (value) => value!.isEmpty ? 'Please enter your locality' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    hintText: 'City',
                    icon: Icons.location_city_outlined,
                    validator: (value) => value!.isEmpty ? 'Enter city' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _pincodeController,
                    hintText: 'Pincode',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter pincode';
                      if (value.length != 6) return 'Enter valid 6-digit pincode';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _stateController,
              hintText: 'State',
              icon: Icons.flag_outlined,
              validator: (value) => value!.isEmpty ? 'Please enter your state' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.black54, // Unselected border color
                  ),
                  child: Checkbox(
                    value: _saveAddress,
                    onChanged: (value) => setState(() => _saveAddress = value!),
                    activeColor: Colors.green, // Selected color
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const Text(
                  'Save this address for future orders',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeCard() {
    return _buildGlassyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Address Type'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAddressTypeButton(
                  type: AddressType.home,
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAddressTypeButton(
                  type: AddressType.office,
                  icon: Icons.work_rounded,
                  label: 'Office',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAddressTypeButton(
                  type: AddressType.other,
                  icon: Icons.location_pin,
                  label: 'Other',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTypeButton({
    required AddressType type,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = _selectedAddressType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddressType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.white.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.green.shade700 : Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.green.shade800 : Colors.black54,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return _buildGlassyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Delivery Instructions (Optional)'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _instructionsController,
            hintText: 'e.g., Ring the bell twice, Leave at the door, etc.',
            maxLines: 3,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85), // Solid white on top of blur
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF388E3C).withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: const Color(0xFF388E3C), // Dark green color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Order Summary',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Master Glassy Card Container
  Widget _buildGlassyCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Slightly larger radius
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Increased blur for stronger effect
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4), // More transparency
            borderRadius: BorderRadius.circular(20),
            // Glossy border effect
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  TextFormField _buildTextField({
    // Correction: Ensure correct type declaration here
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      cursorColor: Colors.green.shade700,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.green.shade700) : null, // Green icons
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        fillColor: Colors.white.withOpacity(0.85), // More opaque fill for contrast
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none, // Removed default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.7), width: 1.5), // Lighter, glossy border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2.5), // Solid green focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
    );
  }
}

// --- ANIMATED BACKGROUND WIDGET (REFINED COLORS/OPACITY) ---

class AnimatedBubbleBackground extends StatefulWidget {
  const AnimatedBubbleBackground({super.key});

  @override
  State<AnimatedBubbleBackground> createState() => _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;
  final Random _random = Random();
  final int _numberOfBubbles = 30; // Increased number of bubbles

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Slower animation
    )..repeat();

    _bubbles = List.generate(_numberOfBubbles, (index) => Bubble(random: _random));

    _controller.addListener(() {
      setState(() {
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
    return Container(
      color: Colors.white, // Base white color
      child: Stack(
        children: [
          ..._bubbles.map((bubble) => Positioned(
              left: bubble.x * MediaQuery.of(context).size.width,
              top: bubble.y * MediaQuery.of(context).size.height,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: bubble.opacity,
                child: Transform.scale(
                  scale: bubble.size,
                  child: Container(
                    width: 1, // Base size is 1, scaled by bubble.size
                    height: 1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          bubble.color.withOpacity(0.5), // Higher base opacity
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }
}

class Bubble {
  final Random random;
  late double x;
  late double y;
  late double initialSize;
  late double size;
  late double opacity;
  late double speedY;
  late double swayMagnitude;
  late double swayFrequency;
  late double animationOffset;
  late Color color;
  final double initialY;

  Bubble({required this.random}) : initialY = random.nextDouble() + 1.0 {
    _reset(isFirstTime: true);
  }

  void _reset({bool isFirstTime = false}) {
    y = isFirstTime ? initialY : 1.1;
    x = random.nextDouble();
    initialSize = random.nextDouble() * 40 + 30; // Increased max size
    size = 1.0;
    opacity = 0.0;
    speedY = random.nextDouble() * 0.0005 + 0.0002; // Slower speed
    swayMagnitude = random.nextDouble() * 0.0008; // Less sway
    swayFrequency = random.nextDouble() * 4 + 2;
    animationOffset = random.nextDouble() * pi * 2;
    color = _getRandomBubbleColor();
  }

  Color _getRandomBubbleColor() {
    // Brighter, softer colors for a glossy background effect
    final colors = [
      Colors.green.shade200,
      Colors.teal.shade200,
      Colors.lightBlue.shade100,
      Colors.lime.shade200,
    ];
    return colors[random.nextInt(colors.length)];
  }

  void update(double controllerValue) {
    y -= speedY;
    x += sin((y * swayFrequency) + animationOffset) * swayMagnitude;
    double animationProgress = (sin((controllerValue * pi * 2) + animationOffset) + 1) / 2;
    // Scale by the actual size (size is the multiplier)
    size = initialSize * (0.8 + (animationProgress * 0.4));

    if (y < 0.1) {
      // Fade out at the top
      opacity = (y / 0.1).clamp(0.0, 1.0) * 0.3;
    } else if (y > 0.9) {
      // Fade in at the bottom
      opacity = ((1.0 - y) / 0.1).clamp(0.0, 1.0) * 0.3;
    } else {
      // Maintain base opacity
      opacity = 0.3;
    }
    if (y < -0.2) {
      _reset();
    }
  }
}
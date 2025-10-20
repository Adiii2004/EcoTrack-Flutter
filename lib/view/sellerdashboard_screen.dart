import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'addnewproduct_screen.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Main content animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Background gradient animation - continuous
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    // Particle animation - continuous
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // HD Animated Gradient Background
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

          // Large Floating Orbs
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final t = _backgroundController.value;
                final speed = 0.3 + (index * 0.15);
                final phase = index * 0.628; // 2*pi/10

                final offsetX = math.sin((t * speed + phase) * 2 * math.pi);
                final offsetY = math.cos(
                  (t * speed * 0.8 + phase * 1.4) * 2 * math.pi,
                );

                final x = size.width * (0.5 + offsetX * 0.45);
                final y = size.height * (0.5 + offsetY * 0.45);

                final orbSize = 80.0 + (index * 30.0);
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
                              (index % 3 == 0
                                      ? const Color(0xFF66BB6A)
                                      : index % 3 == 1
                                      ? const Color(0xFF81C784)
                                      : const Color(0xFF4CAF50))
                                  .withOpacity(0.5),
                              (index % 3 == 0
                                      ? const Color(0xFF66BB6A)
                                      : index % 3 == 1
                                      ? const Color(0xFF81C784)
                                      : const Color(0xFF4CAF50))
                                  .withOpacity(0.2),
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

          // Small Floating Particles
          ...List.generate(50, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final t = _particleController.value;
                final speed = 0.15 + (index * 0.05);
                final phase = index * 0.251; // Random phase

                final x = size.width * ((t * speed + phase) % 1.0);
                final y =
                    size.height * ((t * speed * 1.3 + phase * 0.7) % 1.0) +
                    math.sin((t * speed * 4 + phase) * 2 * math.pi) * 30;

                final particleSize = 9.0 + (index % 4);
                final opacity = (0.15 +
                        (0.15 * math.sin((t * 2 + index * 0.3) * math.pi)))
                    .clamp(0.0, 1.0);

                return Positioned(
                  left: x,
                  top: y,
                  child: IgnorePointer(
                    child: Container(
                      width: particleSize,
                      height: particleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                          0xFF66BB6A,
                        ).withOpacity(opacity * 0.6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF66BB6A,
                            ).withOpacity(opacity * 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Shimmer Effect Overlay
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final t = _backgroundController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + t * 3, -1.0),
                    end: Alignment(1.0 + t * 3, 1.0),
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.03),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
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
                                  _buildOverviewSection(),
                                  const SizedBox(height: 24),
                                  _buildManageProductsCard(),
                                  const SizedBox(height: 20),
                                  _buildViewAllProductsCard(),
                                  const SizedBox(height: 20),
                                  _buildOrdersEarningsCard(),
                                  const SizedBox(height: 24),
                                  _buildRecentOrdersSection(),
                                  const SizedBox(height: 20),
                                  _buildSwitchModeButton(),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'EcoTrack AI',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E7D32),
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined, size: 22),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF5350),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seller Overview',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF212121),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Products',
                '24',
                Icons.inventory_2_outlined,
                const Color(0xFF2196F3),
                [const Color(0xFF1976D2), const Color(0xFF42A5F5)],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                'Active Orders',
                '8',
                Icons.shopping_bag_outlined,
                const Color(0xFFFF9800),
                [const Color(0xFFF57C00), const Color(0xFFFFB74D)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Earnings',
                '₹2,450',
                Icons.account_balance_wallet_outlined,
                const Color(0xFF4CAF50),
                [const Color(0xFF388E3C), const Color(0xFF66BB6A)],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                'Pending',
                '3',
                Icons.hourglass_empty_outlined,
                const Color(0xFF9C27B0),
                [const Color(0xFF7B1FA2), const Color(0xFFBA68C8)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    List<Color> gradient,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        // FIX: Clamp the animation value to ensure it's strictly within [0.0, 1.0]
        final safeOpacity = animValue.clamp(0.0, 1.0);

        return Transform.scale(
          scale: 0.85 + (0.15 * animValue),
          child: Opacity(
            opacity: safeOpacity, // Using the clamped value
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF757575),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF212121),
                      letterSpacing: 0.5,
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

  Widget _buildManageProductsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Products',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF212121),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return AddNewProductScreen();
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Product',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'List compost or eco items',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllProductsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.inventory_outlined,
              color: Color(0xFF2196F3),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View All Products',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your listings',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF2196F3),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF9800).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.trending_up,
              color: Color(0xFFFF9800),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders & Earnings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your sales',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFFF9800),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF43A047).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF43A047),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          'Priya Sharma',
          'Organic Compost × 2',
          '₹450',
          'Oct 5, 2025',
          'Completed',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 12),
        _buildOrderCard(
          'Raj Patel',
          'Bio fertilizer × 1',
          '₹280',
          'Oct 7, 2025',
          'Pending',
          const Color(0xFFFF9800),
        ),
        const SizedBox(height: 12),
        _buildOrderCard(
          'Anita Desai',
          'Eco fertilizer × 3',
          '₹750',
          'Oct 6, 2025',
          'Shipped',
          const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildOrderCard(
    String name,
    String item,
    String price,
    String date,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withOpacity(0.15),
                  statusColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.eco_outlined, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBDBDBD),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.15),
                  statusColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchModeButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF43A047), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43A047).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF43A047).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.swap_horiz,
              color: Color(0xFF43A047),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Switch to Citizen Mode',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF43A047),
              letterSpacing: 0.5,
            ),
          ),
        ],
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
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(
                Icons.inventory_2_outlined,
                Icons.inventory_2,
                'Products',
                1,
              ),
              _buildNavItem(
                Icons.shopping_bag_outlined,
                Icons.shopping_bag,
                'Orders',
                2,
              ),
              _buildNavItem(
                Icons.notifications_outlined,
                Icons.notifications,
                'Alerts',
                3,
              ),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              switch (index) {
                case 0:
                  return const SellerDashboard();
                //case 1:
                // return const MyProductsScreen();
                // case 2:
                //   return const OrdersScreen();
                // case 3:
                //   return const NotificationScreen();
                // case 4:
                //   return const SellerProfileScreen();
                default:
                  return const SellerDashboard();
              }
            },
          ),
        );
        setState(() {
          _selectedIndex = index;
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 + (value * 4),
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.transparent,
                const Color(0xFF43A047).withOpacity(0.12),
                value,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? filledIcon : outlinedIcon,
                  color: Color.lerp(
                    const Color(0xFF9E9E9E),
                    const Color(0xFF43A047),
                    value,
                  ),
                  size: 24 + (value * 2),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Color.lerp(
                      const Color(0xFF9E9E9E),
                      const Color(0xFF43A047),
                      value,
                    ),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

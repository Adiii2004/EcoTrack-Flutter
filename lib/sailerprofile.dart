import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Temp data - replace with Firebase data later
  final String userName = "Raj Patel";
  final String userRole = "EcoGreen Solutions";
  final String sellerSince = "Seller since Oct 2024";
  final String email = "raj.patel@ecogreen.com";
  final String phone = "+91 98765 43210";
  final String address = "123 Green Street, Eco City, Maharashtra 400001";
  final String upiId = "raj@paytm";
  final String bankAccount = "****2468";
  final String sellerId = "ECO-S-2024-1247";
  final double walletBalance = 12450.0;
  final double profileCompletion = 0.85;
  bool notificationsEnabled = true;
  bool darkThemeEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.white,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      _buildProfileCompletion(),
                      const SizedBox(height: 20),
                      _buildContactInfo(),
                      const SizedBox(height: 20),
                      _buildWalletCard(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                      _buildBottomNav(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.pink.shade400],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200,
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade200.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade300,
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child:                       const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  userRole,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 5),
                    Text(
                      sellerSince,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCompletion() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile Completion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${(profileCompletion * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1500),
            tween: Tween<double>(begin: 0, end: profileCompletion),
            builder: (context, double value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildGlassInfoTile(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: email,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildGlassInfoTile(
          icon: Icons.phone_outlined,
          title: 'Phone Number',
          subtitle: phone,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildGlassInfoTile(
          icon: Icons.location_on_outlined,
          title: 'Address',
          subtitle: address,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildGlassInfoTile(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Bank Details',
          subtitle: 'UPI: $upiId • Bank: $bankAccount',
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildGlassInfoTile(
          icon: Icons.badge_outlined,
          title: 'Seller ID',
          subtitle: sellerId,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildGlassInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade400.withOpacity(0.3),
                Colors.pink.shade400.withOpacity(0.3),
                Colors.orange.shade400.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.pink.shade200.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade300.withOpacity(0.6),
                      Colors.pink.shade300.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade300.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade300.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallet Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 1500),
                    tween: Tween<double>(begin: 0, end: walletBalance),
                    builder: (context, double value, child) {
                      return Text(
                        '₹${value.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Withdraw',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'View Transactions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push notifications',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              activeThumbColor: Colors.green.shade600,
            ),
          ),
          const Divider(height: 30),
          _buildSettingTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
          const Divider(height: 30),
          _buildSettingTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Light mode',
            trailing: Switch(
              value: darkThemeEnabled,
              onChanged: (value) {
                setState(() {
                  darkThemeEnabled = value;
                });
              },
              activeThumbColor: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.green.shade700, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildAnimatedEditButton(),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Switch to Citizen Mode',
          color: Colors.white,
          textColor: Colors.green.shade700,
          icon: Icons.refresh,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAnimatedEditButton() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 2000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 1.0 + (0.05 * (value < 0.5 ? value * 2 : (1 - value) * 2)),
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade600,
                    Colors.pink.shade500,
                    Colors.orange.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade300.withOpacity(0.6),
                    blurRadius: 15 + (10 * value),
                    offset: const Offset(0, 4),
                    spreadRadius: 2 * value,
                  ),
                  BoxShadow(
                    color: Colors.pink.shade300.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated shine effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Transform.translate(
                        offset: Offset(300 * value - 150, 0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20 + (2 * value),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Edit Profile Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildActionButton({
    required String label,
    required Color color,
    Color? textColor,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: color == Colors.white
              ? Border.all(color: Colors.green.shade600, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: color == Colors.white
                  ? Colors.green.shade100
                  : Colors.green.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', false),
          _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false),
          _buildNavItem(Icons.list_alt_outlined, 'Orders', false),
          _buildNavItem(Icons.person, 'Profile', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.green.shade600 : Colors.grey.shade400,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.green.shade600 : Colors.grey.shade400,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
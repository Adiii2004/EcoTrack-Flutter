import 'package:ecotrack/view/forgot_password_screen.dart';
import 'package:ecotrack/view/signup_screen.dart';
import 'package:ecotrack/view/userhome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State with TickerProviderStateMixin {
  bool notShowPass = true;
  int selectedRoleIndex = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> roles = [
    {
      'name': 'Citizen',
      'icon': Icons.person_outline,
      'color': Color(0xFF43A047),
      'gradient': [Color(0xFF2E7D32), Color(0xFF43A047), Color(0xFF66BB6A)],
    },
    {
      'name': 'Worker',
      'icon': Icons.engineering_outlined,
      'color': Color(0xFF1976D2),
      'gradient': [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF42A5F5)],
    },
    {
      'name': 'Admin',
      'icon': Icons.admin_panel_settings_outlined,
      'color': Color(0xFFE53935),
      'gradient': [Color(0xFFD32F2F), Color(0xFFE53935), Color(0xFFEF5350)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  Widget _buildRoleSlider() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                (MediaQuery.of(context).size.width - 120) /
                    3 *
                    selectedRoleIndex +
                4,
            top: 4,
            child: Container(
              width: (MediaQuery.of(context).size.width - 80) / 3 - 8,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: roles[selectedRoleIndex]['gradient'],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: roles[selectedRoleIndex]['color'].withOpacity(0.4),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: List.generate(roles.length, (index) {
              bool isSelected = selectedRoleIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoleIndex = index;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          roles[index]['icon'],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          roles[index]['name'],
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // Logo
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 110,
                          width: 110,
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10),
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset("assets/svg/AppLogo.svg"),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // App Name
                      ShaderMask(
                        shaderCallback:
                            (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF1B5E20),
                                Color(0xFF2E7D32),
                                Color(0xFF43A047),
                              ],
                            ).createShader(bounds),
                        child: Text(
                          "EcoTrack AI",
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Track Your Carbon Footprint",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF424242),
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Main Login Card
                      Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Colors.black.withOpacity(0.08),
                              offset: const Offset(0, 12),
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B5E20),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Sign in to continue your journey",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF757575),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Role Slider
                            _buildRoleSlider(),

                            const SizedBox(height: 24),

                            // Email TextField
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Colors.black.withOpacity(0.04),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8F9FA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF43A047),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "Enter Your Email",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF43A047),
                                      size: 20,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Password TextField
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Colors.black.withOpacity(0.04),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: notShowPass,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8F9FA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF43A047),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "Enter Your Password",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF43A047),
                                      size: 20,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      notShowPass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        notShowPass = !notShowPass;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Sign In Button
                            Container(
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: roles[selectedRoleIndex]['gradient'],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12,
                                    color: roles[selectedRoleIndex]['color']
                                        .withOpacity(0.4),
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    //  UserhomeScreen navigation
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserhomeScreen(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Center(
                                    child: Text(
                                      "Sign In",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Forgot Password
                            GestureDetector(
                              onTap: () {
                                // Your ForgotPassword navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF43A047),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Create Account Button
                            Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: roles[selectedRoleIndex]['color'],
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Colors.black.withOpacity(0.04),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Your SignupScreen navigation
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Center(
                                    child: Text(
                                      "Create Account",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            roles[selectedRoleIndex]['color'],
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
                    children: [
                      const SizedBox(height: 60),

                      // Logo with animation
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 120,
                          width: 120,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10),
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset("assets/svg/AppLogo.svg"),
                        ),
                      ),

                      const SizedBox(height: 30),

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
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Title
                      Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B5E20),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        "Don't worry! It happens. Please enter\nyour registered email to reset password",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF424242),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Main Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Colors.black.withOpacity(0.08),
                              offset: const Offset(0, 15),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Info Banner
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE3F2FD),
                                    Color(0xFFBBDEFB),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF2196F3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2196F3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "We will send you a password reset link on your email.",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1976D2),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Email TextField
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.05),
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF43A047),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "Enter your email",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF43A047),
                                      size: 24,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Send Reset Link Button
                            Container(
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2E7D32),
                                    Color(0xFF43A047),
                                    Color(0xFF66BB6A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: const Color(
                                      0xFF43A047,
                                    ).withOpacity(0.4),
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Add your send reset link logic
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.send_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "Send Reset Link",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
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
                            ),

                            const SizedBox(height: 24),

                            // Back to Login
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF43A047),
                                size: 22,
                              ),
                              label: Text(
                                "Back to Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF43A047),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Bottom Help Text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFF43A047),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Need help? Contact support",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF424242),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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
    _animationController.dispose();
    super.dispose();
  }
}

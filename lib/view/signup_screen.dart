import 'package:ecotrack/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State createState() => _SignupScreenState();
}

class _SignupScreenState extends State with SingleTickerProviderStateMixin {
  bool notShowPass = true;
  bool notShowConfirmPass = true;
  bool isAgreeTermsAndPrivacy = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${icon.toString().split('.').last} login attempted",
                ),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Center(child: FaIcon(icon, color: color, size: 24)),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText:
            isPassword
                ? notShowPass
                : isConfirmPassword
                ? notShowConfirmPass
                : false,
        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF43A047), width: 2),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: const Color(0xFF43A047), size: 22),
          ),
          suffixIcon:
              (isPassword || isConfirmPassword)
                  ? IconButton(
                    icon: Icon(
                      (isPassword ? notShowPass : notShowConfirmPass)
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPassword) {
                          notShowPass = !notShowPass;
                        } else {
                          notShowConfirmPass = !notShowConfirmPass;
                        }
                      });
                    },
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
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
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
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
                      const SizedBox(height: 40),

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
                                Color(0xFF00695C),
                                Color(0xFF00897B),
                                Color(0xFF26A69A),
                              ],
                            ).createShader(bounds),
                        child: Text(
                          "EcoTrack AI",
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Create Account",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00695C),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Join us in building a greener future",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF424242),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Main Form Card
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
                            _buildTextField(
                              controller: _nameController,
                              hint: "Full Name",
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                            ),

                            const SizedBox(height: 18),

                            _buildTextField(
                              controller: _emailController,
                              hint: "Email Address",
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 18),

                            _buildTextField(
                              controller: _phoneController,
                              hint: "Mobile Number",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 18),

                            _buildTextField(
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),

                            const SizedBox(height: 18),

                            _buildTextField(
                              controller: _confirmPasswordController,
                              hint: "Confirm Password",
                              icon: Icons.lock_outline,
                              isConfirmPassword: true,
                            ),

                            const SizedBox(height: 12),

                            // Terms & Privacy Checkbox
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.1,
                                  child: Checkbox(
                                    value: isAgreeTermsAndPrivacy,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isAgreeTermsAndPrivacy = newValue!;
                                      });
                                    },
                                    activeColor: const Color(0xFF00897B),
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "I agree to ",
                                          style: GoogleFonts.inter(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Terms",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00897B),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " & ",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Privacy",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00897B),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Sign Up Button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00695C),
                                    Color(0xFF00897B),
                                    Color(0xFF26A69A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: const Color(
                                      0xFF00897B,
                                    ).withOpacity(0.4),
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Add signup logic

                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginScreen();
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "Or Sign Up With",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1.5,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Social Icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialIcon(
                                  FontAwesomeIcons.google,
                                  const Color(0xFFDB4437),
                                ),
                                _buildSocialIcon(
                                  FontAwesomeIcons.facebookF,
                                  const Color(0xFF4267B2),
                                ),
                                _buildSocialIcon(
                                  FontAwesomeIcons.twitter,
                                  const Color(0xFF1DA1F2),
                                ),
                                _buildSocialIcon(
                                  FontAwesomeIcons.apple,
                                  const Color(0xFF000000),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Already have account
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00897B),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

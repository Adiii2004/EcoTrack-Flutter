import 'package:ecotrack/view/login_screen.dart';
import 'package:ecotrack/view/wasteadvisor_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// आवश्यक इम्पोर्ट जोडा
import 'package:ecotrack/view/complaint_screen.dart';

class UserdashboardDrawer extends StatefulWidget {
  const UserdashboardDrawer({super.key});
  @override
  State createState() {
    return _UserdashboardDrawerState();
  }
}

class _UserdashboardDrawerState extends State<UserdashboardDrawer> {
  String selectedMenu = 'Dashboard';

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': FontAwesomeIcons.home},
    {'title': 'File Complaint', 'icon': FontAwesomeIcons.filePen},
    {'title': 'Carbon Calculator', 'icon': FontAwesomeIcons.calculator},
    {'title': 'Waste Advisor', 'icon': FontAwesomeIcons.recycle},
    {'title': 'Eco Report Card', 'icon': FontAwesomeIcons.chartLine},
    {'title': 'Gamification', 'icon': FontAwesomeIcons.trophy},
    {'title': 'Reminder', 'icon': FontAwesomeIcons.solidBell},
    {'title': 'EcoMate Chatbot', 'icon': FontAwesomeIcons.robot},
    {'title': 'Setting', 'icon': FontAwesomeIcons.gear},
    {'title': 'About Us', 'icon': FontAwesomeIcons.circleInfo},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8F4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Compact User Profile Section
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                left: 15,
                right: 15,
                bottom: 15,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF2E7D32),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome back!",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "User Name",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                children: [
                  ...menuItems.map(
                    (item) => _buildMenuItem(
                      title: item['title'],
                      icon: item['icon'],
                      isSelected: selectedMenu == item['title'],
                      onTap: () {
                        // नेव्हिगेशन लॉजिक जोडले
                        Navigator.pop(context); // drawer बंद करा
                        if (item['title'] == 'File Complaint') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ComplaintScreen(),
                            ),
                          );
                        } else if (item['title'] == 'Waste Advisor') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const WasteDisposalApp(), // Placeholder, replace with actual Waste Advisor screen
                            ),
                          );
                          {
                            setState(() {
                              selectedMenu = item['title'];
                            });
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(thickness: 1, color: Color(0xFFBDBDBD)),
                  const SizedBox(height: 10),

                  // Logout Button
                  _buildLogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? const LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FaIcon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    color: isSelected ? Colors.white : const Color(0xFF424242),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.chevron_right, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE57373), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE57373).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                size: 16,
                color: Color(0xFFC62828),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Logout",
              style: GoogleFonts.inter(
                fontSize: 14.5,
                color: const Color(0xFFC62828),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

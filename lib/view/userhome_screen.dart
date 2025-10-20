import 'package:ecotrack/view/complaint_screen.dart';
import 'package:ecotrack/view/mycomplaint_screen.dart';
import 'package:ecotrack/view/sellerdashboard_screen.dart';
import 'package:ecotrack/view/userdashboard_drawer.dart';
import 'package:ecotrack/view/wasteadvisor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'marketplace.dart';

class UserhomeScreen extends StatefulWidget {
  const UserhomeScreen({super.key});
  @override
  State createState() => _UserhomeScreenState();
}

class _UserhomeScreenState extends State {
  String username = "Kunal";

  Widget makeWeatherCard({
    required String title,
    required String value,
    required String info,
    required IconData icon,
    required Color statusColor,
    double size = 18,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor, statusColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: FaIcon(icon, color: Colors.white, size: size),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              info,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeQuickActionCard({
    required IconData icon,
    required Color iconColor,
    required String actionTitle,
    required String info,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (actionTitle == "File Complaint") {
                return ComplaintScreen();
              } else if (actionTitle == "My Complaints") {
                return MyComplaintsScreen();
              } else if (actionTitle == "Carbon Calculator") {
                return ComplaintScreen();
              } else if (actionTitle == "Waste Advisor") {
                return WasteDisposalApp();
              } else if (actionTitle == "Buy Eco Products") {
                return EcoMarketplaceScreen(); // create this screen separately
              } else if (actionTitle == "Sell Eco Products") {
                return SellerDashboard(); // seller panel
              } else {
                return ComplaintScreen();
              }
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [iconColor, iconColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FaIcon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              actionTitle,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              info,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('MMMM d, yyyy').format(now);
    String time = DateFormat('h:mm a').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 36,
              width: 36,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                "assets/svg/AppLogo.svg",
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "EcoTrack AI",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFB74D), width: 1),
            ),
            child: const Icon(
              Icons.notifications,
              size: 22,
              color: Color(0xFFF57C00),
            ),
          ),
        ],
      ),
      drawer: const UserdashboardDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $username 👋",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$date at $time",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Weather Cards Grid
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
                children: [
                  makeWeatherCard(
                    title: "AQI",
                    value: "42",
                    info: "Good",
                    statusColor: const Color(0xFF4CAF50),
                    icon: FontAwesomeIcons.wind,
                  ),
                  makeWeatherCard(
                    title: "Temperature",
                    value: "24°C",
                    info: "Feels 26°C",
                    statusColor: const Color(0xFFFF9800),
                    icon: FontAwesomeIcons.temperatureHalf,
                    size: 22,
                  ),
                  makeWeatherCard(
                    title: "Humidity",
                    value: "65%",
                    info: "Normal",
                    statusColor: const Color(0xFF2196F3),
                    icon: FontAwesomeIcons.droplet,
                  ),
                  makeWeatherCard(
                    title: "CO2 Level",
                    value: "380",
                    info: "Low",
                    statusColor: const Color(0xFF757575),
                    icon: FontAwesomeIcons.smog,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Today's Weather Card
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Weather",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Partly Cloudy",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.cloudSun,
                            color: Color(0xFFFF9800),
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "UV Index: 6",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE53935),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Quick Actions Header
              Text(
                "Quick Actions",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Quick Actions Grid
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
                children: [
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.triangleExclamation,
                    iconColor: const Color(0xFFE53935),
                    actionTitle: "File Complaint",
                    info: "Report environmental issues",
                  ),
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.filePen,
                    iconColor: const Color(0xFF2196F3),
                    actionTitle: "My Complaints",
                    info: "Track your reports",
                  ),
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.calculator,
                    iconColor: const Color(0xFF4CAF50),
                    actionTitle: "Carbon Calculator",
                    info: "Calculate your footprint",
                  ),
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.recycle,
                    iconColor: const Color(0xFFFF9800),
                    actionTitle: "Waste Advisor",
                    info: "Smart waste management",
                  ),
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.shoppingBag,
                    iconColor: const Color(0xFF81C784),
                    actionTitle: "Buy Eco Products",
                    info: "Explore compost & green items",
                  ),
                  makeQuickActionCard(
                    icon: FontAwesomeIcons.store,
                    iconColor: const Color(0xFFFFB74D),
                    actionTitle: "Sell Eco Products",
                    info: "List your eco-friendly products",
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

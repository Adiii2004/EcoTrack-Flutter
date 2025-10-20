import 'package:flutter/material.dart';
import '../worker_notification.dart';
import 'tast_details.dart';
//import 'worker_notification.dart';
import 'package:intl/intl.dart';

// Import the required packages for the TaskDetailsScreen (even if simplified below)
import 'package:google_fonts/google_fonts.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

// =========================================================================
// 1. DATA MODELS & DUMMY DATA (No change to content, minor added details for demo)
// =========================================================================

class Task {
  final String id;
  final String title;
  final String location;
  final String status;
  final DateTime dateTime;
  final String imageUrl;
  final Color statusColor;
  final Color statusTextColor;
  // Added detail fields for the details screen to use
  final String description;
  final String assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.dateTime,
    required this.imageUrl,
    required this.statusColor,
    required this.statusTextColor,
    this.description = 'Garbage has been accumulating for 3 days. Waste bins are overflowing and creating unhygienic conditions in the area. Immediate collection required.',
    this.assignedTo = 'Rohit Kumar',
  });
}

class UserProfile {
  final String name;
  final String role;
  final String imageUrl;

  UserProfile({required this.name, required this.role, required this.imageUrl});
}

final UserProfile currentUser = UserProfile(
  name: 'Rohit Kumar',
  role: 'Waste Management Worker',
  imageUrl:
      'https://ui-avatars.com/api/?name=Rohit+Kumar&background=4CAF50&color=fff&size=150',
);

List<Task> dummyTasks = [
  Task(
    id: '1001',
    title: 'Clean Garbage at MG Road',
    location: 'MG Road, Sector 14, Gurgaon',
    status: 'In Progress',
    dateTime: DateTime(2025, 10, 6, 9, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400&h=400&fit=crop',
    statusColor: const Color(0xFFFFF9C4),
    statusTextColor: const Color(0xFFFFA000),
  ),
  Task(
    id: '1002',
    title: 'Fix Broken Recycling Bin',
    location: 'City Park, Phase 2, Gurgaon',
    status: 'Pending',
    dateTime: DateTime(2025, 10, 6, 10, 30),
    imageUrl:
        'https://images.unsplash.com/photo-1526951521990-620dc14c214b?w=400&h=400&fit=crop',
    statusColor: const Color(0xFFFFEBEE),
    statusTextColor: const Color(0xFFD32F2F),
  ),
  Task(
    id: '1003',
    title: 'Clear Illegal Dumping Site',
    location: 'Behind Mall, Sector 18, Gurgaon',
    status: 'Completed',
    dateTime: DateTime(2025, 10, 5, 16, 15),
    imageUrl:
        'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=400&h=400&fit=crop',
    statusColor: const Color(0xFFC8E6C9),
    statusTextColor: const Color(0xFF388E3C),
  ),
];

// =========================================================================
// 2. APP ROOT AND ENTRY SCREEN (No change)
// =========================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const EntryScreen(),
    );
  }
}

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF87CEFA), // sky blue
              Color(0xFF00BFFF),
              Color(0xFF1E90FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'EcoTrack',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Worker Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF1F8E9)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const WorkerDashboardScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E90FF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 3. WORKER DASHBOARD SCREEN (Bottom Navigation Updated)
// =========================================================================

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen>
    with SingleTickerProviderStateMixin {
  int totalTasks = 12;
  int completedTasks = 8;
  int pendingTasks = 4;
  int points = 240;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingSection(),
                  _buildSummaryCards(),
                  _buildTasksSection(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        // Handle navigation based on selected index
        if (index == 0) {
          // Dashboard - Stay on current screen
          setState(() {
            _currentIndex = 0;
          });
        } else if (index == 1) {
          // Tasks - Navigate to Full Assigned Tasks Screen
          setState(() {
            _currentIndex = 1;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullAssignedTasksScreen(tasks: dummyTasks),
            ),
          ).then((_) {
            // Reset to Dashboard after returning
            setState(() {
              _currentIndex = 0;
            });
          });
        } else if (index == 2) {
          // Notifications - Navigate to Notifications Screen
          setState(() {
            _currentIndex = 2;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          ).then((_) {
            // Reset to Dashboard after returning
            setState(() {
              _currentIndex = 0;
            });
          });
        } else if (index == 3) {
          // Profile - Open Drawer
          setState(() {
            _currentIndex = 3;
          });
          _scaffoldKey.currentState?.openDrawer();
          // Reset to Dashboard
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              _currentIndex = 0;
            });
          });
        }
      },
      selectedItemColor: const Color(0xFF1E90FF),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
          
          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_rounded),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E90FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E90FF)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_rounded,
                    color: Color(0xFF1E90FF)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E90FF), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E90FF).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.imageUrl),
              radius: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0F4F8),
              Color(0xFFE1E8ED),
              Color(0xFFD5E1EA),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.7),
                    Colors.white.withOpacity(0.4),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF87CEEB).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB8D4E8),
                          Color(0xFF87CEEB),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF87CEEB).withOpacity(0.3),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.imageUrl),
                        radius: 42,
                        backgroundColor: const Color(0xFFF0F4F8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CEEB).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF87CEEB).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      currentUser.role,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF34495E),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                children: [
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.assignment_rounded,
                    title: 'Tasks',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    badge: '3',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationsScreen()),
                      );
                    },
                  ),
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.person_rounded,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Divider(
                      color: const Color(0xFF87CEEB).withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildRefinedDrawerItem(
                    context: context,
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF8A80).withOpacity(0.85),
                    const Color(0xFFFF5252).withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5252).withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const EntryScreen()),
                      (route) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }

  Widget _buildRefinedDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF87CEEB).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF87CEEB).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: const Color(0xFF87CEEB).withOpacity(0.1),
          highlightColor: const Color(0xFF87CEEB).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFB8D4E8),
                        Color(0xFF87CEEB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF87CEEB).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A80), Color(0xFFFF5252)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5252).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (badge == null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xFF87CEEB).withOpacity(0.5),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(currentUser.imageUrl),
            radius: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${currentUser.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser.role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assigned Tasks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF87CEFA), Color(0xFF1E90FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E90FF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullAssignedTasksScreen(tasks: dummyTasks),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                  label: const Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyTasks.length,
            itemBuilder: (context, index) {
              final task = dummyTasks[index];
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 400 + (index * 100)),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryCard(
            icon: Icons.assignment_rounded,
            label: 'Total Tasks',
            value: totalTasks.toString(),
            color: const Color(0xFF1E90FF),
            gradient: const LinearGradient(
              colors: [Color(0xFF87CEFA), Color(0xFF1E90FF)],
            ),
          ),
          _buildSummaryCard(
            icon: Icons.check_circle_rounded,
            label: 'Completed',
            value: completedTasks.toString(),
            color: const Color(0xFF388E3C),
            gradient: const LinearGradient(
              colors: [Color(0xFFC8E6C9), Color(0xFF388E3C)],
            ),
          ),
          _buildSummaryCard(
            icon: Icons.pending_actions_rounded,
            label: 'Pending',
            value: pendingTasks.toString(),
            color: const Color(0xFFD32F2F),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFEBEE), Color(0xFFD32F2F)],
            ),
          ),
          _buildSummaryCard(
            icon: Icons.star_rounded,
            label: 'Points',
            value: points.toString(),
            color: const Color(0xFFFFA000),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF9C4), Color(0xFFFFA000)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. TASK CARD WIDGET (Modified for onTap)
// =========================================================================

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String datePart =
        taskDate == today ? 'Today' : DateFormat('d MMM').format(dateTime);
    String timePart = DateFormat('h:mm a').format(dateTime);

    return '$datePart, $timePart';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Hero(
                    tag: 'task_${task.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        task.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.grey.shade300, Colors.grey.shade400],
                              ),
                            ),
                            child: const Icon(
                              Icons.image_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.location,
                          style:
                              const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: task.statusColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: task.statusTextColor,
                                ),
                              ),
                            ),
                            Text(
                              _formatDateTime(task.dateTime),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// FULL ASSIGNED TASKS SCREEN
// =========================================================================

class FullAssignedTasksScreen extends StatelessWidget {
  final List<Task> tasks;
  const FullAssignedTasksScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Assigned Tasks'),
        backgroundColor: const Color(0xFF1E90FF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

// Notification Model
class NotificationModel {
  final String id;
  final String type;
  final String message;
  final String timestamp;
  final String status;
  final String icon;
  final String color;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.status,
    required this.icon,
    required this.color,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      type: data['type'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? '',
      status: data['status'] ?? '',
      icon: data['icon'] ?? 'user',
      color: data['color'] ?? 'orange',
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  String activeFilter = 'All';
  bool isClearing = false;
  late AnimationController _clearController;
  late AnimationController _pulseController;

  // Dummy data for demonstration (replace with Firebase)
  
  List<NotificationModel> notifications = [
    NotificationModel(
      id: '1',
      type: 'Task Assigned',
      message: 'Complaint #1012 (Garbage at MG Road) has been assigned to you.',
      timestamp: '28 Sept, 9:00 AM',
      status: 'Assigned',
      icon: 'user',
      color: 'orange',
    ),
    NotificationModel(
      id: '2',
      type: 'Task Reminder',
      message: 'Reminder: Task #1012 is pending, complete before 5 PM today.',
      timestamp: '28 Sept, 2:30 PM',
      status: 'In Progress',
      icon: 'clock',
      color: 'blue',
    ),
    NotificationModel(
      id: '3',
      type: 'Task Completed',
      message: 'Well done! Task #1005 marked as completed successfully.',
      timestamp: '27 Sept, 6:45 PM',
      status: 'Completed',
      icon: 'check',
      color: 'green',
    ),
    NotificationModel(
      id: '4',
      type: 'New Task Assigned',
      message: 'Complaint #1015 (Street cleaning at Sector 21) has been assigned to you.',
      timestamp: '27 Sept, 3:15 PM',
      status: 'Assigned',
      icon: 'user',
      color: 'orange',
    ),
    NotificationModel(
      id: '5',
      type: 'Urgent Reminder',
      message: 'High priority: Task #1008 requires immediate attention.',
      timestamp: '27 Sept, 1:20 PM',
      status: 'In Progress',
      icon: 'alert',
      color: 'blue',
    ),
    NotificationModel(
      id: '6',
      type: 'Achievement Unlocked',
      message: "Congratulations! You've completed 10 tasks this week. Keep up the great work!",
      timestamp: '26 Sept, 8:00 PM',
      status: 'Completed',
      icon: 'award',
      color: 'green',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _clearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    // Uncomment below to fetch from Firebase
    // _fetchNotifications();
  }

  @override
  void dispose() {
    _clearController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Firebase fetch method
  // void _fetchNotifications() {
  //   FirebaseFirestore.instance
  //       .collection('notifications')
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .listen((snapshot) {
  //     setState(() {
  //       notifications = snapshot.docs
  //           .map((doc) => NotificationModel.fromFirestore(doc))
  //           .toList();
  //     });
  //   });
  // }

  void _handleClearAll() async {
    setState(() {
      isClearing = true;
    });
    _clearController.forward();

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      notifications.clear();
      isClearing = false;
    });
    _clearController.reset();

    // Uncomment to delete from Firebase
    // final batch = FirebaseFirestore.instance.batch();
    // for (var notification in notifications) {
    //   batch.delete(FirebaseFirestore.instance.collection('notifications').doc(notification.id));
    // }
    // await batch.commit();
  }

  List<NotificationModel> get filteredNotifications {
    if (activeFilter == 'All') return notifications;
    return notifications.where((n) => n.status == activeFilter).toList();
  }

  List<Color> _getGradientFromString(String color) {
    switch (color) {
      case 'orange':
        return [const Color(0xFFFF6B35), const Color(0xFFFF8C42)];
      case 'blue':
        return [const Color(0xFF4A90E2), const Color(0xFF50C9FF)];
      case 'green':
        return [const Color(0xFF10B981), const Color(0xFF34D399)];
      default:
        return [const Color(0xFFFF6B35), const Color(0xFFFF8C42)];
    }
  }

  IconData _getIconFromString(String icon) {
    switch (icon) {
      case 'user':
        return Icons.person_outline_rounded;
      case 'clock':
        return Icons.access_time_rounded;
      case 'check':
        return Icons.check_circle_outline_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'award':
        return Icons.emoji_events_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Widget _buildStatusBadge(String status) {
    List<Color> gradient;
    switch (status) {
      case 'Assigned':
        gradient = [const Color(0xFFFF6B35), const Color(0xFFFF8C42)];
        break;
      case 'In Progress':
        gradient = [const Color(0xFF4A90E2), const Color(0xFF50C9FF)];
        break;
      case 'Completed':
        gradient = [const Color(0xFF10B981), const Color(0xFF34D399)];
        break;
      default:
        gradient = [Colors.grey.shade400, Colors.grey.shade500];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, int index) {
    final gradientColors = _getGradientFromString(notification.color);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: isClearing ? 0.0 : 1.0, end: isClearing ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value * 400, 0),
          child: Opacity(
            opacity: 1 - value,
            child: child,
          ),
        );
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100 + (index * 100)),
        opacity: isClearing ? 0 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 15,
                offset: const Offset(-5, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  splashColor: gradientColors[0].withOpacity(0.1),
                  highlightColor: gradientColors[0].withOpacity(0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0].withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getIconFromString(notification.icon),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.type,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Color(0xFF1F2937),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatusBadge(notification.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey.shade700,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      notification.timestamp,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (0.05 * (0.5 - (_pulseController.value - 0.5).abs())),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade100,
                        Colors.grey.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.grey.shade700, Colors.grey.shade500],
            ).createShader(bounds),
            child: const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All notifications have been cleared',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF10B981).withOpacity(0.05),
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar with glassmorphism
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, 
                              size: 20,
                              color: Color(0xFF1F2937)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (notifications.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF34D399)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _handleClearAll,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    'Clear All',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Filter tabs with glassmorphism
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Assigned', 'In Progress', 'Completed']
                        .map((filter) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _buildFilterChip(filter),
                            ))
                        .toList(),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredNotifications.length,
                        itemBuilder: (context, index) {
                          return _buildNotificationCard(
                              filteredNotifications[index], index);
                        },
                      ),
              ),
              // Bottom button with premium style
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200.withOpacity(0.5),
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.assignment_outlined,
                                size: 22, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Go to Tasks',
                              style: TextStyle(
                                fontSize: 17,
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildGlassyBottomNav(),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = activeFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassyBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade200.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: 2,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF10B981),
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_rounded, size: 28),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded, size: 28),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
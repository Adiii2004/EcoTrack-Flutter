import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifications',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final Color statusColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String date;
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.date,
    required this.isUnread,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  String appliedFilter = 'All Notifications';
  bool isFilterOpen = false;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  final List<String> filterOptions = [
    'All Notifications',
    'Open',
    'Assigned',
    'Resolved',
  ];

  List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: 'Complaint Resolved Successfully',
      description:
          'Your complaint (Garbage Issue - ID#ECT-2024-001) has been resolved successfully by the municipal team.',
      status: 'Resolved',
      statusColor: Colors.green,
      icon: Icons.check_circle,
      iconBg: Colors.green.shade50,
      iconColor: Colors.green.shade700,
      date: '28 Sept, 4:40 PM',
      isUnread: true,
    ),
    NotificationModel(
      id: 2,
      title: 'Complaint Assigned to Worker',
      description:
          'Your complaint (Illegal Dumping - ID#ECT-2024-002) has been assigned to Worker Rohit Kumar for resolution.',
      status: 'Assigned',
      statusColor: Colors.orange,
      icon: Icons.access_time,
      iconBg: Colors.orange.shade50,
      iconColor: Colors.orange.shade700,
      date: '27 Sept, 2:30 PM',
      isUnread: true,
    ),
    NotificationModel(
      id: 3,
      title: 'Complaint Under Review',
      description:
          'Your complaint (Garbage Collection - ID#ECT-2024-003) is still under review by our authorities.',
      status: 'Open',
      statusColor: Colors.red,
      icon: Icons.error_outline,
      iconBg: Colors.red.shade50,
      iconColor: Colors.red.shade700,
      date: '26 Sept, 10:15 AM',
      isUnread: false,
    ),
    NotificationModel(
      id: 4,
      title: 'Work in Progress',
      description:
          'Work has started on your complaint (Broken Streetlight - ID#ECT-2024-003). Expected completion in 2 days.',
      status: 'Assigned',
      statusColor: Colors.orange,
      icon: Icons.access_time,
      iconBg: Colors.orange.shade50,
      iconColor: Colors.orange.shade700,
      date: '25 Sept, 3:20 PM',
      isUnread: false,
    ),
    NotificationModel(
      id: 5,
      title: 'Complaint Acknowledged',
      description:
          'Your complaint (Overflowing Dumpster - ID#ECT-2024-004) has been received and is under review.',
      status: 'Open',
      statusColor: Colors.red,
      icon: Icons.inventory_2_outlined,
      iconBg: Colors.blue.shade50,
      iconColor: Colors.blue.shade700,
      date: '24 Sept, 8:45 AM',
      isUnread: false,
    ),
    NotificationModel(
      id: 6,
      title: 'Recycling Pickup Completed',
      description:
          'Your complaint (Missing Recycling Pickup - ID#ECT-2024-005) has been resolved. Service restored.',
      status: 'Resolved',
      statusColor: Colors.green,
      icon: Icons.check_circle,
      iconBg: Colors.green.shade50,
      iconColor: Colors.green.shade700,
      date: '23 Sept, 6:30 PM',
      isUnread: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    super.dispose();
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isUnread = false;
      }
    });
  }

  void markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isUnread = false;
      }
    });
  }

  void toggleFilter() {
    setState(() {
      isFilterOpen = !isFilterOpen;
      if (isFilterOpen) {
        _filterAnimationController.forward();
      } else {
        _filterAnimationController.reverse();
      }
    });
  }

  void selectAndApplyFilter(String filter) {
    setState(() {
      appliedFilter = filter;
      isFilterOpen = false;
      _filterAnimationController.reverse();
    });
  }

  List<NotificationModel> get filteredNotifications {
    if (appliedFilter == 'All Notifications') {
      return notifications;
    }
    return notifications.where((n) => n.status == appliedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    // The main Scaffold now contains a Stack
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade50,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack( // This Stack ensures the Pop-up is drawn over the list
            children: [
              // 1. Main Content (Header, List, and Button)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header (This is now just the AppBar, without the inner Stack)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Back Icon
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            // Title
                            const Expanded(
                              child: Text(
                                'Notifications',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Mark All Read
                            GestureDetector(
                              onTap: markAllAsRead,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: const Text(
                                  'Mark all read',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Settings/Filter Icon - Toggles the dropdown
                            Material(
                              key: const ValueKey('settingsIcon'),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: toggleFilter,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.settings,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Notifications List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = filteredNotifications[index];
                          return TweenAnimationBuilder(
                            duration:
                                Duration(milliseconds: 300 + (index * 100)),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: NotificationCard(
                              notification: notification,
                              onTap: () => markAsRead(notification.id),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // View My Complaints Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'View My Complaints',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Filter Dropdown Menu (Positioned on top of everything)
              if (isFilterOpen)
                Positioned(
                  // Calculated based on header height (approx 80 + padding)
                  top: 80, 
                  right: 16,
                  child: ScaleTransition(
                    scale: _filterAnimation,
                    alignment: Alignment.topRight,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: filterOptions.map((option) {
                            final isSelected = appliedFilter == option;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  selectAndApplyFilter(option);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green.shade50
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.green.shade700
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: widget.notification.isUnread
              ? const Border(
                  left: BorderSide(color: Colors.green, width: 4),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.notification.iconBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.notification.iconColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.notification.icon,
                  color: widget.notification.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.notification.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (widget.notification.isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.notification.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.notification.statusColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: widget.notification.statusColor
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.notification.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.notification.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
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
    );
  }
}
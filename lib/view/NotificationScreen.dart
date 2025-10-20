import 'package:flutter/material.dart';

// FIX 1: Change 'const' to 'final' to avoid compile-time error
// NOTE: Colors.green is a MaterialColor, but the variable type is Color.
// For simplicity and to avoid casting issues in Theme, we'll redefine the theme slightly below.
final Color kPrimaryGreen = Colors.green; 
final MaterialColor kPrimarySwatch = Colors.green;

// --- 1. DATA MODEL ---

enum NotificationType {
  newOrder,
  paymentReceived,
  orderStatusUpdated,
  newReview,
  lowStock,
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final String status;
  final String actionText;
  final bool isToday;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.status = '',
    required this.actionText,
    this.isToday = true,
  });
}

// --- 2. MAIN SCREEN ---

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Scheme Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // FIX 2: Use the MaterialColor directly, or the specifically typed kPrimarySwatch
        primarySwatch: kPrimarySwatch, 
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          // Use kPrimaryGreen for icon/text elements on the AppBar for consistency
          foregroundColor: kPrimaryGreen, 
        ),
      ),
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  // Placeholder data
  final List<NotificationItem> notifications = [
    // TODAY
    NotificationItem(
      title: 'New Order Received!',
      description: 'Raj Patel ordered 2 Compost Bags from your store',
      time: '2:30 PM',
      type: NotificationType.newOrder,
      status: 'Pending',
      actionText: 'View Order',
    ),
    NotificationItem(
      title: 'Payment Received',
      description: '₹750 payment received for Order #ORD-154',
      time: '1:15 PM',
      type: NotificationType.paymentReceived,
      status: 'Completed',
      actionText: 'View Payment',
    ),
    NotificationItem(
      title: 'Order Status Updated',
      description: 'Bio Fertilizer order has been shipped to customer',
      time: '11:45 AM',
      type: NotificationType.orderStatusUpdated,
      status: 'Shipped',
      actionText: 'Track Order',
    ),

    // YESTERDAY
    NotificationItem(
      title: 'New Review Received',
      description: 'Anita Desai left a 5-star review for Recycled Planter',
      time: 'Oct 6, 4:20 PM',
      type: NotificationType.newReview,
      status: '5-star',
      actionText: 'Review',
      isToday: false,
    ),
    NotificationItem(
      title: 'Low Stock Alert',
      description: 'Organic Compost stock is running low (2 items left)',
      time: 'Oct 6, 2:10 PM',
      type: NotificationType.lowStock,
      status: 'Alert',
      actionText: 'Update Stock',
      isToday: false,
    ),
  ];

  

  @override
  Widget build(BuildContext context) {
    final todayNotifications = notifications.where((n) => n.isToday).toList();
    final yesterdayNotifications = notifications.where((n) => !n.isToday).toList();

    return Scaffold(
      appBar: AppBar(
        // Title color should inherit from foregroundColor set in Theme
        title: Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryGreen), 
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Clear All', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            // Badge fix is already integrated here: using label and backgroundColor
            child: Badge(
              label: Text('3', style: TextStyle(color: Colors.white, fontSize: 10)), 
              backgroundColor: kPrimaryGreen, 
              child: Icon(Icons.notifications_active_outlined, color: kPrimaryGreen),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Stay updated with your orders',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          _buildSectionHeader(context, 'TODAY'),
          ...todayNotifications.map((item) => NotificationCard(item: item)),
          const SizedBox(height: 20.0),
          _buildSectionHeader(context, 'YESTERDAY'),
          ...yesterdayNotifications.map((item) => NotificationCard(item: item)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.grey[400],
          letterSpacing: 1.5,
          fontSize: 12,
        ),
      ),
    );
  }
}

// --- 3. CUSTOM NOTIFICATION CARD WIDGET ---

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return Colors.orange[600]!; 
      case NotificationType.paymentReceived:
        return kPrimaryGreen;
      case NotificationType.orderStatusUpdated:
        return Colors.blue[600]!; 
      case NotificationType.newReview:
        return Colors.purple[600]!; 
      case NotificationType.lowStock:
        return Colors.red[600]!; 
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return Icons.shopping_cart_outlined;
      case NotificationType.paymentReceived:
        return Icons.currency_rupee_outlined;
      case NotificationType.orderStatusUpdated:
        return Icons.sync_alt;
      case NotificationType.newReview:
        return Icons.star_border;
      case NotificationType.lowStock:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getTypeColor(item.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            border: Border(
              left: BorderSide(color: cardColor, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(item.type), color: cardColor, size: 20),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item.description,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(item.time, style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10.0),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(color: cardColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      item.actionText,
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
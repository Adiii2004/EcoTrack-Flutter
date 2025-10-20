import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Orders',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0; // For managing the tabs (All Orders, In Progress, Delivered)
  bool _isTitleVisible = false;

  @override
  void initState() {
    super.initState();
    // Add a slight delay before showing the title and icon for animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isTitleVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Reduced AppBar height
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, // White AppBar background
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Title and Icon
              AnimatedOpacity(
                opacity: _isTitleVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20, // Slightly smaller icon
                      backgroundColor: Colors.green[700],
                      child: Icon(Icons.shopping_bag, size: 24, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "My Eco Orders",
                      style: TextStyle(
                        fontSize: 22, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Subheading Text with Animation
              SizedBox(height: 8),
              AnimatedOpacity(
                opacity: _isTitleVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Text(
                  "Track Your Eco Product Orders", // Capitalized words
                  style: TextStyle(
                    fontSize: 14, // Slightly smaller font size
                    color: Colors.green[700]!.withOpacity(0.8), // Using non-nullable color
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Section - All Orders, In Progress, Delivered
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton("All Orders", 0),
                _buildTabButton("In Progress", 1),
                _buildTabButton("Delivered", 2),
              ],
            ),
          ),
          // Content Section Based on Tab Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _selectedIndex == 0
                  ? OrderList(type: "All Orders")
                  : _selectedIndex == 1
                      ? OrderList(type: "In Progress")
                      : OrderList(type: "Delivered"),
            ),
          ),
          // Track Your Eco Product Orders Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Track Your Eco Product Orders", // Capitalized words
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab Button Widget for switching categories with Border Beam Effect
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          gradient: _selectedIndex == index
              ? LinearGradient(
                  colors: [Colors.green[700]!, Colors.green[500]!],
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _selectedIndex == index ? Colors.green[700]!.withOpacity(0.3) : Colors.transparent,
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
          border: Border.all(
            color: _selectedIndex == index
                ? Colors.green[700]!
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Glossy Effect/Beam on active button
            if (_selectedIndex == index)
              Positioned(
                left: -5,
                right: -5,
                top: -5,
                bottom: -5,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.green.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green[700]!.withOpacity(0.6),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            // Actual Text inside the button (Capitalized)
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.white : Colors.green[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String type;

  const OrderList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Add some dummy orders for different categories
        OrderItem(
          productName: "Bamboo Water Bottle",
          orderNumber: "#ORD-2025-001",
          price: 24.99,
          orderDate: "Ordered on Oct 3, 2025",
          status: type == "Delivered" ? "Delivered" : "In Progress",
          statusColor: type == "Delivered" ? Colors.green : Colors.orange,
        ),
        OrderItem(
          productName: "Organic Cotton Tote Bag",
          orderNumber: "#ORD-2025-002",
          price: 18.50,
          orderDate: "Ordered on Oct 5, 2025",
          status: type == "Delivered" ? "Delivered" : "In Progress",
          statusColor: type == "Delivered" ? Colors.green : Colors.orange,
        ),
        OrderItem(
          productName: "Solar Phone Charger",
          orderNumber: "#ORD-2025-003",
          price: 45.00,
          orderDate: "Ordered on Oct 1, 2025",
          status: type == "Delivered" ? "Delivered" : "In Progress",
          statusColor: type == "Delivered" ? Colors.green : Colors.orange,
        ),
      ],
    );
  }
}

class OrderItem extends StatefulWidget {
  final String productName;
  final String orderNumber;
  final double price;
  final String orderDate;
  final String status;
  final Color statusColor;

  const OrderItem({super.key, 
    required this.productName,
    required this.orderNumber,
    required this.price,
    required this.orderDate,
    required this.status,
    required this.statusColor,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.shopping_bag, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.orderNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.orderDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "\$${widget.price}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.statusColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "View Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

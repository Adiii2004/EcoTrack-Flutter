import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FilterModel(),
      child: EcoTrackApp(),
    ),
  );
}

class EcoTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack AI',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "EcoTrack Dashboard",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.green.shade900),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: ZoAnimatedGradientBorder(
          borderRadius: 12,
          animationCurve: Curves.easeInOut,
          borderThickness: 2,
          gradientColor: [Colors.greenAccent, Colors.lightGreenAccent],
          animationDuration: Duration(seconds: 3),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white70, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigating back to Complaints List")),
                );
              },
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Assign Workers"),
            Tab(text: "Track Assigned Work"),
          ],
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.green.shade900),
          labelColor: Colors.green.shade900,
          unselectedLabelColor: Colors.green.shade300,
          indicatorColor: Colors.green.shade900,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F7F3), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            AssignWorkersTab(),
            TrackAssignedWorkTab(),
          ],
        ),
      ),
      floatingActionButton: ZoAnimatedGradientBorder(
        borderRadius: 12,
        animationCurve: Curves.easeInOut,
        borderThickness: 2,
        gradientColor: [Colors.greenAccent, Colors.lightGreenAccent],
        animationDuration: Duration(seconds: 3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Refreshing data")),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.refresh, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AssignWorkersTab extends StatelessWidget {
  final workers = [
    Worker("Michael Chen", "Senior Inspector", 2, "Zone A, B", "15 min avg", 4.8, "Available"),
    Worker("Sarah Johnson", "Environmental Officer", 1, "Zone A", "12 min avg", 4.9, "Available"),
    Worker("David Rodriguez", "Field Coordinator", 3, "Zone B, C", "On Break", 4.7, "On Break"),
    Worker("Emma Wilson", "Senior Inspector", 5, "Zone A, D", "Overloaded", 4.9, "Busy"),
    Worker("James Thompson", "Environmental Officer", 1, "Zone A, C", "18 min avg", 4.6, "Available"),
    Worker("Lisa Anderson", "Field Inspector", 0, "Zone C", "10 min avg", 4.8, "Available"),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32.0 : 16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                "Dashboard Summary",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              SizedBox(height: 16),
              AnimatedSummarySection(),
              SizedBox(height: 32),
              AnimatedComplaintCard(),
              SizedBox(height: 16),
              FilterSection(),
              SizedBox(height: 16),
              ...workers.asMap().entries.map((entry) {
                return AnimatedWorkerCard(
                  worker: entry.value,
                  index: entry.key,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedSummarySection extends StatefulWidget {
  @override
  _AnimatedSummarySectionState createState() => _AnimatedSummarySectionState();
}

class _AnimatedSummarySectionState extends State<AnimatedSummarySection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            return isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: SummaryCard(title: "Total Complaints", value: "1247", icon: Icons.report_problem, color: Colors.redAccent, details: "Pending: 450\nIn Progress: 300\nCompleted: 497")),
                      SizedBox(width: 16),
                      Expanded(child: SummaryCard(title: "Active Workers", value: "32", icon: Icons.people, color: Colors.green, details: "Available: 20\nBusy: 8\nOn Break: 4")),
                      SizedBox(width: 16),
                      Expanded(child: SummaryCard(title: "Completed Tasks", value: "890", icon: Icons.check_circle, color: Colors.blue, details: "This Month: 120\nLast Month: 95\nYear to Date: 890")),
                    ],
                  )
                : Column(
                    children: [
                      SummaryCard(title: "Total Complaints", value: "1247", icon: Icons.report_problem, color: Colors.redAccent, details: "Pending: 450\nIn Progress: 300\nCompleted: 497"),
                      SizedBox(height: 16),
                      SummaryCard(title: "Active Workers", value: "32", icon: Icons.people, color: Colors.green, details: "Available: 20\nBusy: 8\nOn Break: 4"),
                      SizedBox(height: 16),
                      SummaryCard(title: "Completed Tasks", value: "890", icon: Icons.check_circle, color: Colors.blue, details: "This Month: 120\nLast Month: 95\nYear to Date: 890"),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class SummaryCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String details;

  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.details,
  });

  @override
  _SummaryCardState createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, widget.color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: _isHovered ? 12 : 6,
              spreadRadius: _isHovered ? 4 : 2,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        child: ExpansionTile(
          leading: Icon(widget.icon, color: widget.color, size: 32),
          title: Text(
            widget.value,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24, color: widget.color),
          ),
          subtitle: Text(
            widget.title,
            style: TextStyle(color: Colors.grey[700]),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.details,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackAssignedWorkTab extends StatelessWidget {
  final assignedWorks = [
    AssignedWork(
      complaintId: "#ECO-2024-1247",
      workerName: "Michael Chen",
      assignDate: DateTime(2025, 10, 6),
      dueDate: DateTime(2025, 10, 10),
      status: "In Progress",
      location: "Central Park, Zone A",
      priority: "High",
      notes: "Investigate dumping site and collect samples.",
    ),
    AssignedWork(
      complaintId: "#ECO-2024-1248",
      workerName: "Sarah Johnson",
      assignDate: DateTime(2025, 10, 5),
      dueDate: DateTime(2025, 10, 9),
      status: "Pending",
      location: "River Side, Zone B",
      priority: "Medium",
      notes: "Check for pollution sources along the river.",
    ),
    AssignedWork(
      complaintId: "#ECO-2024-1249",
      workerName: "Emma Wilson",
      assignDate: DateTime(2025, 10, 4),
      dueDate: DateTime(2025, 10, 8),
      status: "Completed",
      location: "Industrial Area, Zone C",
      priority: "Low",
      notes: "Routine inspection completed, no issues found.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assigned Works Overview",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              SizedBox(height: 16),
              ...assignedWorks.asMap().entries.map((entry) {
                return AnimatedAssignedWorkCard(
                  assignedWork: entry.value,
                  index: entry.key,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedComplaintCard extends StatefulWidget {
  @override
  _AnimatedComplaintCardState createState() => _AnimatedComplaintCardState();
}

class _AnimatedComplaintCardState extends State<AnimatedComplaintCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(_animation),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Illegal Waste Dumping",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Pending",
                        style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text("Complaint ID: #ECO-2024-1247", style: TextStyle(color: Colors.grey[600])),
                Text("Location: Central Park, Zone A", style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Priority: High",
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                    Text("2 hours ago", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterModel with ChangeNotifier {
  String? selectedAvailability;
  String? selectedZone;
  String? selectedExperience;

  void updateAvailability(String? value) {
    selectedAvailability = value;
    notifyListeners();
  }

  void updateZone(String? value) {
    selectedZone = value;
    notifyListeners();
  }

  void updateExperience(String? value) {
    selectedExperience = value;
    notifyListeners();
  }
}

class FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filterModel = Provider.of<FilterModel>(context);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            return isWide
                ? Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'Availability',
                          items: ['All', 'Available', 'Busy', 'On Break'],
                          onChanged: filterModel.updateAvailability,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Zone',
                          items: ['All', 'Zone A', 'Zone B', 'Zone C', 'Zone D'],
                          onChanged: filterModel.updateZone,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Experience',
                          items: ['All', '0-1 years', '1-3 years', '3+ years'],
                          onChanged: filterModel.updateExperience,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CustomDropdown(
                        label: 'Availability',
                        items: ['All', 'Available', 'Busy', 'On Break'],
                        onChanged: filterModel.updateAvailability,
                      ),
                      SizedBox(height: 12),
                      CustomDropdown(
                        label: 'Zone',
                        items: ['All', 'Zone A', 'Zone B', 'Zone C', 'Zone D'],
                        onChanged: filterModel.updateZone,
                      ),
                      SizedBox(height: 12),
                      CustomDropdown(
                        label: 'Experience',
                        items: ['All', '0-1 years', '1-3 years', '3+ years'],
                        onChanged: filterModel.updateExperience,
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + _animation.value * 0.05,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4 * _animation.value,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.inter()),
                  );
                }).toList(),
                onChanged: widget.onChanged,
                isExpanded: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Worker {
  final String name;
  final String role;
  final int cases;
  final String zone;
  final String response;
  final double rating;
  final String status;

  Worker(this.name, this.role, this.cases, this.zone, this.response, this.rating, this.status);
}

class AnimatedWorkerCard extends StatefulWidget {
  final Worker worker;
  final int index;

  const AnimatedWorkerCard({required this.worker, required this.index});

  @override
  _AnimatedWorkerCardState createState() => _AnimatedWorkerCardState();
}

class _AnimatedWorkerCardState extends State<AnimatedWorkerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500 + widget.index * 100),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool available = widget.worker.status == "Available";
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(_animation),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: available
                    ? [Colors.white, Colors.green.shade50]
                    : [Colors.white, Colors.grey.shade200],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isHovered ? 10 : 5,
                  spreadRadius: _isHovered ? 3 : 1,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                radius: 28,
                child: Icon(Icons.person, color: Colors.green.shade700, size: 30),
              ),
              title: Text(
                widget.worker.name,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.worker.role, style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 6),
                  Text(
                    "Workload: ${widget.worker.cases} cases • ${widget.worker.zone}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  Text(
                    "Response: ${widget.worker.response}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        widget.worker.rating.toString(),
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: available
                  ? AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: ZoAnimatedGradientBorder(
                        borderRadius: 12,
                        animationCurve: Curves.easeInOut,
                        borderThickness: 2,
                        gradientColor: [Colors.greenAccent, Colors.lightGreenAccent],
                        animationDuration: Duration(seconds: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.greenAccent.shade400, Colors.greenAccent.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Assigned to ${widget.worker.name}")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: _isHovered ? 8 : 4,
                            ),
                            child: Text(
                              "Assign",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.worker.status,
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignedWork {
  final String complaintId;
  final String workerName;
  final DateTime assignDate;
  final DateTime dueDate;
  final String status;
  final String location;
  final String priority;
  final String notes;

  AssignedWork({
    required this.complaintId,
    required this.workerName,
    required this.assignDate,
    required this.dueDate,
    required this.status,
    required this.location,
    required this.priority,
    required this.notes,
  });
}

class AnimatedAssignedWorkCard extends StatefulWidget {
  final AssignedWork assignedWork;
  final int index;

  const AnimatedAssignedWorkCard({required this.assignedWork, required this.index});

  @override
  _AnimatedAssignedWorkCardState createState() => _AnimatedAssignedWorkCardState();
}

class _AnimatedAssignedWorkCardState extends State<AnimatedAssignedWorkCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500 + widget.index * 100),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MaterialColor _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(_animation),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isHovered ? 10 : 5,
                  spreadRadius: _isHovered ? 3 : 1,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(widget.assignedWork.status)[100],
                child: Icon(Icons.assignment, color: _getStatusColor(widget.assignedWork.status)),
              ),
              title: Text(
                widget.assignedWork.complaintId,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Assigned to: ${widget.assignedWork.workerName} • Status: ${widget.assignedWork.status}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location: ${widget.assignedWork.location}", style: TextStyle(color: Colors.grey[700])),
                      Text("Priority: ${widget.assignedWork.priority}", style: TextStyle(color: Colors.grey[700])),
                      Text("Assign Date: ${widget.assignedWork.assignDate.toLocal().toString().split(' ')[0]}", style: TextStyle(color: Colors.grey[700])),
                      Text("Due Date: ${widget.assignedWork.dueDate.toLocal().toString().split(' ')[0]}", style: TextStyle(color: Colors.grey[700])),
                      Text("Notes: ${widget.assignedWork.notes}", style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: widget.assignedWork.status == 'Completed' ? 1.0 : (widget.assignedWork.status == 'In Progress' ? 0.5 : 0.0),
                        backgroundColor: Colors.grey.shade200,
                        color: _getStatusColor(widget.assignedWork.status),
                      ),
                      SizedBox(height: 8),
                      ZoAnimatedGradientBorder(
                        borderRadius: 12,
                        animationCurve: Curves.easeInOut,
                        borderThickness: 2,
                        gradientColor: [Colors.blueAccent, Colors.cyan],
                        animationDuration: Duration(seconds: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.blue.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Viewing details for ${widget.assignedWork.complaintId}")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: _isHovered ? 8 : 4,
                            ),
                            child: Text(
                              "View Details",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
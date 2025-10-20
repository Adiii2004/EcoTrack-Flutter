import 'package:ecotrack/view/complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  String _selectedStatus = 'All Status';
  String _selectedSort = 'Recent';
  bool _showFilters = false;

  final List<String> _statusOptions = [
    'All Status',
    'Open',
    'Assigned',
    'Resolved',
  ];
  final List<String> _sortOptions = ['Recent', 'Oldest'];

  final List<Map<String, dynamic>> _complaints = [
    {
      'id': '#ECT-2024-001',
      'title': 'Garbage not collected',
      'location': 'Green Valley, Sector 12',
      'status': 'Open',
      'time': '2 hours ago',
      'progress': 0.0,
      'image':
          'https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=200',
    },
    {
      'id': '#ECT-2024-002',
      'title': 'Illegal dumping in park',
      'location': 'Central Park, Block A',
      'status': 'Assigned',
      'time': '1 day ago',
      'progress': 0.5,
      'image':
          'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=200',
    },
    {
      'id': '#ECT-2024-003',
      'title': 'Broken recycling bin',
      'location': 'Main Street, Plaza',
      'status': 'Resolved',
      'time': '3 days ago',
      'progress': 1.0,
      'image':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200',
    },
    {
      'id': '#ECT-2024-004',
      'title': 'Overflowing dumpster',
      'location': 'Residential Complex',
      'status': 'Assigned',
      'time': '5 days ago',
      'progress': 0.5,
      'image':
          'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=200',
    },
    {
      'id': '#ECT-2024-005',
      'title': 'Missing recycling pickup',
      'location': 'Oak Avenue, Building 7',
      'status': 'Resolved',
      'time': '1 week ago',
      'progress': 1.0,
      'image':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200',
    },
  ];

  List<Map<String, dynamic>> get _filteredComplaints {
    var filtered = _complaints;

    // Filter by status
    if (_selectedStatus != 'All Status') {
      filtered = filtered.where((c) => c['status'] == _selectedStatus).toList();
    }

    // Sort
    if (_selectedSort == 'Oldest') {
      filtered = filtered.reversed.toList();
    }

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return const Color.fromRGBO(244, 67, 54, 1);
      case 'Assigned':
        return const Color.fromRGBO(255, 152, 0, 1);
      case 'Resolved':
        return const Color.fromRGBO(76, 175, 80, 1);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 245, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Complaints',
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(76, 175, 80, 1),
                    Color.fromRGBO(56, 142, 60, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.filter_list_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Section - Show/Hide based on state
          if (_showFilters)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status Filter
                  Expanded(
                    child: _buildDropdown(
                      value: _selectedStatus,
                      items: _statusOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sort Filter
                  Expanded(
                    child: _buildDropdown(
                      value: _selectedSort,
                      items: _sortOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (_showFilters) const SizedBox(height: 8),

          // Complaints List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: _filteredComplaints.length,
              itemBuilder: (context, index) {
                final complaint = _filteredComplaints[index];
                return _buildComplaintCard(complaint);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(76, 175, 80, 1),
              Color.fromRGBO(56, 142, 60, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(76, 175, 80, 1).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ComplaintScreen();
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'File New Complaint',
                    style: GoogleFonts.poppins(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade700,
          ),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(item),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint['id'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      complaint['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            complaint['location'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  complaint['image'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(complaint['status']),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  complaint['status'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                complaint['time'],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: complaint['progress'],
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: _getStatusColor(complaint['status']),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filed',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Assigned',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Resolved',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

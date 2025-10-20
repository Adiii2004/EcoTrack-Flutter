import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();
  int _selectedIndex = 1;
  final ImagePicker _picker = ImagePicker();
  File? _beforePhoto;
  File? _afterPhoto;

  // Task Status
  String _taskStatus = 'assigned'; // assigned, in_progress, completed
  DateTime? _inProgressTime;
  DateTime? _completedTime;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog(bool isBeforePhoto) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose Photo Source',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Take a new photo',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, isBeforePhoto);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.purple.shade600,
                    ),
                  ),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Choose from gallery',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, isBeforePhoto);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, bool isBeforePhoto) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null) {
        setState(() {
          if (isBeforePhoto) {
            _beforePhoto = File(image.path);
          } else {
            _afterPhoto = File(image.path);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isBeforePhoto ? "Before" : "After"} photo uploaded successfully!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error picking image. Please try again.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _markAsInProgress() {
    if (_taskStatus == 'assigned') {
      setState(() {
        _taskStatus = 'in_progress';
        _inProgressTime = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Task marked as In Progress!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markAsCompleted() {
    if (_beforePhoto == null || _afterPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please upload both Before and After photos!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_taskStatus != 'completed') {
      setState(() {
        _taskStatus = 'completed';
        _completedTime = DateTime.now();
        _inProgressTime ??= DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Task completed successfully! 🎉',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getFormattedTime(DateTime? dateTime) {
    if (dateTime == null) return 'Pending';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 247, 250, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
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
          'Task Details',
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.more_vert,
                size: 20,
                color: Colors.black87,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(33, 150, 243, 1),
                                Color.fromRGBO(66, 165, 245, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(33, 150, 243, 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'In Progress',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#1001',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Garbage not collected at MG Road',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'MG Road Junction, Sector 16, Cchs',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 18,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'View on Map',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=800',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            size: 20,
                            color: Colors.orange.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Description',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Garbage has been accumulating for 3 days. Waste bins are overflowing and creating unhygienic conditions in the area. Immediate collection required.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Assigned: 24 days · 9:00 AM',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Photo Evidence Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.photo_camera_outlined,
                            size: 20,
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Photo Evidence',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPhotoUploadBox(
                            icon: Icons.add_photo_alternate_outlined,
                            label: 'Before Photo',
                            sublabel: 'Upload before\nstarting',
                            isUploaded: _beforePhoto != null,
                            photoFile: _beforePhoto,
                            onTap: () => _showImageSourceDialog(true),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildPhotoUploadBox(
                            icon: Icons.add_photo_alternate_outlined,
                            label: 'After Photo',
                            sublabel: 'Upload after\ncompletion',
                            isUploaded: _afterPhoto != null,
                            photoFile: _afterPhoto,
                            onTap: () => _showImageSourceDialog(false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.shade100,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Photo evidence is required to complete the task',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber.shade900,
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
            const SizedBox(height: 16),

            // Task Update Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.edit_note_rounded,
                            size: 20,
                            color: Colors.purple.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Task Update',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Notes/Comments (Optional)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 4,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add any notes about the task progress...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(33, 150, 243, 1),
                              width: 2,
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Mark as In Progress Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          _taskStatus == 'assigned'
                              ? [
                                BoxShadow(
                                  color: const Color.fromRGBO(
                                    33,
                                    150,
                                    243,
                                    0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                              : [],
                    ),
                    child: ElevatedButton.icon(
                      onPressed:
                          _taskStatus == 'assigned' ? _markAsInProgress : null,
                      icon: Icon(
                        _taskStatus == 'assigned'
                            ? Icons.play_arrow_rounded
                            : Icons.check_circle_rounded,
                        size: 24,
                      ),
                      label: Text(
                        _taskStatus == 'assigned'
                            ? 'Mark as In Progress'
                            : _taskStatus == 'in_progress'
                            ? 'Task In Progress'
                            : 'Task In Progress ✓',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _taskStatus == 'assigned'
                                ? const Color.fromRGBO(33, 150, 243, 1)
                                : _taskStatus == 'in_progress'
                                ? Colors.blue.shade300
                                : Colors.green.shade400,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor:
                            _taskStatus == 'in_progress'
                                ? Colors.blue.shade300
                                : Colors.green.shade400,
                        disabledForegroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Mark as Completed Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          _taskStatus == 'in_progress' &&
                                  _beforePhoto != null &&
                                  _afterPhoto != null
                              ? [
                                BoxShadow(
                                  color: const Color.fromRGBO(76, 175, 80, 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                              : [],
                    ),
                    child: ElevatedButton.icon(
                      onPressed:
                          _taskStatus != 'completed' ? _markAsCompleted : null,
                      icon: Icon(
                        _taskStatus == 'completed'
                            ? Icons.check_circle_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 24,
                      ),
                      label: Text(
                        _taskStatus == 'completed'
                            ? 'Task Completed ✓'
                            : 'Mark as Completed',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _taskStatus == 'completed'
                                ? const Color.fromRGBO(76, 175, 80, 1)
                                : Colors.white,
                        foregroundColor:
                            _taskStatus == 'completed'
                                ? Colors.white
                                : Colors.grey.shade700,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                _taskStatus == 'completed'
                                    ? const Color.fromRGBO(76, 175, 80, 1)
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        elevation: 0,
                        disabledBackgroundColor:
                            _taskStatus == 'completed'
                                ? const Color.fromRGBO(76, 175, 80, 1)
                                : Colors.white,
                        disabledForegroundColor:
                            _taskStatus == 'completed'
                                ? Colors.white
                                : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete photo evidence and upload after completing the task',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Task Timeline Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.timeline_rounded,
                            size: 20,
                            color: Colors.indigo.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Task Timeline',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTimelineItem(
                      icon: Icons.description_outlined,
                      title: 'Complaint Filed',
                      time: '5 Sep, 9:00 AM',
                      isCompleted: true,
                      isFirst: true,
                    ),
                    _buildTimelineItem(
                      icon: Icons.person_outline,
                      title: 'Assigned to Worker',
                      time: '5 Sep, 9:00 AM',
                      isCompleted: true,
                    ),
                    _buildTimelineItem(
                      icon: Icons.work_outline,
                      title: 'Work in Progress',
                      time: _getFormattedTime(_inProgressTime),
                      isCompleted:
                          _taskStatus == 'in_progress' ||
                          _taskStatus == 'completed',
                    ),
                    _buildTimelineItem(
                      icon: Icons.check_circle_outline,
                      title: 'Task Completed',
                      time: _getFormattedTime(_completedTime),
                      isCompleted: _taskStatus == 'completed',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color.fromRGBO(76, 175, 80, 1),
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications_rounded),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploadBox({
    required IconData icon,
    required String label,
    required String sublabel,
    required bool isUploaded,
    File? photoFile,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(
            color: isUploaded ? Colors.green.shade400 : Colors.green.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isUploaded ? Colors.green.shade100 : Colors.green.shade50,
        ),
        child:
            isUploaded && photoFile != null
                ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        photoFile,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: const Color.fromRGBO(76, 175, 80, 1),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sublabel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        isCompleted
                            ? [
                              const Color.fromRGBO(76, 175, 80, 1),
                              const Color.fromRGBO(76, 175, 80, 0.6),
                            ]
                            : [Colors.grey.shade300, Colors.grey.shade300],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient:
                    isCompleted
                        ? const LinearGradient(
                          colors: [
                            Color.fromRGBO(76, 175, 80, 1),
                            Color.fromRGBO(102, 187, 106, 1),
                          ],
                        )
                        : LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade300],
                        ),
                shape: BoxShape.circle,
                boxShadow:
                    isCompleted
                        ? [
                          BoxShadow(
                            color: const Color.fromRGBO(76, 175, 80, 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                        : [],
              ),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        isCompleted
                            ? [
                              const Color.fromRGBO(76, 175, 80, 0.6),
                              const Color.fromRGBO(76, 175, 80, 1),
                            ]
                            : [Colors.grey.shade300, Colors.grey.shade300],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? Colors.green.shade50
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color:
                          isCompleted
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

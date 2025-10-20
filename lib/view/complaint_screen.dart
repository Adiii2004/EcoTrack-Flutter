import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Reference design colors
const Color kPrimaryGreen = Color(0xFF4CAF50);
const Color kDarkGreen = Color(0xFF2E7D32);
const Color kLightGreenBG = Color(0xFFE8F5E9);
const Color kCardBG = Colors.white;

class ComplaintCategory {
  final String name;
  final IconData icon;

  ComplaintCategory(this.name, this.icon);
}

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final List<ComplaintCategory> categories = [
    ComplaintCategory('🗑 Garbage Collection', Icons.delete_outline),
    ComplaintCategory('💨 Air Pollution', Icons.air_outlined),
    ComplaintCategory('💧 Water Pollution', Icons.water_drop_outlined),
    ComplaintCategory('🔊 Noise Pollution', Icons.volume_up_outlined),
    ComplaintCategory('📝 Others', Icons.more_horiz),
  ];

  late ComplaintCategory _selectedCategory;
  String _selectedPriority = 'Low';

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _hasImage = false;
  bool _hasLocation = false;
  File? _selectedImage;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories.first;

    // Listen to text changes
    _titleController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Check if all required fields are filled
  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _hasImage &&
        _hasLocation;
  }

  // Function to pick image from camera or gallery with image_picker
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source:
            source == ImageSource.camera
                ? ImageSource.camera
                : ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _hasImage = true;
          _selectedImageName = image.name;
          _selectedImage = File(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                source == ImageSource.camera
                    ? 'Photo captured successfully!'
                    : 'Photo selected from gallery!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: kPrimaryGreen,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error picking image: ${e.toString()}',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // Card wrapper matching reference design
  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kCardBG,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  // Issue Title Field
  Widget _buildIssueTitleField() {
    return TextField(
      controller: _titleController,
      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade800),
      decoration: InputDecoration(
        hintText: 'Enter a brief title for your complaint',
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Description Field
  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 4,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.grey.shade800,
        height: 1.4,
      ),
      decoration: InputDecoration(
        hintText: 'Describe the issue in detail...',
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Category Dropdown
  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ComplaintCategory>(
          value: _selectedCategory,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          style: GoogleFonts.inter(
            color: Colors.grey.shade800,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          hint: Text(
            'Select complaint category',
            style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
          ),
          items:
              categories.map((ComplaintCategory category) {
                return DropdownMenuItem<ComplaintCategory>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
          onChanged: (ComplaintCategory? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  // Priority Level - With animations
  Widget _buildPriorityLevel() {
    return Row(
      children:
          ['Low', 'Medium', 'High'].map((priority) {
            bool isSelected = _selectedPriority == priority;
            Color dotColor = const Color(0xFF4CAF50);
            if (priority == 'Medium') dotColor = const Color(0xFFFFA726);
            if (priority == 'High') dotColor = const Color(0xFFEF5350);

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: priority != 'High' ? 8 : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? dotColor : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: dotColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isSelected ? 10 : 8,
                          height: isSelected ? 10 : 8,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: GoogleFonts.inter(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: Colors.grey.shade800,
                            fontSize: 13,
                          ),
                          child: Text(priority),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  // Upload Evidence - With image picker
  Widget _buildUploadEvidence() {
    return GestureDetector(
      onTap: () {
        // Show bottom sheet with camera and gallery options
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
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
                    'Upload Evidence',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kPrimaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: kPrimaryGreen,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Take Photo',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    subtitle: Text(
                      'Open camera to take a picture',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kPrimaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: kPrimaryGreen,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Choose from Gallery',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    subtitle: Text(
                      'Select photo from your gallery',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: EdgeInsets.zero,
        dashPattern: const [8, 4],
        color: _hasImage ? kPrimaryGreen : kPrimaryGreen.withOpacity(0.6),
        strokeWidth: 2,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            color:
                _hasImage
                    ? kPrimaryGreen.withOpacity(0.1)
                    : const Color(0xFFF1F8F4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _hasImage
                      ? Icons.check_circle_outline
                      : Icons.cloud_upload_outlined,
                  size: 36,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _hasImage ? 'Photo uploaded!' : 'Tap to upload photo',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _hasImage
                      ? _selectedImageName ?? 'Tap to change photo'
                      : 'Take a picture or choose from gallery',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Location Section
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color:
                _hasLocation
                    ? kPrimaryGreen.withOpacity(0.15)
                    : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border:
                _hasLocation
                    ? Border.all(color: kPrimaryGreen, width: 2)
                    : null,
          ),
          child: Column(
            children: [
              Icon(
                _hasLocation ? Icons.location_on : Icons.location_on_outlined,
                size: 40,
                color: kPrimaryGreen,
              ),
              const SizedBox(height: 8),
              Text(
                _hasLocation ? 'Location Selected' : 'Select Location',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _hasLocation
                    ? 'Tap buttons to change location'
                    : 'Pin the exact location of the issue',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasLocation = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Current location selected!',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: kPrimaryGreen,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: kPrimaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.my_location,
                  size: 18,
                  color: kPrimaryGreen,
                ),
                label: Text(
                  'Current\nLocation',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasLocation = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location picked from map!',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: kPrimaryGreen,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: kPrimaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.map_outlined,
                  size: 18,
                  color: kPrimaryGreen,
                ),
                label: Text(
                  'Pick on\nMap',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreenBG,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryGreen),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'File a Complaint',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: kDarkGreen,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: kPrimaryGreen),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8F4), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'Issue Title',
                content: _buildIssueTitleField(),
              ),
              _buildCard(
                title: 'Description',
                content: _buildDescriptionField(),
              ),
              _buildCard(title: 'Category', content: _buildCategoryDropdown()),
              _buildCard(
                title: 'Priority Level',
                content: _buildPriorityLevel(),
              ),
              _buildCard(
                title: 'Upload Evidence',
                content: _buildUploadEvidence(),
              ),
              _buildCard(title: 'Location', content: _buildLocationSection()),
              const SizedBox(height: 100), // Space for bottom buttons
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Submit Button with Gradient
            SizedBox(
              width: double.infinity,
              child:
                  _isFormValid
                      ? Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryGreen.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Complaint Submitted Successfully!',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: kPrimaryGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Submit Complaint',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      : OutlinedButton.icon(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        label: Text(
                          'Submit Complaint',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 12),
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Complaint Cancelled',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Colors.grey.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: kPrimaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                icon: const Icon(Icons.close, color: kDarkGreen, size: 20),
                label: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

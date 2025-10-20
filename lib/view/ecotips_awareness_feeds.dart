import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// --- Data Model for an Eco Tip ---
class EcoTip {
  final String id;
  final String category;
  final String title;
  final String description;
  int likes;
  bool isLiked;
  final IconData icon;
  final Color iconColor;

  EcoTip({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.likes,
    this.isLiked = false,
    required this.icon,
    required this.iconColor,
  });
}

// --- Main App Entry Point ---

// --- The Main Screen Widget ---
class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  // --- Demo Data for the Tips Feed ---
  final List<EcoTip> _initialTips = [
    EcoTip(
      id: '1',
      category: 'Energy Saving',
      title: 'Switch off lights when not in use 🌍',
      description:
          'Save energy and reduce your carbon footprint by turning off lights when leaving a room. Small actions make a big difference!',
      likes: 24,
      icon: Icons.lightbulb_outline,
      iconColor: Colors.blue.shade300,
    ),
    EcoTip(
      id: '2',
      category: 'Waste Reduction',
      title: 'Use cloth bags instead of plastic 🛍️',
      description:
          'Carry reusable cloth bags for shopping to reduce plastic waste. One cloth bag can replace hundreds of plastic bags over time.',
      likes: 18,
      icon: Icons.recycling_outlined,
      iconColor: Colors.green.shade400,
    ),
    EcoTip(
      id: '3',
      category: 'Waste Reduction',
      title: 'Segregate wet and dry waste 🗑️',
      description:
          'Proper waste segregation helps in efficient recycling and composting. Keep separate bins for wet and dry waste at home.',
      likes: 32,
      isLiked: true,
      icon: Icons.delete_outline,
      iconColor: Colors.grey.shade400,
    ),
  ];

  final List<EcoTip> _moreTips = [
    EcoTip(
      id: '4',
      category: 'Water Saving',
      title: 'Turn off tap while brushing 🚰',
      description:
          'Save up to 8 gallons of water per day by turning off the tap while brushing your teeth. Every drop counts for our planet!',
      likes: 41,
      icon: Icons.water_drop_outlined,
      iconColor: Colors.lightBlue.shade300,
    ),
    EcoTip(
      id: '5',
      category: 'Awareness',
      title: 'Plant a tree, breathe easier 🌳',
      description:
          'Trees absorb CO2 and produce oxygen. Planting just one tree can offset carbon emissions and improve air quality in your neighborhood.',
      likes: 67,
      icon: Icons.park_outlined,
      iconColor: Colors.orange.shade300,
    ),
  ];

  late List<EcoTip> _displayedTips;
  bool _moreTipsAvailable = true;

  @override
  void initState() {
    super.initState();
    _displayedTips = List.from(_initialTips);
  }

  // --- INTERACTIVE FUNCTIONALITY ---
  void _toggleLike(String tipId) {
    setState(() {
      final tip = _displayedTips.firstWhere((t) => t.id == tipId);
      if (tip.isLiked) {
        tip.likes--;
        tip.isLiked = false;
      } else {
        tip.likes++;
        tip.isLiked = true;
      }
    });
  }

  void _shareTip(EcoTip tip) {
    final textToShare =
        'Eco Tip: ${tip.title}\n\n${tip.description}\n\n#EcoFriendly #SustainableLiving';
    Share.share(textToShare);
  }

  void _loadMoreTips() {
    setState(() {
      _displayedTips.addAll(_moreTips);
      _moreTipsAvailable = false;
    });
  }

  void _addNewTip(String title, String description) {
    if (title.trim().isEmpty || description.trim().isEmpty) return;

    final newTip = EcoTip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: 'Community Tip',
      title: title,
      description: description,
      likes: 0,
      icon: Icons.people_outline,
      iconColor: Colors.purple.shade300,
    );

    setState(() {
      _displayedTips.insert(0, newTip);
    });

    Navigator.of(context).pop(); // Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTipSheet(context),
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Stack(
        children: [
          _buildDecorativeBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildHeader(),
                ..._displayedTips.map(
                  (tip) => TipCard(
                    tip: tip,
                    onLike: () => _toggleLike(tip.id),
                    onShare: () => _shareTip(tip),
                  ),
                ),
                if (_moreTipsAvailable) _buildMoreTipsButton(),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI WIDGETS ---
  Widget _buildDecorativeBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3FCE9), Color(0xFFF0FDF4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.green.shade200.withOpacity(1.0),
                    Colors.green.shade200.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderIcon(Icons.spa_outlined),
              const SizedBox(width: 16),
              _buildHeaderIcon(Icons.lightbulb_outline_rounded),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Eco Tips & Awareness',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14532D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily eco-friendly suggestions for a greener lifestyle',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return GlassmorphicContainer(
      blur: 10,
      borderRadius: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, color: const Color(0xFF16A34A), size: 28),
      ),
    );
  }

  Widget _buildMoreTipsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: _loadMoreTips,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 95, 200, 133),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'More Tips',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- NEW: Bottom sheet for adding a new tip ---
  void _showAddTipSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GlassmorphicContainer(
            blur: 20,
            borderRadius: 20,
            color: Colors.white.withOpacity(1.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Share a New Eco Tip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF14532D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Tip Title (e.g., "DIY Natural Cleaner")',
                      fillColor: Colors.white.withOpacity(0.6),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your tip here...',
                      fillColor: Colors.white.withOpacity(0.6),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _addNewTip(
                          titleController.text,
                          descriptionController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          172,
                          250,
                          202,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Tip',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 129, 204, 227),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Reusable Tip Card Widget ---
class TipCard extends StatelessWidget {
  final EcoTip tip;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const TipCard({
    super.key,
    required this.tip,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GlassmorphicContainer(
        blur: 15,
        borderRadius: 16,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(),
              const SizedBox(height: 12),
              Text(
                tip.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14532D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tip.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              _buildCardFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: tip.iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(tip.icon, color: tip.iconColor),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green.shade100.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tip.category,
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onLike,
          child: Row(
            children: [
              Icon(
                tip.isLiked ? Icons.favorite : Icons.favorite_border,
                color: tip.isLiked ? Colors.red : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                '${tip.likes}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onShare,
          icon: Icon(
            Icons.share_outlined,
            color: Colors.grey.shade700,
            size: 20,
          ),
          label: Text(
            'Share',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade200),
        ),
      ],
    );
  }
}

// --- Reusable Glassmorphic Container Widget ---
class GlassmorphicContainer extends StatelessWidget {
  final double blur;
  final double borderRadius;
  final Widget child;
  final Color color;

  const GlassmorphicContainer({
    super.key,
    required this.blur,
    required this.borderRadius,
    required this.child,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

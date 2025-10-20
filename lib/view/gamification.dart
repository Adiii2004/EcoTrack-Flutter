import 'package:flutter/material.dart';
import 'dart:math' as math;

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;
  late final AnimationController _particleController;

  late final AnimationController _badgeRotationController;

  final List<_Particle> _particles = [];
  final _rnd = math.Random();

  // Hardcoded current user rank for demonstration
  static const int currentUserRank = 5;

  @override
  void initState() {
    super.initState();

    // Pulse animation for points card
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Entry animation for main content
    _entryController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _entryController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _entryController.forward();

    // Rotating background
    _rotationController = AnimationController(duration: const Duration(seconds: 40), vsync: this)
      ..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_rotationController);

    // Particle controller for continuous floating particles
    _particleController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 60))
          ..addListener(_onParticleTick)
          ..repeat();

    // Create some particles with percentage positions (dx, dy between -0.2..1.2 to allow offscreen start)
    for (int i = 0; i < 28; i++) {
      _particles.add(_Particle.random(_rnd));
    }

    // Rotation controller for recycle badge icon
    _badgeRotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  void _onParticleTick() {
    for (var p in _particles) {
      p.dy -= p.speed; // move up
      p.angle += p.rotationSpeed;
      // fade and wrap around
      p.opacity = (0.4 + 0.6 * math.sin(p.age * 0.3)).clamp(0.15, 0.9);
      p.age += 0.02;

      if (p.dy < -0.2) {
        // respawn near bottom with new dx
        p.dy = 1.2 + _rnd.nextDouble() * 0.2;
        p.dx = _rnd.nextDouble();
        p.size = (10 + _rnd.nextDouble() * 18);
        p.speed = 0.002 + _rnd.nextDouble() * 0.006;
        p.rotationSpeed = (-0.02 + _rnd.nextDouble() * 0.04);
      }
    }
    // small rebuild
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _badgeRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // screen size for particle positioning
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Stack(
        children: [
          // Rotating background circle (glossy)
          RotationTransition(
            turns: _rotationAnimation,
            child: Transform.translate(
              offset: const Offset(-80, -80),
              child: Container(
                width: 520,
                height: 520,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.green.shade300.withOpacity(0.35), const Color(0xFFE8F5E9)],
                    radius: 0.6,
                  ),
                ),
              ),
            ),
          ),

          // continuous floating eco particles (positions computed from dx/dy percentage)
          ..._particles.map((p) {
            final left = (p.dx * size.width).clamp(-60.0, size.width + 60.0);
            final top = (p.dy * size.height).clamp(-120.0, size.height + 120.0);
            return Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: p.opacity,
                child: Transform.rotate(
                  angle: p.angle,
                  child: Icon(
                    p.icon,
                    size: p.size,
                    color: p.color.withOpacity(0.9),
                  ),
                ),
              ),
            );
          }),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildUserCard(),
                      const SizedBox(height: 20),
                      _buildProgressCard(),
                      const SizedBox(height: 24),
                      _buildLeaderboardSection(),
                      const SizedBox(height: 24),
                      _buildBadgesSection(), // badges section with rotating recycle
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                      const SizedBox(height: 120), // extra spacing for FAB
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // ---------- UI pieces ----------

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.yellow.shade400, Colors.orange.shade300]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 10)],
          ),
          child: const Icon(Icons.emoji_events, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Gamification & Leaderboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _frostedBox(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 20, spreadRadius: 3)],
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sarah Green',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Eco Warrior', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF2196F3)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.6), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Column(
                children: [
                  Text('2,450', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Eco Points', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _frostedBox() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.8)]),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
      boxShadow: [
        BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
        BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 2, offset: const Offset(-2, -2)),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _frostedBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progress to Next-tier (Eco Hero)',
              style: TextStyle(fontSize: 14, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(height: 12, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10))),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1200),
                tween: Tween<double>(begin: 0.0, end: 0.8),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.6), blurRadius: 8, offset: const Offset(2, 0))],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('2,450 / 3,000', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    final userList = [
      {'rank': 4, 'name': 'John Davis', 'points': '2,550 pts', 'isUser': false},
      {'rank': 5, 'name': 'Sarah Green', 'points': '2,450 pts', 'isUser': true},
      {'rank': 6, 'name': 'Jane Doe', 'points': '2,100 pts', 'isUser': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF66BB6A), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.leaderboard, color: Colors.white, size: 20)),
            const SizedBox(width: 8),
            const Text('Leaderboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 16),
        _buildPodium(),
        const SizedBox(height: 16),
        const Text(
          'Your Position',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        const SizedBox(height: 10),
        ...userList.map((item) => _buildLeaderboardItem(
              item['rank'] as int,
              item['name'] as String,
              item['points'] as String,
              item['isUser'] as bool,
            )),
      ],
    );
  }

  Widget _buildPodium() {
    return SizedBox(
      height: 215,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPlace(2, 'Mike Chen', '2,891 pts', 100, Colors.grey.shade400),
          _buildPodiumPlace(1, 'Emma Wilson', '3,245 pts', 130, const Color(0xFFFFD700)),
          _buildPodiumPlace(3, 'Alex Kumar', '2,654 pts', 80, const Color(0xFFCD7F32)),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(int rank, String name, String points, double height, Color color) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
              radius: 22,
              backgroundColor: color,
              child: Text('$rank',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(points, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.8), color]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 5))],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, String points, bool isUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUser
              ? [const Color(0xFFC8E6C9).withOpacity(0.95), const Color(0xFFA5D6A7).withOpacity(0.9)]
              : [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUser ? const Color(0xFF66BB6A) : Colors.white.withOpacity(0.6),
          width: isUser ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
              color: isUser ? Colors.green.withOpacity(0.16) : Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF66BB6A) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${rank + 15}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUser ? const Color(0xFF2E7D32) : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              color: isUser ? const Color(0xFF2E7D32) : Colors.grey.shade600,
              fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF66BB6A), borderRadius: BorderRadius.circular(10)),
              child: const Text('You', style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    final badges = [
      {'icon': Icons.recycling, 'label': 'Eco Advocate', 'color': Colors.green, 'earned': true},
      {'icon': Icons.water_drop, 'label': 'Water Saver', 'color': Colors.blue, 'earned': true},
      {'icon': Icons.energy_savings_leaf, 'label': 'Green Energy', 'color': Colors.lightBlue, 'earned': false},
      {'icon': Icons.emoji_events, 'label': 'Waste Warrior', 'color': Colors.teal, 'earned': true},
      {'icon': Icons.star, 'label': 'Daily Streak', 'color': Colors.orange, 'earned': false},
      {'icon': Icons.workspace_premium, 'label': 'Community Hero', 'color': Colors.amber, 'earned': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFFB74D), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.military_tech, color: Colors.white, size: 20)),
            const SizedBox(width: 8),
            const Text('Your Badges',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: badges
              .map((b) => _buildBadge(
                  b['icon'] as IconData, b['label'] as String, b['color'] as Color, b['earned'] as bool))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color, bool earned) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: earned
                  ? [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.75)]
                  : [Colors.grey.shade200.withOpacity(0.7), Colors.grey.shade300.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: earned ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3), width: 2),
          boxShadow: [BoxShadow(color: earned ? color.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: earned ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
            child: icon == Icons.recycling
                ? RotationTransition(
                    turns: _badgeRotationController,
                    child: Icon(icon, color: earned ? color : Colors.grey, size: 24),
                  )
                : Icon(icon, color: earned ? color : Colors.grey, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: earned ? Colors.black87 : Colors.grey),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(children: [
      _buildGlossyButton('View My Progress', const Color(0xFF66BB6A), Icons.trending_up),
      const SizedBox(height: 12),
      _buildGlossyButton('How to Earn Points?', const Color(0xFFF0F0F0), Icons.help_outline,
          textColor: const Color(0xFF2E7D32)),
    ]);
  }

  Widget _buildGlossyButton(String text, Color color, IconData icon, {Color textColor = Colors.white}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.95), color.withOpacity(0.85), color.withOpacity(0.95)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          ]),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF81C784), Color(0xFF4CAF50)]),
          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.7), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: const Center(child: Icon(Icons.add, color: Colors.white, size: 28)),
        ),
      ),
    );
  }
}

/// Particle model (position percentages from 0..1)
class _Particle {
  double dx; // 0..1 (left)
  double dy; // 0..1 (top)
  double size;
  double speed; // movement per tick in dy
  double rotationSpeed;
  double angle;
  double opacity;
  double age;
  IconData icon;
  Color color;
  final _rnd = math.Random();

  _Particle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.speed,
    required this.rotationSpeed,
    required this.angle,
    required this.opacity,
    required this.age,
    required this.icon,
    required this.color,
  });

  factory _Particle.random(math.Random rnd) {
    final icons = [Icons.eco, Icons.park, Icons.grass, Icons.emoji_events, Icons.local_florist];
    final colors = [Colors.green.shade300, Colors.lightGreen.shade400, Colors.teal.shade300, Colors.lime.shade400];

    return _Particle(
      dx: rnd.nextDouble(),
      dy: 0.6 + rnd.nextDouble() * 0.6,
      size: 8 + rnd.nextDouble() * 22,
      speed: 0.002 + rnd.nextDouble() * 0.007,
      rotationSpeed: -0.03 + rnd.nextDouble() * 0.06,
      angle: rnd.nextDouble() * math.pi * 2,
      opacity: 0.2 + rnd.nextDouble() * 0.7,
      age: rnd.nextDouble() * 10.0,
      icon: icons[rnd.nextInt(icons.length)],
      color: colors[rnd.nextInt(colors.length)],
    );
  }

  void update() {}
}

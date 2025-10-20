import 'package:flutter/material.dart';
import 'dart:math';

//import 'marketplace.dart';
import 'view/marketplace.dart';

void main() {
  runApp(const EcoOrderApp());
}

class EcoOrderApp extends StatelessWidget {
  const EcoOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderSuccessScreen(),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF388E3C);
    const Color accentGreen = Color(0xFF66BB6A);
    const Color lightBackground = Color(0xFFF1F8E9);

    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Confetti Success Icon
                        ConfettiSuccessIcon(),
                        const SizedBox(height: 25),
                        const Text(
                          'Order Placed\nSuccessfully!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Thank you for supporting sustainable living. Your eco-friendly product will arrive soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  DeliveryInformationCard(primaryGreen: primaryGreen, accentGreen: accentGreen),
                  const SizedBox(height: 20),
                  EcoImpactCard(primaryGreen: primaryGreen),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: const Text('View My Orders',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EcoMarketplaceScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.store_outlined, color: primaryGreen),
                        label: Text('Back to Marketplace',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Share your eco-friendly purchase',
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SocialShareRow(primaryGreen: primaryGreen),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- Confetti Success Icon -------------------
class ConfettiSuccessIcon extends StatefulWidget {
  const ConfettiSuccessIcon({super.key});

  @override
  State<ConfettiSuccessIcon> createState() => _ConfettiSuccessIconState();
}

class _ConfettiSuccessIconState extends State<ConfettiSuccessIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> particles = [];
  final Random random = Random();
  final int particleCount = 70;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenHeight = MediaQuery.of(context).size.height;
      for (int i = 0; i < particleCount; i++) {
        particles.add(ConfettiParticle(random, screenHeight));
      }
      _controller = AnimationController(vsync: this, duration: const Duration(seconds: 100))
        ..addListener(() {
          setState(() {
            for (var p in particles) {
              p.update();
            }
          });
        })
        ..repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none, // allow particles to overflow
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
              ),
              child: const Center(
                child: Icon(Icons.check_circle, color: Color(0xFF388E3C), size: 90),
              ),
            ),
          ),
          // Full screen confetti overlay
          ...particles.map((p) {
            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + p.x - 60, // center + offset
              top: p.y,
              child: Transform.rotate(
                angle: p.rotation,
                child: Container(
                  width: p.size,
                  height: p.size,
                  color: p.color,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  final Random random;
  double x = 0;
  double y = 0;
  double dx = 0;
  double dy = 0;
  double size = 4;
  double rotation = 0;
  double rotationSpeed = 0;
  Color color = Colors.red;
  final double screenHeight;

  ConfettiParticle(this.random, this.screenHeight) {
    reset();
  }

  void reset() {
    x = (random.nextDouble() - 0.5) * 200; // spread
    y = -10; // start above icon
    dx = (random.nextDouble() - 0.5) * 2;
    dy = 1 + random.nextDouble() * 3;
    size = 4 + random.nextDouble() * 6;
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.1;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)];
  }

  void update() {
    x += dx;
    y += dy;
    rotation += rotationSpeed;

    if (y > screenHeight) {
      reset();
    }
  }
}




// ---------------------- Delivery Info ----------------------
class DeliveryInformationCard extends StatelessWidget {
  final Color primaryGreen;
  final Color accentGreen;
  const DeliveryInformationCard({super.key, required this.primaryGreen, required this.accentGreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 5,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping_outlined, color: primaryGreen),
                const SizedBox(width: 8),
                const Text(
                  'Delivery Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text('Your order is being prepared', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [accentGreen.withOpacity(0.7), accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentGreen.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Estimated Delivery',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(width: 15),
                  Text('2-3 Days',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order ID', style: TextStyle(color: Colors.black54)),
                Text('#ECO2024001', style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Eco Impact ----------------------
class EcoImpactCard extends StatelessWidget {
  final Color primaryGreen;
  const EcoImpactCard({super.key, required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryGreen.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(color: primaryGreen.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.public, color: primaryGreen, size: 30),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eco Impact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('You\'ve helped reduce 2.5kg of carbon footprint with this purchase!',
                    style: TextStyle(color: Colors.black87, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Social Share ----------------------
class SocialShareRow extends StatelessWidget {
  final Color primaryGreen;
  const SocialShareRow({super.key, required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.chat, primaryGreen),
        const SizedBox(width: 15),
        _buildSocialIcon(Icons.facebook, primaryGreen),
        const SizedBox(width: 15),
        _buildSocialIcon(Icons.camera_alt, primaryGreen),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

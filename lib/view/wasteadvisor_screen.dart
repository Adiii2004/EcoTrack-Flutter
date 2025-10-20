import 'package:flutter/material.dart';

void main() {
  runApp(const WasteDisposalApp());
}

class WasteDisposalApp extends StatelessWidget {
  const WasteDisposalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Disposal Advisor',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const WasteDisposalHome(),
    );
  }
}

class WasteDisposalHome extends StatefulWidget {
  const WasteDisposalHome({super.key});

  @override
  State<WasteDisposalHome> createState() => _WasteDisposalHomeState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String? itemType;
  final IconData? icon;
  final Color? color;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.itemType,
    this.icon,
    this.color,
  });
}

class _WasteDisposalHomeState extends State<WasteDisposalHome> {
  final TextEditingController _searchController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            '👋 Hello! I\'m your Waste Disposal Advisor.\n\nAsk me about any waste item and I\'ll guide you on proper disposal!',
        isUser: false,
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
    });

    _searchController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 600), () {
      String response = '';
      IconData? icon;
      Color? color;

      if (query.toLowerCase().contains('batter')) {
        icon = Icons.battery_alert;
        color = const Color(0xFFEF5350);
        response =
            '🔋 BATTERY - Hazardous Waste\n\n⚠️ NEVER throw in regular trash!\n\n✓ Take to battery collection centers\n✓ Electronics stores often accept them\n✓ Contains harmful chemicals\n✓ Can be recycled safely';
      } else if (query.toLowerCase().contains('peel') ||
          query.toLowerCase().contains('banana') ||
          query.toLowerCase().contains('organic') ||
          query.toLowerCase().contains('food')) {
        icon = Icons.spa;
        color = const Color(0xFF66BB6A);
        response =
            '🍌 ORGANIC WASTE - Compostable\n\n✓ Add to compost bin\n✓ Use organic waste bins\n✓ Makes great fertilizer\n✓ 100% eco-friendly disposal\n✓ Reduces landfill waste';
      } else if (query.toLowerCase().contains('oil')) {
        icon = Icons.water_drop;
        color = const Color(0xFF42A5F5);
        response =
            '🛢️ OIL - Hazardous Liquid\n\n⚠️ NEVER pour down drains!\n\n✓ Let it cool and solidify\n✓ Take to waste collection centers\n✓ Some centers convert to biodiesel\n✓ Can contaminate water if not disposed properly';
      } else if (query.toLowerCase().contains('plastic') ||
          query.toLowerCase().contains('bottle')) {
        icon = Icons.recycling;
        color = const Color(0xFF26A69A);
        response =
            '♻️ PLASTIC - Recyclable\n\n✓ Check recycling number (1-7)\n✓ Clean and dry before recycling\n✓ Remove caps and labels\n✓ Types 1, 2, 5 most recyclable\n✓ Place in recycling bin';
      } else if (query.toLowerCase().contains('glass')) {
        icon = Icons.wine_bar;
        color = const Color(0xFF8D6E63);
        response =
            '🍾 GLASS - 100% Recyclable\n\n✓ Rinse thoroughly\n✓ Remove caps and lids\n✓ Can be recycled infinitely\n✓ Separate by color if needed\n✓ Wrap broken glass safely';
      } else if (query.toLowerCase().contains('paper') ||
          query.toLowerCase().contains('cardboard') ||
          query.toLowerCase().contains('box')) {
        icon = Icons.description;
        color = const Color(0xFFFF9800);
        response =
            '📄 PAPER/CARDBOARD - Recyclable\n\n✓ Remove plastic coating\n✓ Flatten boxes\n✓ Keep dry and clean\n✓ Avoid greasy paper\n✓ Place in paper recycling';
      } else if (query.toLowerCase().contains('e-waste') ||
          query.toLowerCase().contains('electronic') ||
          query.toLowerCase().contains('phone') ||
          query.toLowerCase().contains('laptop')) {
        icon = Icons.devices;
        color = const Color(0xFF7E57C2);
        response =
            '💻 E-WASTE - Special Handling\n\n⚠️ Contains valuable & toxic materials\n\n✓ Take to e-waste collection centers\n✓ Many manufacturers accept old devices\n✓ Data should be wiped first\n✓ Can be refurbished or recycled';
      } else if (query.toLowerCase().contains('metal') ||
          query.toLowerCase().contains('can') ||
          query.toLowerCase().contains('aluminum')) {
        icon = Icons.inventory_2;
        color = const Color(0xFF78909C);
        response =
            '🥫 METAL/CANS - Recyclable\n\n✓ Rinse before recycling\n✓ Crush cans to save space\n✓ Aluminum infinitely recyclable\n✓ Saves 95% energy vs new metal\n✓ Place in metal recycling';
      } else {
        icon = Icons.help_outline;
        color = const Color(0xFF9E9E9E);
        response =
            '🤔 Not sure about that item.\n\nTry asking about:\n• Battery\n• Organic waste / Food\n• Oil\n• Plastic / Bottles\n• Glass\n• Paper / Cardboard\n• E-waste / Electronics\n• Metal / Cans';
      }

      setState(() {
        _messages.add(
          ChatMessage(text: response, isUser: false, icon: icon, color: color),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4CAF50),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.recycling, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waste Disposal Advisor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildQuickSuggestions(),
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildChip('🔋 Battery', 'Battery'),
            _buildChip('🍌 Organic', 'Banana Peel'),
            _buildChip('🛢️ Oil', 'Oil'),
            _buildChip('♻️ Plastic', 'Plastic'),
            _buildChip('🍾 Glass', 'Glass'),
            _buildChip('📄 Paper', 'Paper'),
            _buildChip('💻 E-waste', 'Phone'),
            _buildChip('🥫 Metal', 'Aluminum can'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String searchText) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFFE8F5E9),
        side: const BorderSide(color: Color(0xFF4CAF50), width: 1),
        onPressed: () {
          _searchController.text = searchText;
          _handleSearch(searchText);
        },
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: message.color ?? const Color(0xFF4CAF50),
              radius: 18,
              child: Icon(
                message.icon ?? Icons.eco,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF4CAF50) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Color(0xFF81C784),
              radius: 18,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _handleSearch,
                  decoration: const InputDecoration(
                    hintText: 'Ask about any waste item...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 22),
                onPressed: () => _handleSearch(_searchController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

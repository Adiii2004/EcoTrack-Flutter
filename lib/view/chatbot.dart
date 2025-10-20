import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

// --- Gemini API Key ---
// IMPORTANT: Move this to environment variables or secure storage in production!
const String _geminiApiKey =
    'AIzaSyC1mm6bgA2hMfWi9KWdytRDOf9R_Mg8stE'; // Replace with your valid key

// --- Color Palette ---
const Color kBackgroundColorStart = Color(0xFFE3F3F3);
const Color kBackgroundColorEnd = Color(0xFFD7F0E8);
const Color kBotBubbleColor = Color(0xFFFFFFFF);
const Color kUserBubbleColor = Color(0xFF2DB684);
const Color kQuickReplyColor = Color(0xFFFFFFFF);
const Color kSendButtonColor = Color(0xFF2DB684);
const Color kTextFieldBackgroundColor = Color(0xFFFFFFFF);
const Color kAppBarTextColor = Color(0xFF333333);
const Color kHintTextColor = Color(0xFF888888);
const Color kOnlineStatusColor = Color(0xFF2DB684);

// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isAqiInfo;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isAqiInfo = false,
  });
}

// --- Chat Screen ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initial messages
    _messages.addAll([
      ChatMessage(
        text:
            "Hello! I'm EcoMate, your eco-friendly assistant. I'm here to help you with environmental questions, eco tips, and guide you through EcoTrack AI features! 🧘‍♀️",
        isUser: false,
      ),
      ChatMessage(
        text:
            "What would you like to know about today? You can ask me anything eco-related or use the quick options below!",
        isUser: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Send message
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    // Special handling for AQI question
    if (text.toLowerCase().contains('aqi')) {
      setState(() {
        _isLoading = false;
        _messages.add(
          ChatMessage(text: "AQI Info", isUser: false, isAqiInfo: true),
        );
      });
      _scrollToBottom();
      return;
    }

    final historyToSend = List<ChatMessage>.from(_messages);

    _getGeminiResponse(historyToSend)
        .then((response) {
          setState(() {
            _isLoading = false;
            _messages.add(ChatMessage(text: response, isUser: false));
          });
          _scrollToBottom();
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
            _messages.add(
              ChatMessage(
                text:
                    "Error: ${error.toString()}\n\nPlease check:\n1. Your API key is valid\n2. You have enabled the Gemini API\n3. Your internet connection",
                isUser: false,
              ),
            );
          });
          _scrollToBottom();
        });
  }

  // Gemini API request - SIMPLIFIED VERSION
  Future<String> _getGeminiResponse(
    List<ChatMessage> conversationHistory,
  ) async {
    try {
      // Get only the last user message for simpler request
      final lastUserMessage = conversationHistory.lastWhere(
        (msg) => msg.isUser && !msg.isAqiInfo,
      );

      // Using v1beta with gemini-pro (most stable and widely supported)
      const url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_geminiApiKey';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'You are EcoMate, a friendly environmental assistant. ${lastUserMessage.text}',
              },
            ],
          },
        ],
      };

      debugPrint('Sending request to Gemini API...');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract response text
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }

        return "I received your message but couldn't generate a proper response. Please try again.";
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Bad request';
        throw Exception('API Error (400): $errorMessage');
      } else if (response.statusCode == 403) {
        throw Exception(
          'API Key Error: Please get a new API key from https://aistudio.google.com/app/apikey',
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Model not found. Please check your API key is valid and created recently.',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Rate limit exceeded. Please wait a moment and try again.',
        );
      } else {
        throw Exception('API Error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in _getGeminiResponse: $e');
      rethrow;
    }
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBackgroundColorStart, kBackgroundColorEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _messages.length + (_isLoading ? 1 : 0) + 1,
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    final message = _messages[index];
                    if (message.isAqiInfo) return _buildAqiInfoMessage();
                    return message.isUser
                        ? _buildUserMessage(message.text)
                        : _buildBotMessage(message.text);
                  }
                  if (_isLoading && index == _messages.length) {
                    return _buildTypingIndicator();
                  }
                  return _buildQuickReplies();
                },
              ),
            ),
            _buildTextInputArea(),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.arrow_back, color: kAppBarTextColor),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF2DB684),
                  radius: 20,
                  child: SvgPicture.asset(
                    'assets/icons/bot_icon.svg',
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EcoMate',
                      style: TextStyle(
                        color: kAppBarTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Your Eco Assistant 🤖',
                      style: TextStyle(
                        color: kAppBarTextColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.info_outline, color: kAppBarTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBotMessage(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2DB684),
            radius: 16,
            child: SvgPicture.asset(
              'assets/icons/bot_icon.svg',
              height: 18,
              width: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: kBotBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, color: kAppBarTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 60),
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: kUserBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAqiInfoMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2DB684),
            radius: 16,
            child: SvgPicture.asset(
              'assets/icons/bot_icon.svg',
              height: 18,
              width: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: kBotBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AQI (Air Quality Index) measures air pollution levels from 0-500. 📊',
                    style: TextStyle(fontSize: 15, color: kAppBarTextColor),
                  ),
                  const SizedBox(height: 12),
                  _buildAqiLegendItem(Colors.green, '0-50: Good (Safe)'),
                  const SizedBox(height: 6),
                  _buildAqiLegendItem(Colors.orange, '51-100: Moderate'),
                  const SizedBox(height: 6),
                  _buildAqiLegendItem(Colors.red, '101+: Unhealthy'),
                  const SizedBox(height: 12),
                  const Text(
                    'High AQI can cause respiratory issues, especially in sensitive individuals.',
                    style: TextStyle(fontSize: 15, color: kAppBarTextColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAqiLegendItem(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: kAppBarTextColor),
        ),
      ],
    );
  }

  Widget _buildQuickReplies() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildQuickReplyChip('What is AQI?'),
          _buildQuickReplyChip('How to dispose plastic?'),
          _buildQuickReplyChip('File a Complaint'),
          _buildQuickReplyChip('Show my Eco Points'),
          _buildQuickReplyChip('Carbon Calculator'),
          _buildQuickReplyChip('Eco Tips'),
        ],
      ),
    );
  }

  Widget _buildQuickReplyChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _handleSubmitted(text),
      backgroundColor: kQuickReplyColor,
      labelStyle: const TextStyle(color: kAppBarTextColor, fontSize: 13),
      shape: const StadiumBorder(),
      elevation: 1,
      pressElevation: 3,
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2DB684),
            radius: 16,
            child: SvgPicture.asset(
              'assets/icons/bot_icon.svg',
              height: 18,
              width: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "EcoMate is typing...",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: kHintTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: kTextFieldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 4,
                  backgroundColor: kOnlineStatusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'EcoMate is online',
                  style: TextStyle(
                    color: kHintTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything eco-friend...',
                    hintStyle: const TextStyle(color: kHintTextColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.mic, color: kHintTextColor, size: 28),
              const SizedBox(width: 8),
              const Icon(Icons.attach_file, color: kHintTextColor, size: 28),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _handleSubmitted(_textController.text),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: kSendButtonColor,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
          SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Text(
                  'EN / मराठी',
                  style: TextStyle(
                    fontSize: 12,
                    color: kHintTextColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

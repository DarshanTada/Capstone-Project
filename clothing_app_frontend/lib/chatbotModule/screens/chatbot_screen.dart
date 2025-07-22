import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  File? _pickedImage;

  static const String systemPrompt =
      "You are a helpful fashion assistant, reply only to fashion related questions. Else say I can only help you with fashion related questions.";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    // Add user message to chat
    final userMsg = _ChatMessage(
      text: text,
      isUser: true,
      image: _pickedImage,
    );
    setState(() {
      _messages.add(userMsg);
      _controller.clear();
      _pickedImage = null;
      // Add a loading bot message
      _messages.add(_ChatMessage(
        text: "",
        isUser: false,
        isLoading: true,
      ));
    });

    // Scroll to bottom after short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Prepare image as base64 if present
    String? imageBase64;
    if (userMsg.image != null) {
      final bytes = await userMsg.image!.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    // Call backend API
    try {
      final response = await http.post(
        // Uri.parse('http://10.0.0.85:3001/api/ml/ask'),
        Uri.parse('https://naturally-giving-chow.ngrok-free.app/ask/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "question": text,
          "system_prompt": systemPrompt,
          "image_base64": imageBase64,
        }),
      );

      String botReply = "Sorry, I couldn't get a response.";
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        botReply = data['response'] ?? "Sorry, I couldn't get a response.";
      }

      setState(() {
        // Find the last loading bot message and replace it
        final idx = _messages.lastIndexWhere((m) => !m.isUser && m.isLoading);
        if (idx != -1) {
          _messages[idx] = _ChatMessage(
            text: botReply,
            isUser: false,
          );
        }
      });

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        final idx = _messages.lastIndexWhere((m) => !m.isUser && m.isLoading);
        if (idx != -1) {
          _messages[idx] = _ChatMessage(
            text: "Error: ${e.toString()}",
            isUser: false,
          );
        }
      });
    }
  }

  Widget _buildMessage(_ChatMessage msg) {
    final isUser = msg.isUser;
    final userBubbleColor = const Color(0xFFEAE0D5);
    final botBubbleColor = const Color(0xFFC6AC8E);

    final avatar = isUser
        ? CircleAvatar(
            backgroundColor: userBubbleColor,
            child: const Icon(Icons.person, color: Color.fromARGB(255, 77, 52, 52)),
          )
        : const CircleAvatar(
            backgroundColor: Colors.transparent, // transparent background
            backgroundImage: AssetImage('assets/images/ai_avatar.png'),
          );

    final bubbleColor = isUser ? userBubbleColor : botBubbleColor;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isUser
        ? const EdgeInsets.only(left: 100, top: 8, right: 8) // Increase left margin for user
        : const EdgeInsets.only(right: 80, top: 8, left: 8);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Gap from left edge for bot
            child: avatar,
          ),
        Expanded(
          child: Container(
            margin: margin,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: align,
              children: [
                if (msg.image != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        msg.image!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: msg.isLoading
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              ),
                            )
                          : SelectableText(
                              msg.text,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                    ),
                    if (!msg.isLoading)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: 'Copy',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: msg.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message copied!')),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isUser)
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Gap from right edge for user
            child: avatar,
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Add initial chatbot message
    _messages.add(_ChatMessage(
      text: "Hi I am YOLO Bot. How can I help you with your fashion needs?",
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "YOLO Bot",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Chat messages
          Padding(
            padding: const EdgeInsets.only(bottom: 76), // Height of input bar + margin
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, idx) => _buildMessage(_messages[idx]),
                  ),
                ),
                if (_pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _pickedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _pickedImage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Floating input bar
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: _buildInputBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Rounded borders
          border: Border.all(color: Colors.black, width: 1), // 1px black border
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image, color: Colors.black54),
              onPressed: _pickImage,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Enter your message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final File? image;
  final bool isLoading;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.image,
    this.isLoading = false,
  });
}
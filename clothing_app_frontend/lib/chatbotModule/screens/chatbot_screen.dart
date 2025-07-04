import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

  bool _isLoading = false;

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
    final userMsg = _ChatMessage(text: text, isUser: true, image: _pickedImage);
    setState(() {
      _messages.add(userMsg);
      _controller.clear();
      _pickedImage = null;
      _isLoading = true;
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
        Uri.parse('http://localhost:3001/api/ml/ask'),
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
        _messages.add(_ChatMessage(text: botReply, isUser: false));
        _isLoading = false;
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
        _messages.add(
          _ChatMessage(text: "Error: ${e.toString()}", isUser: false),
        );
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(_ChatMessage msg) {
    final isUser = msg.isUser;
    final avatar = isUser
        ? const CircleAvatar(child: Icon(Icons.person))
        : const CircleAvatar(
            backgroundImage: AssetImage('assets/images/ai_avatar.png'),
          );

    final bubbleColor = isUser ? Colors.grey[200] : Colors.blue[100];
    final align = isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final margin = isUser
        ? const EdgeInsets.only(right: 60, top: 8, left: 8)
        : const EdgeInsets.only(left: 60, top: 8, right: 8);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        if (isUser) avatar,
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
                Text(
                  msg.text,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        if (!isUser) avatar,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fashion AI Assistant"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) => _buildMessage(_messages[idx]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Divider(height: 1),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: Colors.white,
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
                  hintText: "Ask me anything fashion!",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: _isLoading ? null : _sendMessage,
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

  _ChatMessage({required this.text, required this.isUser, this.image});
}

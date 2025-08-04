import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

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
    final userBubbleColor = Color(0xFFD2B193);
    final botBubbleColor = Colors.white;

    final avatar = isUser
        ? Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          )
        : Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFD2B193), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.smart_toy, color: Color(0xFFB8956A), size: 20),
          );

    final bubbleColor = isUser ? userBubbleColor : botBubbleColor;
    final textColor = isUser ? Colors.white : Colors.black87;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isUser
        ? const EdgeInsets.only(left: 60, top: 8, right: 16, bottom: 4)
        : const EdgeInsets.only(right: 60, top: 8, left: 16, bottom: 4);

    return Container(
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) avatar,
          if (!isUser) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20 : 4),
                  topRight: Radius.circular(isUser ? 4 : 20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: align,
                children: [
                  if (msg.image != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          msg.image!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: msg.isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFB8956A),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Thinking...",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SelectableText(
                                msg.text,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                      ),
                      if (!msg.isLoading && msg.text.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: msg.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Message copied!'),
                                  backgroundColor: Color(0xFFB8956A),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy,
                                size: 16,
                                color: isUser 
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8),
          if (isUser) avatar,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Add initial chatbot message
    _messages.add(_ChatMessage(
      text: "👋 Hi! I'm YOLO Bot, your personal fashion assistant.\n\nI can help you with:\n• Style recommendations\n• Outfit suggestions\n• Fashion trends\n• Clothing advice\n\nFeel free to send me images of outfits for analysis!",
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
            Text(
              "YOLO Bot",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.brown.shade300),
            onPressed: () {
              // Add menu functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: _messages.length,
              itemBuilder: (context, idx) => _buildMessage(_messages[idx]),
            ),
          ),
          if (_pickedImage != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD2B193), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _pickedImage!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Image selected",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Ready to analyze",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red.shade400),
                    onPressed: () {
                      setState(() {
                        _pickedImage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Color(0xFFD2B193), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFD2B193).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.image_outlined, color: Color(0xFFB8956A)),
                onPressed: _pickImage,
                tooltip: 'Add Image',
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ask me anything about fashion...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: TextStyle(fontSize: 15),
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _sendMessage,
                tooltip: 'Send Message',
              ),
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
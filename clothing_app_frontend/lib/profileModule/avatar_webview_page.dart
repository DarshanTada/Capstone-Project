import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarWebViewPage extends StatefulWidget {
  final String avatarUrl;

  const AvatarWebViewPage({super.key, required this.avatarUrl});

  @override
  State<AvatarWebViewPage> createState() => _AvatarWebViewPageState();
}

class _AvatarWebViewPageState extends State<AvatarWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.avatarUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your 3D Avatar')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

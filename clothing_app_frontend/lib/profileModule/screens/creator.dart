import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarCreatorPage extends StatelessWidget {
  const AvatarCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/iframe.html')
      ..addJavaScriptChannel('AvatarCreated', onMessageReceived: (msg) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar', msg.message);
        if (context.mounted) Navigator.pop(context);
      });

    return Scaffold(
      appBar: AppBar(title: const Text("Create Avatar")),
      body: WebViewWidget(controller: controller),
    );
  }
}
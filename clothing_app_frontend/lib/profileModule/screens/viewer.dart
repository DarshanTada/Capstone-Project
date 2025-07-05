import 'package:clothing_app_frontend/profileModule/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarViewerPage extends StatelessWidget {
  final ProfileData data;
  const AvatarViewerPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
  late final WebViewController controller;

controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(NavigationDelegate(
    onPageFinished: (_) {
      controller.runJavaScript('window.loadViewer("${data.avatarUrl}");');
    },
  ))
  ..loadFlutterAsset('assets/viewer.html');


    return Scaffold(
      appBar: AppBar(title: const Text("3D Avatar")),
      body: WebViewWidget(controller: controller),
    );
  }
}
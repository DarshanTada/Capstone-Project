import 'package:clothing_app_frontend/profileModule/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AvatarViewerPage extends StatelessWidget {
  final ProfileData? data;
  final String? directUrl;
  
  const AvatarViewerPage({super.key, this.data, this.directUrl});

  // Static method to view 3D model with URL
  static void viewModel(BuildContext context, String modelUrl, {String title = "3D Model Viewer"}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarViewerPage(directUrl: modelUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final WebViewController controller;
    
    // Use directUrl if provided, otherwise use data.avatarUrl
    final String? urlToLoad = directUrl ?? data?.avatarUrl;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (urlToLoad != null) {
            controller.runJavaScript('window.loadViewer("$urlToLoad");');
          }
        },
      ))
      ..loadFlutterAsset('assets/viewer.html');

    return Scaffold(
      appBar: AppBar(
        title: Text(directUrl != null ? "Try On" : "3D Avatar"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
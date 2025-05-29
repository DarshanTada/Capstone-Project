// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:flutter_webview_pro/webview_flutter.dart';

// import 'circular_loader.dart';
// import 'custom_dialog.dart';

// class InAppBrowserScreen extends StatefulWidget {
//   const InAppBrowserScreen({super.key});

//   @override
//   State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
// }

// class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
//   bool isLoading = true;

//   bool iOSCondition(double dH) => Platform.isIOS && dH > 850;

//   WebViewController? controller;

//   String link = 'https://order.iteeha.coffee/';
//   setController() {
//     // controller = WebViewController()
//     //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     //   ..setBackgroundColor(const Color(0x00000000))
//     //   ..setNavigationDelegate(
//     //     NavigationDelegate(
//     //       onPageStarted: (String url) {
//     //         if (isLoading) setState(() => isLoading = false);
//     //       },
//     //       onNavigationRequest: (NavigationRequest request) {
//     //         return NavigationDecision.navigate;
//     //       },
//     //       onUrlChange: (change) {},
//     //     ),
//     //   )
//     //   ..loadRequest(Uri.parse(link));
//   }

//   Future<bool> goBack() async {
//     bool canGoBack = await controller!.canGoBack();
//     if (canGoBack) {
//       controller!.goBack();
//     } else {
//       closeApp();
//     }
//     return false;
//   }

//   closeApp() {
//     return showDialog(
//       context: context,
//       builder: ((context) => CustomDialog(
//             title: "Are you sure you want to exit the application?",
//             noText: 'No',
//             yesText: 'Yes',
//             subTitle: '',
//             noFunction: () {
//               Navigator.of(context).pop();
//             },
//             yesFunction: () async {
//               Navigator.of(context).pop();
//               SystemNavigator.pop();
//             },
//           )),
//     );
//   }

//   requestCameraPermission() async {
//     var status = await Permission.camera.request();
//     if (status.isDenied) {
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (controller != null) controller!.clearCache();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dH = MediaQuery.of(context).size.height;
//     final dW = MediaQuery.of(context).size.width;

//     return WillPopScope(
//       onWillPop: () => goBack(),
//       child: Scaffold(
//         body:
//             // iOSCondition(dH) ? screenBody(dW) :
//             SafeArea(child: screenBody(dW)),
//       ),
//     );
//   }

//   screenBody(double dW) {
//     return Stack(
//       children: [
//         WebView(
//           initialUrl: link,
//           zoomEnabled: false,
//           javascriptMode: JavascriptMode.unrestricted,
//           onPageFinished: (String url) {
//             setState(() => isLoading = false);
//           },
//           onWebViewCreated: (WebViewController webViewController) {
//             controller = webViewController;
//           },
//         ),
//         if (isLoading) const CircularLoader()
//       ],
//     );
//   }
// }

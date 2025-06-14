// import 'package:flutter/material.dart';

// import '../../commonWidgets/circular_loader.dart';
// import '../../commonWidgets/custom_app_bar.dart';
// import '../../navigation/arguments.dart';

// class OpenMediaFullScreen extends StatefulWidget {
//   final OpenMediaFullScreenArguments args;
//   const OpenMediaFullScreen({super.key, required this.args});

//   @override
//   State<OpenMediaFullScreen> createState() => _OpenMediaFullScreenState();
// }

// class _OpenMediaFullScreenState extends State<OpenMediaFullScreen> {
//   double dW = 0.0;
//   double dH = 0.0;
//   double tS = 0.0;

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     dH = MediaQuery.of(context).size.height;
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;

//     return Scaffold(
//       appBar: CustomAppBar(dW: dW, bgColor: Colors.white),
//       body: Container(
//         width: dW,
//         height: dH,
//         color: Colors.white,
//         child: isLoading
//             ? const Center(child: CircularLoader())
//             : InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 1,
//                 maxScale: 5,
//                 child: Image.network(
//                   widget.args.url,
//                   height: dH,
//                   width: dW,
//                   fit: BoxFit.scaleDown,
//                   loadingBuilder: ((context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const CircularLoader(
//                       android: 0.07,
//                       iOS: 12,
//                       color: Colors.white,
//                     );
//                   }),
//                 ),
//               ),
//       ),
//     );
//   }
// }

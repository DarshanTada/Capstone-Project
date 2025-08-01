// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:flutter/material.dart';

// class CustomSmallProductCardGrid extends StatelessWidget {
//   final String imageUrl;
//   final VoidCallback onTap;
//   final String price;
//   final double rating;

//   double dW = 0.0;

//   CustomSmallProductCardGrid({
//     super.key,
//     required this.imageUrl,
//     required this.price,
//     required this.rating,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             // Product Image
//             // AssetSvgIcon(imageUrl, width: 116, height: 116),
//             // Image.network(imageUrl, fit: BoxFit.cover, width: 110, height: 116),
//             Image.asset(
//               imageUrl,
//               fit: BoxFit.cover,
//               width: dW * 0.29,
//               height: dW * 0.29,
//             ),
//             // Gradient Overlay
//             Container(
//               width: dW * 0.29,
//               alignment: Alignment.bottomCenter,
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black87],
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '\$${double.tryParse(price)?.toStringAsFixed(0) ?? price}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 10,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.yellow, size: 10),
//                       TextWidget(
//                         title: rating.toString(),
//                         fontSize: 10,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// custom_small_product_card_grid.dart

import 'dart:typed_data';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CustomSmallProductCardGrid extends StatelessWidget {
  final String? imageUrl; // Optional for base64
  final Uint8List? imageBytes; // Optional for base64
  final VoidCallback onTap;
  final String price;
  final double rating;

  const CustomSmallProductCardGrid({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.price,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double dW = MediaQuery.of(context).size.width;

    Widget imageWidget;
    if (imageBytes != null) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        width: dW * 0.29,
        height: dW * 0.29,
      );
    } else if (imageUrl != null && imageUrl!.startsWith('http')) {
      imageWidget = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: dW * 0.29,
        height: dW * 0.29,
      );
    } else {
      imageWidget = Image.asset(
        imageUrl ?? '',
        fit: BoxFit.cover,
        width: dW * 0.29,
        height: dW * 0.29,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            imageWidget,
            Container(
              width: dW * 0.29,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${double.tryParse(price)?.toStringAsFixed(0) ?? price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 10),
                      TextWidget(
                        title: rating.toString(),
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
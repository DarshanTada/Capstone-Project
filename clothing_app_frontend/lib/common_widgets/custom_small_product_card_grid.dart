import 'dart:ffi';

<<<<<<< HEAD
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
=======
>>>>>>> 4a4da36f0112d446b97bc2369b1858820091e63c
import 'package:flutter/material.dart';

class CustomSmallProductCardGrid extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  final String price;
  final double rating;

  double dW = 0.0;

  CustomSmallProductCardGrid({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Product Image
<<<<<<< HEAD
            // AssetSvgIcon(imageUrl, width: 116, height: 116),
            Image.network(imageUrl, fit: BoxFit.cover, width: 110, height: 116),
            // Gradient Overlay
            Container(
              width: dW * 0.29,
=======
            Image.network(imageUrl, fit: BoxFit.cover, width: 116, height: 116),
            // Gradient Overlay
            Container(
              width: 116,
>>>>>>> 4a4da36f0112d446b97bc2369b1858820091e63c
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
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(
                        rating.toString(),
                        style: const TextStyle(color: Colors.white),
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

import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';

class SimilarProductCard extends StatefulWidget {
  final String imagePath;
  final String productName;
  final VoidCallback? onTap;

  const SimilarProductCard({
    Key? key,
    required this.imagePath,
    required this.productName,
    this.onTap,
  }) : super(key: key);

  @override
  State<SimilarProductCard> createState() => _SimilarProductCardState();
}

class _SimilarProductCardState extends State<SimilarProductCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    double dW = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(right: dW * 0.05),
        width: 120,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            // Top fade
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black26, Colors.transparent],
                  ),
                ),
              ),
            ),
            // Bottom fade with product name
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: TextWidget(
                  title: widget.productName,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Like/Dislike button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
            // Rating badge (bottom left)
           ],
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './size_chart_screen.dart';

class CustomBigProductCardGridWidget extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBytes; // Optional for base64

  final VoidCallback onTap;
  final String price;
  final double rating;
  final String productName;

  const CustomBigProductCardGridWidget({
    super.key,
    this.imageUrl,
    required this.price,
    this.imageBytes,
    required this.rating,
    required this.onTap,
    required this.productName,
  });
  @override
  CustomBigProductCardGridWidgetState createState() =>
      CustomBigProductCardGridWidgetState();
}

class CustomBigProductCardGridWidgetState
    extends State<CustomBigProductCardGridWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Product Image with shimmer effect
              Container(
                width: dW * 0.55,
                height: dW * 0.605,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade200, Colors.grey.shade100],
                  ),
                ),

                child: widget.imageUrl != null
                    ? Image.asset(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        width: dW * 0.55,
                        height: dW * 0.605,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Image.memory(
                        widget.imageBytes!,
                        fit: BoxFit.cover,
                        width: dW * 0.55,
                        height: dW * 0.605,
                      ),
              ),

              // Top gradient overlay with product name and favorite
              Positioned(
                top: 0,
                child: Container(
                  width: dW * 0.55,
                  padding: EdgeInsets.all(dW * 0.03),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.025,
                            vertical: dW * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextWidget(
                            title: widget.productName,
                            fontSize: tS * 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: dW * 0.02),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(dW * 0.015),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              key: ValueKey<bool>(isFavourite),
                              color: isFavourite ? Colors.red : Colors.white,
                              size: tS * 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom gradient overlay with price, size chart, and rating
              Positioned(
                bottom: 0,
                child: Container(
                  width: dW * 0.55,
                  padding: EdgeInsets.all(dW * 0.03),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Price and Rating Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price with background
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: dW * 0.025,
                              vertical: dW * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextWidget(
                              title:
                                  '\$${double.tryParse(widget.price)?.toStringAsFixed(0) ?? widget.price}',
                              fontSize: tS * 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          // Rating with background
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: dW * 0.02,
                              vertical: dW * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 14),
                                SizedBox(width: 2),
                                TextWidget(
                                  title: widget.rating.toString(),
                                  fontSize: tS * 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: dW * 0.02),

                      // Size Chart Button
                      GestureDetector(
                        onTap: () {
                          SizeChartScreen.show(context);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.03,
                            vertical: dW * 0.02,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.straighten,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: dW * 0.015),
                              TextWidget(
                                title: language['sizeChart'] ?? 'Size Chart',
                                color: Colors.white,
                                fontSize: tS * 11,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(width: dW * 0.01),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Hover/Press effect overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: widget.onTap,
                    splashColor: Colors.white.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

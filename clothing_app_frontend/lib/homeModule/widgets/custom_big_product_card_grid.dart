import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/routes.dart';
import './size_chart_screen.dart';

class CustomBigProductCardGridWidget extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onTap;
  final String price;
  final double rating;
  final String productName;

  const CustomBigProductCardGridWidget({
    super.key,
    required this.imageUrl,
    required this.price,
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

  // likeUnlike() async {
  //   setState(() {
  //     widget.cafe.isLiked = !widget.cafe.isLiked;
  //   });
  //   final response =
  //       await Provider.of<CafeProvider>(context, listen: false).likeUnlike(
  //     body: {
  //       'cafe': widget.cafe.id,
  //       'like': widget.cafe.isLiked,
  //     },
  //     accessToken: user.accessToken,
  //   );

  //   if (!response['success']) {
  //     setState(() {
  //       widget.cafe.isLiked = !widget.cafe.isLiked;
  //     });
  //   }
  // }

  fetchData() async {}
  @override
  void initState() {
    super.initState();
    fetchData();
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Product Image
            // AssetSvgIcon(imageUrl, width: 116, height: 116),
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: dW * 0.55,
              height: dW * 0.605,
            ),
            Positioned(
              top: 0,
              child: Container(
                width: dW * 0.55,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(
                  horizontal: dW * 0.02,
                  vertical: dW * 0.025,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextWidget(
                        title: widget.productName,
                        fontSize: tS * 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: dW * 0.05),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
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
                          size: tS * 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: dW * 0.55,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(
                  left: dW * 0.02,
                  right: dW * 0.02,
                  bottom: dW * 0.025,
                  top: dW * 0.045,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      title:
                          '\$${double.tryParse(widget.price)?.toStringAsFixed(0) ?? widget.price}',
                      fontSize: tS * 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Prevent tap event from propagating to parent GestureDetector
                        // and only open the SizeChartScreen snackbar.
                        SizeChartScreen.show(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: EdgeInsets.only(bottom: dW * 0.02),
                        padding: EdgeInsets.symmetric(
                          horizontal: dW * 0.02,
                          vertical: dW * 0.018,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            0.3,
                          ), // semi-transparent background
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // rounded edges
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              title: language['sizeChart'],
                              color: Colors.white,
                              fontSize: tS * 10,
                            ),
                            SizedBox(width: dW * 0.02),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        TextWidget(
                          title: widget.rating.toString(),
                          fontSize: tS * 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

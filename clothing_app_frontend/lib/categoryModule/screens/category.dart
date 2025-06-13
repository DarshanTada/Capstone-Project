import 'dart:ffi';

import 'package:clothing_app_frontend/common_widgets/base_screen.dart';
import 'package:clothing_app_frontend/common_widgets/custom_small_product_card_grid.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends BaseScreen {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends BaseScreenState<CategoryScreen> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSmallProductCardGrid(
          imageUrl: 'https://picsum.photos/id/10/200/300',
          price: "90",
          rating: 4.5,
          onTap: () {
            print("Tapped on product");
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget? buildAppBar() {
    return AppBar(title: Text("Dashboard"));
  }
}

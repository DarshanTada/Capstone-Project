import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/provider/category_provider.dart';
import 'package:clothing_app_frontend/homeModule/screens/product_list_screen.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  int selectedCategoryIndex = 0;
  final TextEditingController searchController = TextEditingController();
  // final List<String> categories = ['all', 'men', 'women', 'boys', 'girls'];
  final List<String> productImages = [
    'assets/images/g1.png',
    'assets/images/g2.png',
    'assets/images/g3.png',
    'assets/images/g4.png',
    'assets/images/g5.png',
    'assets/images/g6.png',
    'assets/images/g1.png',
    'assets/images/g2.png',
    'assets/images/g3.png',
  ];
  fetchCategories() async {
    final response = await Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategory(
          // accessToken: User.accessToken,
          query: 'page=1&limit=10',
        );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  

  fetchData() async {
    await fetchCategories();
  }

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

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(title: 'Title', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    final categories = Provider.of<CategoryProvider>(context).categories;
    final getProductsByCategory =
        Provider.of<CategoryProvider>(context).categoryProducts;
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : GestureDetector(
              onTap: () => hideKeyBoard(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: dW * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.05),

                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldWithLabel(
                              controller: searchController,
                              border: 25,
                              backgroundColor: Color(0xffF2F2F2),
                              borderColor: Colors.transparent,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              label: '',
                              hintText: language['personalizedSearch'],
                              onChanged: (value) {},
                            ),
                          ),
                          SizedBox(width: dW * 0.025),

                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 22,
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: dW * 0.025),
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 22,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: dW * 0.49,
                          width: dW,
                          margin: EdgeInsets.only(
                            top: dW * 0.03,
                            bottom: dW * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'assets/images/corousel/home_section_1.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),

                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: List.generate(categories.length, (index) {
                    //       final isSelected = selectedCategoryIndex == index;
                    //       return GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             selectedCategoryIndex = index;
                    //           });
                    //         },
                    //         child: Container(
                    //           margin: EdgeInsets.only(
                    //             left: index == 0 ? dW * 0.05 : dW * 0.02,
                    //             right: index == categories.length - 1
                    //                 ? dW * 0.05
                    //                 : 0,
                    //           ),
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: dW * 0.05,
                    //             vertical: dW * 0.02,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             color: isSelected ? Colors.black : Colors.white,
                    //             borderRadius: BorderRadius.circular(25),
                    //             border: Border.all(
                    //               color: Colors.black,
                    //               width: 1.5,
                    //             ),
                    //           ),
                    //           child: TextWidget(
                    //             title: language[categories[index]],
                    //             fontSize: tS * 18,
                    //             color: isSelected ? Colors.white : Colors.black,
                    //           ),
                    //         ),
                    //       );
                    //     }),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                      margin: EdgeInsets.only(
                        bottom: dW * 0.03,
                        top: dW * 0.09,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextWidget(
                              title: language['popularProducts'],
                              fontSize: tS * 22,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: TextWidget(
                              title: language['viewAll'],
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: dW * 0.09),
                    TextWidget(
                      textAlign: TextAlign.center,
                      title: language['chicStartsHere'],
                      fontSize: tS * 22,
                    ),
                    SizedBox(height: dW * 0.05),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                      child: Wrap(
                        spacing: dW * 0.025,
                        runSpacing: dW * 0.04,
                        children: [
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                              child: Image.asset(
                                'assets/images/g1.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: Image.asset(
                                'assets/images/g2.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(70),

                                bottomRight: Radius.circular(70),
                              ),
                              child: Image.asset(
                                'assets/images/g3.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: Image.asset(
                              'assets/images/g4.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: Image.asset(
                                'assets/images/g6.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          CircleAvatar(
                            radius: 56,
                            backgroundImage: AssetImage('assets/images/g5.png'),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: Image.asset(
                                'assets/images/g4.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: Image.asset(
                              'assets/images/g5.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: dW * 0.275,
                            height: dW * 0.3125,

                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),

                                bottomLeft: Radius.circular(70),
                              ),
                              child: Image.asset(
                                'assets/images/g6.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: dW * 0.08),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Image.asset("assets/images/b1.png"),
                          SizedBox(width: dW * 0.03),
                          Image.asset("assets/images/b4.png"),
                        ],
                      ),
                    ),
                    SizedBox(height: dW * 0.05),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    title: 'You may like',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      push(
                                        NamedRoute.categoryRelationScreen,
                                        arguments:
                                            CategoryRelationScreenArguments(),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          title: "View all",
                                          fontSize: 15,
                                        ),
                                        SizedBox(width: dW * 0.01),
                                        Icon(Icons.arrow_forward_ios, size: 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: dW * 0.05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomSmallProductCardGrid(
                                    imageUrl: 'assets/images/g1.png',

                                    price: '50',
                                    rating: 3.9,
                                    onTap: () {
                                      push(
                                        NamedRoute.productDetailScreen,
                                        arguments:
                                            ProductDetailScreenArguments(),
                                      );

                                      //   }
                                    },
                                  ),
                                  CustomSmallProductCardGrid(
                                    imageUrl: 'assets/images/g1.png',

                                    price: '44',
                                    rating: 4.7,
                                    onTap: () {},
                                  ),
                                  CustomSmallProductCardGrid(
                                    imageUrl: 'assets/images/g1.png',

                                    price: '90',
                                    rating: 4.5,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              SizedBox(height: dW * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      CustomSmallProductCardGrid(
                                        imageUrl: 'assets/images/g1.png',
                                        price: '90',
                                        rating: 4.5,
                                        onTap: () {},
                                      ),
                                      SizedBox(height: dW * 0.02),

                                      CustomSmallProductCardGrid(
                                        imageUrl: 'assets/images/g1.png',
                                        price: '90',
                                        rating: 4.5,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: dW * 0.01),
                                  CustomBigProductCardGridWidget(
                                    productName: 'Charcoal Fade Jeans',
                                    imageUrl: 'assets/images/g1.png',

                                    price: '90',
                                    rating: 4.5,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              SizedBox(height: dW * 0.05),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
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
  final List<String> categories = ['all', 'men', 'women', 'boys', 'girls'];
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
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(title: 'Title', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
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

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          final isSelected = selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? dW * 0.05 : dW * 0.02,
                                right: index == categories.length - 1
                                    ? dW * 0.05
                                    : 0,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.05,
                                vertical: dW * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              child: TextWidget(
                                title: language[categories[index]],
                                fontSize: tS * 18,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
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
                          Image.asset("assets/images/b2.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

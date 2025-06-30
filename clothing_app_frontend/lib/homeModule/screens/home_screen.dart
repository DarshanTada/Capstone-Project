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
      backgroundColor:  Colors.white,
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
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: dW * 0.05),
          Row( children: [
            Expanded(
              child: CustomTextFieldWithLabel(
                border: 25,
              backgroundColor: Color(0xffF2F2F2),
              borderColor: Colors.transparent,
              prefixIcon: const Icon(Icons.search, color: Colors.grey)  ,
                label: '',
                hintText: 'Personalized Search',
                onChanged: (value) {
                  
                },
              ),
            ),
            SizedBox(width: dW * 0.025),
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 22,
              child: Icon(Icons.menu, color: Colors.white, size: 25),),
                SizedBox(width: dW * 0.025),
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 22,
              child: Icon(Icons.person, color: Colors.white, size: 25),),
          ],),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class TermsOfServicesScreen extends StatefulWidget {
  const TermsOfServicesScreen({Key? key}) : super(key: key);

  @override
  TermsOfServicesScreenState createState() => TermsOfServicesScreenState();
}

class TermsOfServicesScreenState extends State<TermsOfServicesScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
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

    return Scaffold(
      appBar: CustomAppBar(title: language['termsOfServices'], dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: dW * horizontalPaddingFactor,
                vertical: dW * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextWidget(
                    textAlign: TextAlign.center,
                    title: language['termsOfServices'],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  SizedBox(height: dW * 0.04),
                  TextWidget(
                    textAlign: TextAlign.start,
                    title: language['termsOfServicesDescription'],
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff3E3E3E),
                    fontSize: 16,
                  ),
                ],
              ),
            ),
    );
  }
}

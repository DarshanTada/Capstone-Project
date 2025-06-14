// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../common_functions.dart';
import '../../navigation/arguments.dart';
import '../providers/auth_provider.dart';

class PrivacyPolicyAndTcScreen extends StatefulWidget {
  final PrivacyPolicyAndTcScreenArguments args;

  const PrivacyPolicyAndTcScreen({Key? key, required this.args})
    : super(key: key);

  @override
  State<PrivacyPolicyAndTcScreen> createState() =>
      _PrivacyPolicyAndTcScreenState();
}

class _PrivacyPolicyAndTcScreenState extends State<PrivacyPolicyAndTcScreen> {
  Map language = {};
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  bool isLoading = false;

  String contentText = '';

  fetchContent() async {
    setState(() => isLoading = true);

    final response = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).getAppConfig([widget.args.contentType]);

    if (response['success']) {
      contentText = response['result'][0]['value'];
    } else {
      showSnackbar(response['message']);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      appBar: CustomAppBar(title: (widget.args.title), dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return isLoading
        ? const Center(child: CircularLoader())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: dW * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: dW * 0.03, right: dW * 0.03),
                  child: Html(data: contentText),
                ),
                SizedBox(height: dW * 0.1),
              ],
            ),
          );
  }
}

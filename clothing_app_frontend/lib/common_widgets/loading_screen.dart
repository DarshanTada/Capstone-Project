import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:provider/provider.dart';
import '../authModule/model/user_model.dart';
import '../authModule/providers/auth_provider.dart';
import '../common_functions.dart';
import '../navigation/arguments.dart';
import '../navigation/navigators.dart';

class LoadingScreen extends StatefulWidget {
  final LoadingScreenArguments args;
  const LoadingScreen({Key? key, required this.args}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;

  late User user;
  bool isLoading = true;

  // fetchCafeAndNavigate() async {
  //   final response =
  //       await Provider.of<CafeProvider>(context, listen: false).fetchCafeById(
  //     accessToken: user.accessToken,
  //     cafeType: widget.args.type,
  //     query: '?cafeId=${widget.args.featureId}&cafeType=${widget.args.type}',
  //   );
  //   if (response['success']) {
  //     return pushReplacement(NamedRoute.cafeDetailScreen,
  //         arguments: CafeDetailScreenArguments(cafe: response['cafe']));
  //   } else {
  //     showSnackbar('Cafe not found');
  //     pop();
  //     return {'success': false};
  //   }
  // }

  // fetchAndNavigateToActivity() async {
  //   final response =
  //       await Provider.of<DailyActivityProvider>(context, listen: false)
  //           .fetchSingleActivityById(
  //     query:
  //         '?activityId=${widget.args.featureId}&activityType=${widget.args.type}',
  //     activityType: widget.args.type,
  //     accessToken: user.accessToken,
  //   );

  //   if (response['success']) {
  //     return response;
  //   } else {
  //     showSnackbar('Activity not found');
  //     pop();
  //     return {'success': false};
  //   }
  // }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    // fetchCafeAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: dH,
        width: dW,
        child: CircularLoader(),
      ),
    );
  }
}

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  late double dW;
  late double dH;
  late double tS;
  late TextTheme textTheme;
  late Map language;

  bool isLoading = false;

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void showSnackBar(String message, {Color color = Colors.red, int duration = 2}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(message, softWrap: true),
        ),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    textTheme = Theme.of(context).textTheme;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    final body = SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : buildBody(context),
    );

    return Scaffold(
      appBar: buildAppBar(),
      body: iOSCondition(dH) ? body : SafeArea(child: body),
      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  // These can be overridden by subclasses:
  PreferredSizeWidget? buildAppBar() => AppBar(title: Text("Title"));
  Widget? buildBottomNavigationBar() => null;
  Widget? buildFloatingActionButton() => null;

  // Must be implemented by the child screen
  Widget buildBody(BuildContext context);
}



// !  NOTE: use inherited screen like this 


// class DashboardScreen extends BaseScreen {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends BaseScreenState<DashboardScreen> {
//   @override
//   Widget buildBody(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("dW: $dW, dH: $dH", style: textTheme.bodyText1),
//         ElevatedButton(
//           onPressed: () {
//             setLoading(true);
//             Future.delayed(Duration(seconds: 2), () {
//               setLoading(false);
//               showSnackBar("Done!", color: Colors.green);
//             });
//           },
//           child: Text("Test Loading & SnackBar"),
//         ),
//       ],
//     );
//   }

//   @override
//   PreferredSizeWidget? buildAppBar() {
//     return AppBar(title: Text("Dashboard"));
//   }
// }

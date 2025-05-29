// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ScreenLayout extends StatefulWidget {
//   const ScreenLayout({Key? key}) : super(key: key);

//   @override
//   ScreenLayoutState createState() => ScreenLayoutState();
// }

// class ScreenLayoutState extends State<ScreenLayout> {
//   double dH = 0.0;
//   double dW = 0.0;
//   double tS = 0.0;
    //  late User user;
//   Map language = {};
//   bool isLoading = false;
//   TextTheme get textTheme => Theme.of(context).textTheme;


//   fetchData() async {
//     setState(() => isLoading = true);
//     setState(() => isLoading = false);
//   }

//   @override
//   void initState() {
//     super.initState();

      // user = Provider.of<AuthProvider>(context, listen: false).user;
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     dH = MediaQuery.of(context).size.height;
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;

//     return Scaffold(
//       appBar: CustomAppBar(title: 'Title', dW: dW),
//       body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
//     );
//   }

//   screenBody() {
//     return SizedBox(
//       height: dH,
//       width: dW,
//       child: isLoading
//           ? const Center(child: CircularLoader())
//           : SingleChildScrollView(
//               padding: screenHorizontalPadding(dW),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: dW * 0.05),
//                 ],
//               ),
//             ),
//     );
//   }
// }

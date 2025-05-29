// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:household_user/common_functions.dart';
// import 'package:household_user/navigation/arguments.dart';
// import 'package:household_user/navigation/navigators.dart';
// import 'package:provider/provider.dart';
// import '../authModule/providers/auth_provider.dart';
// import '../navigation/routes.dart';

// class PolicyTextWidget extends StatelessWidget {
//   PolicyTextWidget({super.key});

//   double dW = 0.0;
//   double tS = 0.0;
//   Map language = {};
//   TextTheme get textTheme => Theme.of(bContext).textTheme;

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;

//     return GestureDetector(
//       onTap: () => push(NamedRoute.privacyPolicy,
//           arguments: PolicyScreenArguments(
//               type: 'PRIVACYPOLICY', title: language['t&c'])),
//       child: Container(
//         width: dW,
//         color: Colors.transparent,
//         child: Text.rich(
//           TextSpan(children: [
//             TextSpan(text: language['byContinueAgree'] + ' '),
//             TextSpan(
//                 text: language['tos'],
//                 style: const TextStyle(fontWeight: FontWeight.w700)),
//             TextSpan(text: ' ${language['and']}\n'),
//             TextSpan(
//                 text: language['privacyPolicy'],
//                 style: const TextStyle(fontWeight: FontWeight.w700)),
//           ]),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: tS * 10,
//             color: const Color(0xff9798A3),
//             letterSpacing: .5,
//             wordSpacing: .5,
//           ),
//         ),
//       ),
//     );
//   }
// }

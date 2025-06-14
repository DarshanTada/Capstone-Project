// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:clothing_app_frontend/authModule/model/user_model.dart';
// import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
// import 'package:clothing_app_frontend/colors.dart';
// import 'package:clothing_app_frontend/common_functions.dart';
// import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
// import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
// import 'package:clothing_app_frontend/common_widgets/empty_list_widget.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:clothing_app_frontend/navigation/arguments.dart';
// import 'package:clothing_app_frontend/navigation/navigators.dart';
// import 'package:clothing_app_frontend/navigation/routes.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';

// class SearchCafeScreen extends StatefulWidget {
//   const SearchCafeScreen({super.key});

//   @override
//   State<SearchCafeScreen> createState() => _SearchCafeScreenState();
// }

// class _SearchCafeScreenState extends State<SearchCafeScreen> {
//   //
//   Map language = {};
//   double dW = 0.0;
//   double tS = 0.0;
//   bool isLoading = false;
//   bool isSearchLoading = false;
//   TextTheme get textTheme => Theme.of(context).textTheme;
//   TextEditingController _searchController = TextEditingController();
//   FocusNode _searchFocusNode = FocusNode();
//   late User user;
//   Timer? _debounce;

//   // selectCafe(Cafe cafe) {
//   //   Provider.of<CafeProvider>(context, listen: false).selectCafe(cafe);
//   //   pushAndRemoveUntil(
//   //     NamedRoute.bottomNavBarScreen,
//   //     arguments: BottomNavArgumnets(),
//   //   );
//   // }

//   // fetchCafes() async {
//   //   final response = await Provider.of<CafeProvider>(context, listen: false)
//   //       .fetchCafe(
//   //         accessToken: user.accessToken,
//   //         query: 'search=${_searchController.text.trim()}',
//   //       );
//   //   if (!response['success']) {
//   //     showSnackbar(response['message']);
//   //   }
//   // }

//   init() async {
//     setState(() => isLoading = true);
//     await fetchCafes();
//     setState(() => isLoading = false);
//   }

//   search(_) async {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     if (_searchController.text.trim().length > 2) {
//       _debounce = Timer(const Duration(seconds: 1), () async {
//         setState(() => isSearchLoading = true);
//         await fetchCafes();
//         setState(() => isSearchLoading = false);

//         if (_debounce?.isActive ?? false) _debounce!.cancel();
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     user = Provider.of<AuthProvider>(context, listen: false).user;
//     init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;
//     final cafes = Provider.of<CafeProvider>(context).cafes;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: white,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => pop(),
//           child: const Icon(
//             Icons.arrow_back_outlined,
//             color: Colors.black,
//             size: 30,
//           ),
//         ),
//         title: TextWidget(
//           title: language['selectACafe'],
//           fontWeight: FontWeight.w500,
//           fontSize: 18,
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: dW * 0.03),
//               padding: screenHorizontalPadding(dW),
//               child: CustomTextFieldWithLabel(
//                 label: '',
//                 borderColor: greyBorderColor,
//                 controller: _searchController,
//                 focusNode: _searchFocusNode,
//                 hintText: language['srchByLocOrCafe'],
//                 prefixIcon: const Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: AssetSvgIcon('search_icon', color: lightGray),
//                 ),
//                 suffixIcon: IconButton(
//                   focusColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   onPressed: () {
//                     setState(() => _searchController.clear());
//                     fetchCafes();
//                   },
//                   icon: _searchController.text.isEmpty
//                       ? const SizedBox.shrink()
//                       : const Icon(Icons.clear, color: Colors.black87),
//                 ),
//                 onChanged: search,
//               ),
//             ),
//             SizedBox(height: dW * 0.05),
//             Expanded(
//               child: isSearchLoading || isLoading
//                   ? const CircularLoader()
//                   : cafes.isEmpty
//                   ? EmptyListWidget(
//                       text: _searchController.text.trim().isEmpty
//                           ? language['searchCafes']
//                           : language['noCafesFound'],
//                       topPadding: 0,
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.only(
//                         left: dW * horizontalPaddingFactor,
//                         right: dW * horizontalPaddingFactor,
//                       ),
//                       shrinkWrap: true,
//                       itemCount: cafes.length,
//                       // physics: const BouncingScrollPhysics(),
//                       itemBuilder: (context, i) => GestureDetector(
//                         onTap: () => selectCafe(cafes[i]),
//                         child: CafeWidget(
//                           key: ValueKey(cafes[i].id),
//                           cafe: cafes[i],
//                           showFavourite: false,
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

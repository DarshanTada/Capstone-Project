// import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
// import 'package:clothing_app_frontend/common_functions.dart';
// import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
// import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   SearchScreenState createState() => SearchScreenState();
// }

// class SearchScreenState extends State<SearchScreen> {
//   double dH = 0.0;
//   double dW = 0.0;
//   double tS = 0.0;
//   TextTheme customTextTheme = const TextTheme();
//   final TextEditingController searchController = TextEditingController();
//   Map language = {};
//   bool isLoading = false;
//   Set<int> selectedCategoryIndices = <int>{};
//   bool showPopularSearches = true;
//   bool isListening = false;
//   late stt.SpeechToText _speech;

//   final List<String> popularSearches = [
//     'White shorts',
//     'Baggy Jeans',
//     'Linen Shirts',
//     'Oversized T-shirts',
//   ];

//   final List<Map<String, String>> personalisedCollection = [
//     {'name': 'Baggy', 'image': 'assets/images/g1.png'},
//     {'name': 'Straight Fit', 'image': 'assets/images/g2.png'},
//     {'name': 'Carpenter', 'image': 'assets/images/g3.png'},
//   ];

//   final List<Map<String, String>> newArrivals = [
//     {'name': 'Baggy Jeans', 'image': 'assets/images/g1.png'},
//     {'name': 'Black Pants', 'image': 'assets/images/g2.png'},
//     {'name': 'Wide Leg Jeans', 'image': 'assets/images/g3.png'},
//     {'name': 'Cargo Pants', 'image': 'assets/images/g4.png'},
//     {'name': 'Denim Jeans', 'image': 'assets/images/g5.png'},
//     {'name': 'Green Cargo', 'image': 'assets/images/g6.png'},
//   ];

//   final List<Map<String, dynamic>> trending = [
//     {
//       'name': 'Charcoal Fade Jeans',
//       'price': '\$50',
//       'image': 'assets/images/g1.png',
//     },
//     {
//       'name': 'Charcoal Fade Jeans',
//       'price': '\$50',
//       'image': 'assets/images/g2.png',
//     },
//   ];

//   fetchData() async {
//     _speech = stt.SpeechToText();
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void _togglePreferences() {
//     setState(() {
//       showPopularSearches = !showPopularSearches;
//     });
//   }

//   void _startListening() async {
//     var status = await Permission.microphone.request();
//     if (status == PermissionStatus.granted) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             setState(() {
//               searchController.text = result.recognizedWords;
//             });
//           },
//           listenFor: Duration(seconds: 10),
//           pauseFor: Duration(seconds: 3),
//         );
//       }
//     }
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() => isListening = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     dH = MediaQuery.of(context).size.height;
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;
//     customTextTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
//     );
//   }

//   screenBody() {
//     return SizedBox(
//       height: dH,
//       width: dW,
//       child: isLoading
//           ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
//           : SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: dW * 0.05),
//                   // Search Bar Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextFieldWithLabel(
//                           controller: searchController,
//                           border: 25,
//                           backgroundColor: Color(0xffF2F2F2),
//                           borderColor: Colors.transparent,
//                           prefixIcon: const Icon(
//                             Icons.search,
//                             color: Colors.grey,
//                           ),
//                           label: '',
//                           hintText:
//                               language['personalizedSearch'] ??
//                               'Personalized Search',
//                           onChanged: (value) {},
//                         ),
//                       ),
//                       SizedBox(width: dW * 0.025),
//                       GestureDetector(
//                         onTap: _togglePreferences,
//                         child: Container(
//                           padding: EdgeInsets.all(dW * 0.02),
//                           decoration: BoxDecoration(
//                             color: showPopularSearches
//                                 ? Colors.black
//                                 : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: AssetSvgIcon(
//                             'preference_toggle',
//                             color: showPopularSearches
//                                 ? Colors.white
//                                 : Colors.grey[600],
//                             onTap: _togglePreferences,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: dW * 0.025),
//                       GestureDetector(
//                         onLongPressStart: (_) => _startListening(),
//                         onLongPressEnd: (_) => _stopListening(),
//                         child: Container(
//                           padding: EdgeInsets.all(dW * 0.02),
//                           decoration: BoxDecoration(
//                             color: isListening ? Colors.red : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: AssetSvgIcon(
//                             'speaker',
//                             color: isListening
//                                 ? Colors.white
//                                 : Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: dW * 0.05),

//                   // Popular Searches Section
//                   if (showPopularSearches) ...[
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: TextWidget(
//                         title: 'Popular Searches',
//                         fontSize: tS * 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: dW * 0.03),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: List.generate(popularSearches.length, (
//                           index,
//                         ) {
//                           final isSelected = selectedCategoryIndices.contains(
//                             index,
//                           );
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (isSelected) {
//                                   selectedCategoryIndices.remove(index);
//                                 } else {
//                                   selectedCategoryIndices.add(index);
//                                 }
//                               });
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(
//                                 left: index == 0 ? 0 : dW * 0.02,
//                                 right: index == popularSearches.length - 1
//                                     ? 0
//                                     : 0,
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: dW * 0.05,
//                                 vertical: dW * 0.02,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? Colors.black : Colors.white,
//                                 borderRadius: BorderRadius.circular(25),
//                                 border: Border.all(
//                                   color: Colors.black,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: TextWidget(
//                                 title: popularSearches[index],
//                                 fontSize: tS * 12,
//                                 color: isSelected ? Colors.white : Colors.black,
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                     SizedBox(height: dW * 0.08),
//                   ],

//                   // Personalised Collection Section
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextWidget(
//                         title: 'Personalised Collection',
//                         fontSize: tS * 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: dW * 0.03),
//                   SizedBox(
//                     height: dW * 0.35,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: personalisedCollection.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           width: dW * 0.25,
//                           margin: EdgeInsets.only(right: dW * 0.03),
//                           child: Column(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: Colors.grey[200],
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.asset(
//                                       personalisedCollection[index]['image']!,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                             return Container(
//                                               color: Colors.grey[300],
//                                               child: Icon(
//                                                 Icons.image,
//                                                 color: Colors.grey[600],
//                                               ),
//                                             );
//                                           },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: dW * 0.02),
//                               TextWidget(
//                                 title: personalisedCollection[index]['name']!,
//                                 fontSize: tS * 12,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: dW * 0.08),

//                   // New Arrivals Section
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextWidget(
//                         title: 'New Arrivals',
//                         fontSize: tS * 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           // Navigate to view all new arrivals
//                         },
//                         child: Row(
//                           children: [
//                             TextWidget(
//                               title: 'View all',
//                               fontSize: tS * 12,
//                               color: Colors.grey[600],
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: dW * 0.03),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: dW * 0.02,
//                       mainAxisSpacing: dW * 0.02,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemCount: newArrivals.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             newArrivals[index]['image']!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: Colors.grey[300],
//                                 child: Icon(
//                                   Icons.image,
//                                   color: Colors.grey[600],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: dW * 0.08),

//                   // Trending Section
//                   TextWidget(
//                     title: 'Trending',
//                     fontSize: tS * 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   SizedBox(height: dW * 0.03),
//                   SizedBox(
//                     height: dW * 0.6,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: trending.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           width: dW * 0.4,
//                           margin: EdgeInsets.only(right: dW * 0.03),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: Colors.grey[200],
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.asset(
//                                           trending[index]['image']!,
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                                 return Container(
//                                                   color: Colors.grey[300],
//                                                   child: Icon(
//                                                     Icons.image,
//                                                     color: Colors.grey[600],
//                                                   ),
//                                                 );
//                                               },
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 8,
//                                       right: 8,
//                                       child: Container(
//                                         padding: EdgeInsets.all(4),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white.withOpacity(0.8),
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.favorite_border,
//                                           size: 16,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: dW * 0.02),
//                               TextWidget(
//                                 title: trending[index]['name']!,
//                                 fontSize: tS * 12,
//                                 maxLines: 2,
//                               ),
//                               SizedBox(height: dW * 0.01),
//                               TextWidget(
//                                 title: trending[index]['price']!,
//                                 fontSize: tS * 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: dW * 0.05),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  final TextEditingController searchController = TextEditingController();
  Map language = {};
  bool isLoading = false;
  Set<int> selectedCategoryIndices = <int>{};
  bool showPersonalisedCollection = true;
  bool isListening = false;
  // late stt.SpeechToText _speech;

  final List<String> popularSearches = [
    'White shorts',
    'Baggy Jeans',
    'Linen Shirts',
    'Oversized T-shirts',
  ];

  final List<Map<String, String>> personalisedCollection = [
    {'name': 'Baggy', 'image': 'assets/images/g1.png'},
    {'name': 'Straight Fit', 'image': 'assets/images/g2.png'},
    {'name': 'Carpenter', 'image': 'assets/images/g3.png'},
  ];

  final List<Map<String, String>> newArrivals = [
    {'name': 'Baggy Jeans', 'image': 'assets/images/g1.png'},
    {'name': 'Black Pants', 'image': 'assets/images/g2.png'},
    {'name': 'Wide Leg Jeans', 'image': 'assets/images/g3.png'},
    {'name': 'Cargo Pants', 'image': 'assets/images/g4.png'},
    {'name': 'Denim Jeans', 'image': 'assets/images/g5.png'},
    {'name': 'Green Cargo', 'image': 'assets/images/g6.png'},
  ];

  final List<Map<String, dynamic>> trending = [
    {
      'name': 'Charcoal Fade Jeans',
      'price': '\$50',
      'image': 'assets/images/g1.png',
    },
    {
      'name': 'Charcoal Fade Jeans',
      'price': '\$50',
      'image': 'assets/images/g2.png',
    },
  ];

  fetchData() async {
    // _speech = stt.SpeechToText();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _togglePreferences() {
    setState(() {
      showPersonalisedCollection = !showPersonalisedCollection;
    });
  }

  // void _startListening() async {
  //   var status = await Permission.microphone.request();
  //   if (status == PermissionStatus.granted) {
  //     bool available = await _speech.initialize();
  //     if (available) {
  //       setState(() => isListening = true);
  //       _speech.listen(
  //         onResult: (result) {
  //           setState(() {
  //             searchController.text = result.recognizedWords;
  //           });
  //         },
  //         listenFor: Duration(seconds: 10),
  //         pauseFor: Duration(seconds: 3),
  //       );
  //     }
  //   }
  // }

  // void _stopListening() {
  //   _speech.stop();
  //   setState(() => isListening = false);
  // }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                  // Search Bar Row
                  Row(
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
                          hintText:
                              language['personalizedSearch'] ??
                              'Personalized Search',
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(width: dW * 0.025),
                      GestureDetector(
                        onTap: _togglePreferences,
                        child: Container(
                          padding: EdgeInsets.all(dW * 0.02),
                          decoration: BoxDecoration(
                            color: showPersonalisedCollection
                                ? Colors.black
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AssetSvgIcon(
                            'preference_toggle',
                            color: showPersonalisedCollection
                                ? Colors.white
                                : Colors.grey[600],
                            onTap: _togglePreferences,
                          ),
                        ),
                      ),
                      SizedBox(width: dW * 0.025),
                      GestureDetector(
                        // onLongPressStart: (_) => _startListening(),
                        // onLongPressEnd: (_) => _stopListening(),
                        child: Container(
                          padding: EdgeInsets.all(dW * 0.02),
                          decoration: BoxDecoration(
                            color: isListening ? Colors.red : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AssetSvgIcon(
                            'speaker',
                            color: isListening
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dW * 0.05),

                  // Popular Searches Section (Always visible)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      title: 'Popular Searches',
                      fontSize: tS * 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: dW * 0.03),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(popularSearches.length, (index) {
                        final isSelected = selectedCategoryIndices.contains(
                          index,
                        );
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedCategoryIndices.remove(index);
                              } else {
                                selectedCategoryIndices.add(index);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 0 : dW * 0.02,
                              right: index == popularSearches.length - 1
                                  ? 0
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
                              title: popularSearches[index],
                              fontSize: tS * 12,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: dW * 0.08),

                  // Personalised Collection Section (Toggle controlled)
                  if (showPersonalisedCollection) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          title: 'Personalised Collection',
                          fontSize: tS * 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: dW * 0.03),
                    SizedBox(
                      height: dW * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: personalisedCollection.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: dW * 0.25,
                            margin: EdgeInsets.only(right: dW * 0.03),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        personalisedCollection[index]['image']!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.grey[600],
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: dW * 0.02),
                                TextWidget(
                                  title: personalisedCollection[index]['name']!,
                                  fontSize: tS * 12,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: dW * 0.08),
                  ],

                  // New Arrivals Section (Always visible)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        title: 'New Arrivals',
                        fontSize: tS * 16,
                        fontWeight: FontWeight.w600,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to view all new arrivals
                        },
                        child: Row(
                          children: [
                            TextWidget(
                              title: 'View all',
                              fontSize: tS * 12,
                              color: Colors.grey[600],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dW * 0.03),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: dW * 0.02,
                      mainAxisSpacing: dW * 0.02,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: newArrivals.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            newArrivals[index]['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: dW * 0.08),

                  // Trending Section (Always visible)
                  TextWidget(
                    title: 'Trending',
                    fontSize: tS * 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: dW * 0.03),
                  SizedBox(
                    height: dW * 0.6,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: dW * 0.4,
                          margin: EdgeInsets.only(right: dW * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          trending[index]['image']!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Colors.grey[600],
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.favorite_border,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: dW * 0.02),
                              TextWidget(
                                title: trending[index]['name']!,
                                fontSize: tS * 12,
                                maxLines: 2,
                              ),
                              SizedBox(height: dW * 0.01),
                              TextWidget(
                                title: trending[index]['price']!,
                                fontSize: tS * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: dW * 0.05),
                ],
              ),
            ),
    );
  }
}

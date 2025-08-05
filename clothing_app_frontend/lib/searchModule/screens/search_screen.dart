import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Map language = {};
  bool isLoading = false;
  Set<int> selectedCategoryIndices = <int>{};
  bool showPersonalisedCollection = true;
  bool isListening = false;
  // late stt.SpeechToText _speech;

  final List<String> popularSearches = [
    'Baggy Jeans',
    'Linen Shorts',
    'Collar T-shirts',
    'Cotton Shirts',
    'Bodyfit Tops',
    'Glitter Skirts',
    'Wide Tops',
  ];

  final List<Map<String, String>> personalisedCollection = [
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_1.png'},
    {
      'name': 'Skinny Jeans',
      'image': 'assets/products/6_jeans/skinny_jeans/product_6_1.png',
    },
    {
      'name': 'Bodyfit Tops',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_1.png',
    },
  ];

  final List<Map<String, String>> newArrivals = [
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_1.png',
    },
    {
      'name': 'Bodyfit Tops',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_1.png',
    },
    {
      'name': 'Wide Tops',
      'image': 'assets/products/2_tops/wide_tops/product_2_1.png',
    },
    {
      'name': 'Jeans Shorts',
      'image': 'assets/products/4_shorts/jeans_shorts/product_4_1.png',
    },
    {
      'name': 'Collar T-Shirt',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
    },
    {
      'name': 'Glitter Skirt',
      'image': 'assets/products/5_skirts/glitter_skirt/product_5_1.png',
    },
  ];

  final List<Map<String, dynamic>> trending = [
    {
      'name': 'Premium Baggy Jeans',
      'price': '\$125',
      'image': 'assets/products/6_jeans/baggy/product_6_2.png',
    },
    {
      'name': 'Bodyfit Top',
      'price': '\$35',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_2.png',
    },
    {
      'name': 'Collar T-Shirt',
      'price': '\$32',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_2.png',
    },
  ];

  // New variables and methods for search functionality
  String selectedSearchTerm = ''; // Add this to track selected search term

  // Update your personalisedCollection to include ALL available images for each type
  final List<Map<String, String>> allPersonalisedCollection = [
    // Tops (configured in pubspec.yaml)
    {
      'name': 'Bodyfit Tops',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_1.png',
    },
    {
      'name': 'Bodyfit Tops',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_2.png',
    },
    {
      'name': 'Wide Tops',
      'image': 'assets/products/2_tops/wide_tops/product_2_1.png',
    },

    // Shorts types (configured in pubspec.yaml) - ALL available images
    {
      'name': 'Jeans Shorts',
      'image': 'assets/products/4_shorts/jeans_shorts/product_4_1.png',
    },
    {
      'name': 'Jeans Shorts',
      'image': 'assets/products/4_shorts/jeans_shorts/product_4_2.png',
    },
    {
      'name': 'Linen Shorts',
      'image': 'assets/products/4_shorts/linen_shorts/product_4_1.png',
    },

    // Skirts (configured in pubspec.yaml)
    {
      'name': 'Glitter Skirts',
      'image': 'assets/products/5_skirts/glitter_skirt/product_5_1.png',
    },
    {
      'name': 'Woolen Skirt',
      'image': 'assets/products/5_skirts/woolen_skirt/product_5_1.png',
    },
    {
      'name': 'Woolen Skirt',
      'image': 'assets/products/5_skirts/woolen_skirt/product_5_2.png',
    },

    // Baggy Jeans - ALL 5 available images
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_1.png',
    },
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_2.png',
    },
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_3.png',
    },
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_4.png',
    },
    {
      'name': 'Baggy Jeans',
      'image': 'assets/products/6_jeans/baggy/product_6_5.png',
    },
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_1.png'},
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_2.png'},
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_3.png'},
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_4.png'},
    {'name': 'Baggy', 'image': 'assets/products/6_jeans/baggy/product_6_5.png'},

    // Skinny Jeans - ALL 3 available images
    {
      'name': 'Skinny Jeans',
      'image': 'assets/products/6_jeans/skinny_jeans/product_6_1.png',
    },
    {
      'name': 'Skinny Jeans',
      'image': 'assets/products/6_jeans/skinny_jeans/product_6_2.png',
    },
    {
      'name': 'Skinny Jeans',
      'image': 'assets/products/6_jeans/skinny_jeans/product_6_3.png',
    },

    // Ripped Jeans - ALL 2 available images
    {
      'name': 'Ripped Jeans',
      'image': 'assets/products/6_jeans/ripped_jeans/product_6_1.png',
    },
    {
      'name': 'Ripped Jeans',
      'image': 'assets/products/6_jeans/ripped_jeans/product_6_2.png',
    },

    // Wide Leg Jeans - ALL 2 available images
    {
      'name': 'Wide Leg Jeans',
      'image': 'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',
    },
    {
      'name': 'Wide Leg Jeans',
      'image': 'assets/products/6_jeans/wide_leg_jeans/product_6_2.png',
    },

    // Splatter Loose Fit Jeans - ALL 2 available images
    {
      'name': 'Splatter Loose Fit',
      'image':
          'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_1.png',
    },
    {
      'name': 'Splatter Loose Fit',
      'image':
          'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_2.png',
    },

    // Shirts types (configured in pubspec.yaml)
    {
      'name': 'Cotton Shirts',
      'image': 'assets/products/7_shirts/cotton_shirts/product_7_1.png',
    },
    {
      'name': 'Cotton Shirts',
      'image': 'assets/products/7_shirts/cotton_shirts/product_7_2.png',
    },
    {
      'name': 'Cotton Shirts',
      'image': 'assets/products/7_shirts/cotton_shirts/product_7_3.png',
    },
    {
      'name': 'Jeans Shirts',
      'image': 'assets/products/7_shirts/jeans_shirts/product_7_1.png',
    },

    // Collar T-Shirts - ALL 3 available images
    {
      'name': 'Collar T-shirts',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
    },
    {
      'name': 'Collar T-shirts',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_2.png',
    },
    {
      'name': 'Collar T-shirts',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_3.png',
    },

    // Wide T-Shirts - ALL 2 available images
    {
      'name': 'Wide T-shirts',
      'image': 'assets/products/8_t-shirts/wide_tshirts/product_8_4.png',
    },
    {
      'name': 'Wide T-shirts',
      'image': 'assets/products/8_t-shirts/wide_tshirts/product_8_5.png',
    },

    // General category searches
    {'name': 'Jeans', 'image': 'assets/products/6_jeans/baggy/product_6_1.png'},
    {
      'name': 'Jeans',
      'image': 'assets/products/6_jeans/skinny_jeans/product_6_1.png',
    },
    {
      'name': 'Jeans',
      'image': 'assets/products/6_jeans/ripped_jeans/product_6_1.png',
    },
    {
      'name': 'Jeans',
      'image': 'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',
    },
    {
      'name': 'Jeans',
      'image':
          'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_1.png',
    },

    {
      'name': 'Shorts',
      'image': 'assets/products/4_shorts/jeans_shorts/product_4_1.png',
    },
    {
      'name': 'Shorts',
      'image': 'assets/products/4_shorts/jeans_shorts/product_4_2.png',
    },
    {
      'name': 'Shorts',
      'image': 'assets/products/4_shorts/linen_shorts/product_4_1.png',
    },

    {
      'name': 'T-shirts',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
    },
    {
      'name': 'T-shirts',
      'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_2.png',
    },
    {
      'name': 'T-shirts',
      'image': 'assets/products/8_t-shirts/wide_tshirts/product_8_4.png',
    },

    {
      'name': 'Shirts',
      'image': 'assets/products/7_shirts/cotton_shirts/product_7_1.png',
    },
    {
      'name': 'Shirts',
      'image': 'assets/products/7_shirts/cotton_shirts/product_7_2.png',
    },
    {
      'name': 'Shirts',
      'image': 'assets/products/7_shirts/jeans_shirts/product_7_1.png',
    },

    {
      'name': 'Tops',
      'image': 'assets/products/2_tops/bodyfit_tops/product_2_1.png',
    },
    {
      'name': 'Tops',
      'image': 'assets/products/2_tops/wide_tops/product_2_1.png',
    },

    {
      'name': 'Skirts',
      'image': 'assets/products/5_skirts/glitter_skirt/product_5_1.png',
    },
    {
      'name': 'Skirts',
      'image': 'assets/products/5_skirts/woolen_skirt/product_5_1.png',
    },
  ];

  // Method to get filtered collection based on search term
  List<Map<String, String>> get filteredPersonalisedCollection {
    if (selectedSearchTerm.isEmpty) {
      return allPersonalisedCollection;
    }

    return allPersonalisedCollection.where((item) {
      return item['name']!.toLowerCase().contains(
        selectedSearchTerm.toLowerCase(),
      );
    }).toList();
  }

  fetchData() async {
    // _speech = stt.SpeechToText();
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    // Automatically focus the search field when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _togglePreferences() {
    setState(() {
      showPersonalisedCollection = !showPersonalisedCollection;
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    // Get the top padding (notch height)
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(
          top: topPadding, // This prevents content from going into notch area
        ),
        child: GestureDetector(
          onTap: () {
            // Hide keyboard when tapping anywhere on the screen
            _hideKeyboard();
          },
          child: SizedBox(
            height: dH - topPadding, // Adjust height to account for top margin
            width: dW,
            child: isLoading
                ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    clipBehavior:
                        Clip.hardEdge, // This prevents scrolling beyond bounds
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: dW * 0.05,
                        right: dW * 0.05,
                        top: dW * 0.02, // Small top spacing
                        bottom: dW * 0.25, // Space for floating nav bar
                      ),
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
                                  focusNode: _searchFocusNode, // Add this line
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
                                  onChanged: (value) {
                                    // Update search filter when user types
                                    setState(() {
                                      selectedSearchTerm = value;
                                      // Clear popular search selection when typing manually
                                      selectedCategoryIndices.clear();
                                    });
                                  },
                                  // Add onTap to prevent the GestureDetector from hiding keyboard when tapping the text field
                                  onTap: () {
                                    // This prevents the outer GestureDetector from firing
                                  },
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
                                    color: isListening
                                        ? Colors.red
                                        : Colors.grey[300],
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
                              children: List.generate(popularSearches.length, (
                                index,
                              ) {
                                final isSelected = selectedCategoryIndices
                                    .contains(index);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        // Deselect the item
                                        selectedCategoryIndices.remove(index);
                                        searchController.clear();
                                        selectedSearchTerm = '';
                                      } else {
                                        // Select the item
                                        selectedCategoryIndices
                                            .clear(); // Clear other selections
                                        selectedCategoryIndices.add(index);

                                        // Update text field and search term
                                        String searchTerm =
                                            popularSearches[index];
                                        searchController.text = searchTerm;
                                        selectedSearchTerm = searchTerm;
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
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: TextWidget(
                                      title: popularSearches[index],
                                      fontSize: tS * 12,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
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
                                  title: selectedSearchTerm.isNotEmpty
                                      ? 'Results for "$selectedSearchTerm"'
                                      : 'Personalised Collection',
                                  fontSize: tS * 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                if (selectedSearchTerm.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSearchTerm = '';
                                        searchController.clear();
                                        selectedCategoryIndices.clear();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: dW * 0.02,
                                        vertical: dW * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextWidget(
                                            title: 'Clear',
                                            fontSize: tS * 10,
                                            color: Colors.grey[700],
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.clear,
                                            size: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: dW * 0.03),

                            // Show filtered results or no results message
                            filteredPersonalisedCollection.isEmpty
                                ? Container(
                                    height: dW * 0.35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: dW * 0.02),
                                          TextWidget(
                                            title:
                                                'No results found for "$selectedSearchTerm"',
                                            fontSize: tS * 12,
                                            color: Colors.grey[600],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: dW * 0.35,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          filteredPersonalisedCollection.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: dW * 0.25,
                                          margin: EdgeInsets.only(
                                            right: dW * 0.03,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: Colors.grey[200],
                                                    // Add highlight border for exact matches
                                                    border:
                                                        filteredPersonalisedCollection[index]['name']!
                                                                .toLowerCase() ==
                                                            selectedSearchTerm
                                                                .toLowerCase()
                                                        ? Border.all(
                                                            color: Colors.black,
                                                            width: 2,
                                                          )
                                                        : null,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.asset(
                                                      filteredPersonalisedCollection[index]['image']!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Icon(
                                                                Icons.image,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: dW * 0.02),
                                              TextWidget(
                                                title:
                                                    filteredPersonalisedCollection[index]['name']!,
                                                fontSize: tS * 12,
                                                textAlign: TextAlign.center,
                                                fontWeight:
                                                    filteredPersonalisedCollection[index]['name']!
                                                            .toLowerCase() ==
                                                        selectedSearchTerm
                                                            .toLowerCase()
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                          // SizedBox(height: dW * 0.08),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey[200],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  trending[index]['image']!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons.image,
                                                            color: Colors
                                                                .grey[600],
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
                                                  color: Colors.white
                                                      .withOpacity(0.8),
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
                  ),
          ),
        ),
      ),
    );
  }
}

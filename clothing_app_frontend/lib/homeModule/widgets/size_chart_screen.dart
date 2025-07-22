// import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../authModule/providers/auth_provider.dart';
// import '../../common_functions.dart';

// class SizeChartScreen extends StatefulWidget {
//   const SizeChartScreen({Key? key}) : super(key: key);
//   @override
//   SizeChartScreenState createState() => SizeChartScreenState();
// }
// class SizeChartScreenState extends State<SizeChartScreen> {
//   double dH = 0.0;
//   double dW = 0.0;
//   double tS = 0.0;
//   TextTheme customTextTheme = const TextTheme();
//   Map language = {};
//   bool isLoading = false;
//   fetchData() async {}
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//   @override
//   Widget build(BuildContext context) {
//     dH = MediaQuery.of(context).size.height;
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;
//     customTextTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Size Guide', dW: dW),
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
//                   SizedBox(height: dW * 0.05),TextWidget(title: 'Size chart...'),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SizeChartScreen extends StatefulWidget {
  const SizeChartScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        duration: const Duration(minutes: 10), // stays open until dismissed
        content: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizeChartScreen(),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<SizeChartScreen> createState() => _SizeChartScreenState();
}

class _SizeChartScreenState extends State<SizeChartScreen> {
  bool isHowToMeasureOpen = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Material(
        child: SingleChildScrollView(
          // <-- Make the whole widget vertically scrollable
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "TOPS, BLOUSES ETC.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "HOW TO MEASURE",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(isHowToMeasureOpen ? Icons.remove : Icons.add),
                  onTap: () => setState(() => isHowToMeasureOpen = !isHowToMeasureOpen),
                ),
                if (isHowToMeasureOpen)
                  Column(
                    children: [
                      Image.asset('assets/images/how_to_measure.jpg'),
                      const SizedBox(height: 12),
                      _buildMeasureText("1", "Chest", "Measure your chest over the fullest part of your bust while wearing a bra that fits."),
                      _buildMeasureText("2", "Waist", "Measure your waist at the narrowest point. (MATERNITY: Do not measure the waist)"),
                      _buildMeasureText("3", "Arm length", "Measure from shoulder to wrist."),
                      _buildMeasureText("4", "Low hip", "Measure your low hip around the fullest part of your hip."),
                    ],
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "SELECT SIZE RANGE",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: "REGULAR"),
                    Tab(text: "MATERNITY"),
                    Tab(text: "PETITE"),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    children: [
                      _buildSizeTableRegular(),
                      Center(child: Text("Maternity size chart coming soon")),
                      Center(child: Text("Petite size chart coming soon")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildMeasureText(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(text: desc, style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSizeTableRegular() {
    final sizes = [
      ["XXS", "TTP", "0", "75–78", "29½–30¾", "62–64", "24½–25", "82–86"],
      ["XS", "TP", "2", "78–82", "30¾–32¼", "64–66", "25–26", "86–90"],
      ["S", "P", "4–6", "82–90", "32¼–35½", "66–74", "26–29", "90–97.5"],
      ["M", "M", "8–10", "90–98", "35½–38½", "74–82", "29–32", "97.5–105.5"],
      ["L", "G", "12–14", "98–106", "38½–41¾", "82–90", "32–35½", "105.5–113.5"],
      ["XL", "TG", "16–18", "106–114", "41¾–44¾", "90–98", "35½–38½", "113.5–121.5"],
      ["XXL", "TTG", "20–22", "114–122", "44¾–48", "98–106", "38½–41¾", "121.5–129.5"],
    ];

    // Fix: Use a vertically scrollable ListView inside the horizontal scroll
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 530, // or adjust as needed
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            children: [
              _buildSizeRow(["", "CA", "US", "Chest cm", "Chest in", "Waist cm", "Waist in", "Low hip cm"], isHeader: true),
              ...sizes.map((row) => _buildSizeRow(row)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSizeRow(List<String> values, {bool isHeader = false}) {
    // Set flex for each column to fit header text
    final columnFlex = [2, 2, 2, 3, 3, 3, 3, 3];
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isHeader ? Colors.grey.shade400 : Colors.grey.shade200,
            width: isHeader ? 2 : 1,
          ),
        ),
        color: isHeader ? Colors.grey.shade100 : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: Row(
        children: List.generate(values.length, (i) {
          return Expanded(
            flex: columnFlex[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                values[i],
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  fontSize: isHeader ? 13 : 12,
                  color: isHeader ? Colors.black : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          );
        }),
      ),
    );
  }
}
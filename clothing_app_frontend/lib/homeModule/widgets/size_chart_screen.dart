import 'package:flutter/material.dart';

class SizeChartScreen extends StatefulWidget {
  const SizeChartScreen({super.key});

  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0), // Remove margins
        duration: const Duration(minutes: 10), // stays open until dismissed
        content: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQuery.of(context).size.width, // Fill entire width
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85, // 85% of screen height
              minHeight: 500,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizeChartScreen(),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
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
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFB8956A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "HIGH WAIST WIDE LEG DENIM BAGGY JEANS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18,
                    color: Color(0xFFB8956A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFD2B193).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Premium 100% Cotton Denim • High-Rise Fit • Wide Leg Silhouette",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB8956A),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                      _buildMeasureText("1", "Waist", "Measure around your natural waistline where you want the jeans to sit (high-rise style)."),
                      _buildMeasureText("2", "Hips", "Measure around the fullest part of your hips, approximately 8 inches below your waist."),
                      _buildMeasureText("3", "Inseam", "Measure from the crotch to the desired hem length along the inside of your leg."),
                      _buildMeasureText("4", "Rise", "Measure from the waistband to the crotch seam when laying the jeans flat."),
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
                  labelColor: Color(0xFFB8956A),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFFB8956A),
                  indicatorWeight: 3,
                  tabs: [
                    Tab(text: "REGULAR FIT"),
                    Tab(text: "RELAXED FIT"),
                    Tab(text: "OVERSIZED FIT"),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: TabBarView(
                    children: [
                      _buildDenimSizeTableRegular(),
                      _buildDenimSizeTableRelaxed(),
                      _buildDenimSizeTableOversized(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Sizing Guide Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD2B193).withOpacity(0.1), Color(0xFFB8956A).withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFD2B193).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Color(0xFFB8956A), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Sizing Guide",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFB8956A),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildSizingTip("📏", "Size up for an extra relaxed fit"),
                      _buildSizingTip("👖", "High-rise design sits at natural waist"),
                      _buildSizingTip("📐", "Wide leg provides comfortable room through thighs"),
                      _buildSizingTip("🧵", "100% cotton may shrink slightly after first wash"),
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

  Widget _buildDenimSizeTableRegular() {
    final sizes = [
      ["26", "XS", "24-25", "61-63.5", "34-35", "86-89", "32", "81"],
      ["28", "S", "26-27", "66-68.5", "36-37", "91-94", "32", "81"],
      ["30", "S/M", "28-29", "71-73.5", "38-39", "96-99", "32", "81"],
      ["32", "M", "30-31", "76-78.5", "40-41", "101-104", "32", "81"],
      ["34", "L", "32-33", "81-83.5", "42-43", "106-109", "32", "81"],
      ["36", "XL", "34-35", "86-88.5", "44-45", "111-114", "32", "81"],
      ["38", "XXL", "36-37", "91-93.5", "46-47", "116-119", "32", "81"],
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD2B193).withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            children: [
              _buildDenimSizeRow(["Size", "Fit", "Waist (in)", "Waist (cm)", "Hip (in)", "Hip (cm)", "Inseam", "Rise"], isHeader: true),
              ...sizes.map((row) => _buildDenimSizeRow(row)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDenimSizeTableRelaxed() {
    final sizes = [
      ["26", "XS", "25-26", "63.5-66", "35-36", "89-91", "32", "82"],
      ["28", "S", "27-28", "68.5-71", "37-38", "94-96", "32", "82"],
      ["30", "S/M", "29-30", "73.5-76", "39-40", "99-101", "32", "82"],
      ["32", "M", "31-32", "78.5-81", "41-42", "104-106", "32", "82"],
      ["34", "L", "33-34", "83.5-86", "43-44", "109-111", "32", "82"],
      ["36", "XL", "35-36", "88.5-91", "45-46", "114-116", "32", "82"],
      ["38", "XXL", "37-38", "93.5-96", "47-48", "119-121", "32", "82"],
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD2B193).withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            children: [
              _buildDenimSizeRow(["Size", "Fit", "Waist (in)", "Waist (cm)", "Hip (in)", "Hip (cm)", "Inseam", "Rise"], isHeader: true),
              ...sizes.map((row) => _buildDenimSizeRow(row)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDenimSizeTableOversized() {
    final sizes = [
      ["26", "XS", "26-27", "66-68.5", "36-37", "91-94", "32", "83"],
      ["28", "S", "28-29", "71-73.5", "38-39", "96-99", "32", "83"],
      ["30", "S/M", "30-31", "76-78.5", "40-41", "101-104", "32", "83"],
      ["32", "M", "32-33", "81-83.5", "42-43", "106-109", "32", "83"],
      ["34", "L", "34-35", "86-88.5", "44-45", "111-114", "32", "83"],
      ["36", "XL", "36-37", "91-93.5", "46-47", "116-119", "32", "83"],
      ["38", "XXL", "38-39", "96-99", "48-49", "121-124", "32", "83"],
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD2B193).withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            children: [
              _buildDenimSizeRow(["Size", "Fit", "Waist (in)", "Waist (cm)", "Hip (in)", "Hip (cm)", "Inseam", "Rise"], isHeader: true),
              ...sizes.map((row) => _buildDenimSizeRow(row)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDenimSizeRow(List<String> values, {bool isHeader = false}) {
    // Set flex for each column to fit denim measurements
    final columnFlex = [2, 2, 3, 3, 3, 3, 2, 2];
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isHeader ? Color(0xFFB8956A).withOpacity(0.5) : Color(0xFFD2B193).withOpacity(0.3),
            width: isHeader ? 2 : 1,
          ),
        ),
        color: isHeader ? Color(0xFFD2B193).withOpacity(0.1) : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        children: List.generate(values.length, (i) {
          return Expanded(
            flex: columnFlex[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                values[i],
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                  fontSize: isHeader ? 14 : 13,
                  color: isHeader ? Color(0xFFB8956A) : Colors.grey[800],
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

  Widget _buildSizingTip(String emoji, String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
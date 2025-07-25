import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/circular_loader.dart';
import '../../common_widgets/text_widget.dart';
import '../../common_functions.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  String selectedType = 'Other';

  fetchData() async {}

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Address Details', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return isLoading
        ? Center(child: CircularLoader(android: dW * 0.08, iOS: dW * 0.035))
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: dW * 0.06, vertical: dH * 0.04),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  title: 'Enter your details below',
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),            
                Divider(height: dH * 0.04),
                TextWidget(
                  title: 'Select address type',
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: dH * 0.015),
                Row(
                  children: [
                    Expanded(flex: 1, child: addressTypeButton('+', 'Other')),
                    SizedBox(width: 8),
                    Expanded(flex: 1, child: addressTypeButton(Icons.home_outlined, 'Home')),
                    SizedBox(width: 8),
                    Expanded(flex: 1, child: addressTypeButton(Icons.work_outline, 'Work')),
                    SizedBox(width: 8),
                    Expanded(flex: 1, child: addressTypeButton(Icons.person_outline, 'Other')),
                  ],
                ),
                SizedBox(height: dH * 0.03),
                buildTextField('Receivers Name*', nameController),
                buildTextField('House No/Apt No*', houseController),
                buildTextField('Street Name*', streetController),
                buildTextField('City*', cityController),
                buildTextField('Zip Code*', zipController),
                SizedBox(height: dH * 0.04),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB08C6E),
                    minimumSize: Size(double.infinity, dH * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Save logic
                  },
                  child: const Text(
                    'Save Address',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: dH * 0.02),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget addressTypeButton(dynamic iconOrText, String type) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFD2BA9F).withOpacity(0.2) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconOrText is IconData
                ? Icon(iconOrText, size: 16)
                : Text(iconOrText, style: const TextStyle(fontSize: 14)),
            SizedBox(width: 2),
            Flexible(
              child: Text(
                type,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

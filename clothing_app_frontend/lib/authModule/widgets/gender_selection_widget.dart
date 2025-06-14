import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/custom_radio_button.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:provider/provider.dart';

class GenderSelectionWidget extends StatefulWidget {
  final Function(String) updateSelectedCount;
  final String? selectedGender;
  final String? storedSelectedCount;
  const GenderSelectionWidget(
    this.updateSelectedCount,
    this.selectedGender,
    this.storedSelectedCount, {
    super.key,
  });

  @override
  GenderSelectionWidgetState createState() => GenderSelectionWidgetState();
}

class GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  fetchData() async {}

  String? selectedGender;
  List<String> genders = ['Male', 'Female', 'Other'];
  void selectGender(String gender) {
    widget.updateSelectedCount(gender);
    setState(() {
      selectedGender = gender;
    });
    // pop();
  }

  @override
  void initState() {
    super.initState();
    selectedGender = widget.selectedGender;
    if (widget.storedSelectedCount != null) {
      selectedGender = widget.storedSelectedCount;
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: dW * 0.055,
        horizontal: dW * 0.045,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: language['selectGender'],
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: () => pop(),
                child: const AssetSvgIcon('cross_red', color: Colors.black),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: dW * 0.03),
            padding: EdgeInsets.symmetric(
              vertical: dW * 0.03,
              horizontal: dW * 0.02,
            ),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              border: Border(top: BorderSide(color: Colors.blue.shade500)),
            ),
            child: Column(
              children: [
                ...genders.map(
                  (gender) => CustomRadioButton(
                    label: gender.toString(),
                    isSelected: selectedGender == gender,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectGender(gender);
                        } else {
                          selectedGender = null;
                        }
                        pop();
                      });
                    },
                    activeColor: buttonColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

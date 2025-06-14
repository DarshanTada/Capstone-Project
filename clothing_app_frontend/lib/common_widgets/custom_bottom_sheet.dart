// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../colors.dart';
import '../../common_functions.dart';
import '../navigation/navigators.dart';
import 'custom_button.dart';

class CustomBottomSheet extends StatefulWidget {
  String selectedOption;
  List options;
  String title;
  CustomBottomSheet({
    Key? key,
    required this.selectedOption,
    required this.options,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    // final double height = societies.length <= 4 ? dW * 1.2 : dW * 1.4;

    return Container(
      width: dW,
      // height: height,
      color: white,
      margin: EdgeInsets.symmetric(vertical: dW * 0.05),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(border: Border(bottom: dividerBorder)),
            padding: EdgeInsets.only(
              left: dW * 0.05,
              right: dW * 0.04,
              bottom: dW * 0.035,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: tS * 16,
                    color: const Color(0xFF6B6C75),
                  ),
                ),
                GestureDetector(
                  onTap: pop,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: dW * 0.055,
                vertical: dW * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...widget.options
                      .map(
                        (o) => GestureDetector(
                          onTap: () =>
                              setState(() => widget.selectedOption = o),
                          child: Container(
                            margin: EdgeInsets.only(top: dW * 0.04),
                            padding: EdgeInsets.all(
                              (widget.selectedOption == o) ? 1.25 : 1,
                            ),
                            decoration: BoxDecoration(
                              color: widget.selectedOption == o
                                  ? null
                                  : lightGray,
                              gradient: widget.selectedOption == o
                                  ? linearGradient
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: dW * 0.045,
                                horizontal: dW * 0.05,
                              ),
                              width: dW,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: dW * 0.68,
                                    child: Text(
                                      o,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            height: 1.4,
                                            fontSize: tS * 16,
                                            color: widget.selectedOption == o
                                                ? grayColor
                                                : lightGray,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1.5,
                                        color: widget.selectedOption == o
                                            ? themeColor
                                            : lightGray,
                                      ),
                                    ),
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: widget.selectedOption == o
                                            ? linearGradient
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          // const Spacer(),
          Container(
            decoration: BoxDecoration(border: Border(top: dividerBorder)),
            padding: EdgeInsets.only(
              top: dW * 0.05,
              bottom: dW * 0.01,
              left: dW * 0.05,
              right: dW * 0.05,
            ),
            child: CustomButton(
              width: dW * 0.9,
              height: dW * 0.13,
              buttonText: language['select'],
              onPressed: () => pop(widget.selectedOption),
            ),
          ),
        ],
      ),
    );
  }
}

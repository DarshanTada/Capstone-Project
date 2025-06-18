// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/authModule/widgets/gender_selection_widget.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/custom_button.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RegisterUserScreen extends StatefulWidget {
  final RegistrationArguments args;

  const RegisterUserScreen({super.key, required this.args});

  @override
  State<RegisterUserScreen> createState() => RegisterUserScreenState();
}

class RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  Map language = {};
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  String imgPath = '';
  DateTime? _selectedDate;
  String? selectedGenderUser;
  bool isLoading = false;
  bool isFormValid = false;

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _dateEditingController = TextEditingController();

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
            dialogBackgroundColor: Colors.blue[500],
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: _dateEditingController.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter email address';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email address';
    }
    return null;
  }

  String? validateDob(String value) {
    if (value.isEmpty) {
      return 'Please enter your date of birth';
    }
    return null;
  }

  pickImage(ImageSource source) async {
    try {
      ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source);

      setState(() {
        imgPath = image?.path ?? '';
      });
      pop();
      return image;
    } catch (e) {
      return null;
    }
  }

  Widget getProfilePic({
    required BuildContext context,
    required String? name,
    required String? avatar,
    required double radius,
    Color? backgroundColor,
    double fontSize = 18,
    FontWeight? fontWeight,
    Color? fontColor,
    required double tS,
  }) {
    _nameEditingController.addListener(() {
      setState(() {});
    });

    final userName = _nameEditingController.text;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                backgroundColor ??
                Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          child: avatar == null || avatar == ''
              ? Text(
                  name != null ? getInitials(userName) : '',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: tS * fontSize,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    color: fontColor ?? Theme.of(context).primaryColor,
                  ),
                )
              : Container(
                  width: radius,
                  height: radius,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      File(imgPath),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
        ),
        Container(
          padding: EdgeInsets.all(dW * 0.02),
          decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }

  imagePicker(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return SizedBox(
          height: dH * .2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dW * .05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: dW * .02),
                const Text(
                  'Profile Photo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: dW * .03),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (imgPath != '')
                      Container(
                        margin: EdgeInsets.only(right: dW * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => imgPath = '');
                            pop();
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: dW * .08,
                                backgroundColor: Colors.grey.withOpacity(0.4),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: dW * .02),
                              const Text('Remove '),
                              const Text('Photo'),
                            ],
                          ),
                        ),
                      ),
                    // SizedBox(width: dW * .05),
                    GestureDetector(
                      onTap: () => pickImage(ImageSource.gallery),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: dW * .08,
                            backgroundColor: Colors.grey.withOpacity(0.4),
                            child: const Icon(
                              Icons.image,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: dW * .02),
                          const Text('Gallery'),
                        ],
                      ),
                    ),
                    SizedBox(width: dW * .05),
                    GestureDetector(
                      onTap: () => pickImage(ImageSource.camera),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: dW * .08,
                            backgroundColor: Colors.grey.withOpacity(0.4),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: dW * .02),
                          const Text('Camera'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool validateProfile() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String dob = _dateEditingController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        dob.isEmpty ||
        selectGender == 'Select Gender' ||
        selectGender.isEmpty) {
      return false;
    }
    return true;
  }

 
  register() async {
    bool isValid =
        _formKey.currentState!.validate() && (selectGender != 'Select Gender');

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);
    final Map<String, String> body = {
      "fullName": _nameEditingController.text.trim(),
      "email": _emailEditingController.text.trim(),
      "phone": widget.args.mobileNo,
      'gender': selectGender,
      'dob': _selectedDate.toString(),
      "avatar": imgPath,
    };

    final Map<String, String> files = {};
    if (imgPath != '') {
      files["avatar"] = imgPath;
    }

    final response = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).register(body: body, files: files);

    if (!response['success']) {
      setState(() => isLoading = false);

      showSnackbar(language[response['message']]);
    } else {
      // if (Provider.of<AuthProvider>(
      //   context,
      //   listen: false,
      // ).user.isLocationAllowed) {
      //   // checkAndGetLocationPermission();
      // } else {
      //   setState(() => isLoading = false);

      //   push(NamedRoute.locationScreen);
      // }
    }
  }

  String selectGender = 'Select Gender';
  void updateSelectedGender(String count) {
    setState(() {
      selectGender = count;
    });
  }

  void genderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => GestureDetector(
        child: GenderSelectionWidget(
          updateSelectedGender,
          selectedGenderUser,
          selectGender,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;

    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      body: GestureDetector(
        onTap: () => hideKeyBoard(),
        child: Stack(
          children: [
            Center(child: Image.asset('assets/images/login_bg.jpg')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: dW * 0.18),
                            TextWidget(
                              title: language['welcome!'],
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: dW * 0.01),
                            TextWidget(
                              title: language['letsMakeAProfile'],
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                            SizedBox(height: dW * 0.06),
                            Center(
                              child: GestureDetector(
                                onTap: () => imagePicker(context),
                                child: getProfilePic(
                                  context: context,
                                  name: _nameEditingController.text,
                                  avatar: imgPath,
                                  radius: 110,
                                  fontSize: 26,
                                  tS: tS,
                                ),
                              ),
                            ),
                            SizedBox(height: dW * 0.08),
                            CustomTextFieldWithLabel(
                              label: language['fullName'],
                              hintText: language['enterFullName'],
                              controller: _nameEditingController,
                              borderColor: Colors.grey,
                              labelColor: Colors.grey,
                              textCapitalization: TextCapitalization.words,
                              validator: validateName,
                            ),
                            SizedBox(height: dW * 0.04),
                            CustomTextFieldWithLabel(
                              label: language['emailAddress'],
                              hintText: language['enterEmailAddress'],
                              controller: _emailEditingController,
                              borderColor: Colors.grey,
                              labelColor: Colors.grey,
                              validator: validateEmail,
                            ),
                            SizedBox(height: dW * 0.04),
                            GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: AbsorbPointer(
                                absorbing: true,
                                child: CustomTextFieldWithLabel(
                                  label: language['birthday'],
                                  hintText: language['enterBirthday'],
                                  controller: _dateEditingController,
                                  borderColor: Colors.grey,
                                  labelColor: Colors.grey,
                                  textCapitalization: TextCapitalization.words,
                                  validator: validateDob,
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(dW * 0.02),
                                    margin: EdgeInsets.only(right: dW * 0.02),
                                    child: const AssetSvgIcon(
                                      'calendar',
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: dW * 0.04),
                            Row(
                              children: [
                                TextWidget(
                                  title: language['gender'],
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                TextWidget(
                                  title: '*',
                                  fontWeight: FontWeight.w500,
                                  color: redColor,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => genderBottomSheet(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: dW * 0.03,
                                  horizontal: dW * 0.04,
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: dW * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextWidget(
                                        title: '$selectGender',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    AssetSvgIcon(
                                      'down_arrow',
                                      width: dW * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    width: dW,
                    height: dW * 0.135,
                    isLoading: isLoading,
                    radius: 8,
                    buttonText: language['continue'],
                    buttonTextSyle: Theme.of(context).textTheme.displayLarge!
                        .copyWith(fontSize: tS * 18, color: Colors.white),
                    onPressed: register,
                    buttonColor: validateProfile()
                        ? buttonColor
                        : buttonColor.withOpacity(0.5),
                  ),
                  SizedBox(height: dW * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

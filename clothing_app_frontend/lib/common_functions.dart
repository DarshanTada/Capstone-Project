// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/authModule/widgets/single_response_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
// import 'package:clothing_app_frontend/homeModule/models/cafe_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'authModule/widgets/single_response_dialog_box.dart';
import 'colors.dart';

import 'common_widgets/asset_svg_icon.dart';
import 'common_widgets/text_widget.dart';
import 'main.dart';
// import 'navigation/navigators.dart';

String networkDummy =
    'https://media.istockphoto.com/vectors/default-avatar-photo-placeholder-icon-grey-profile-picture-business-vector-id1327592449?k=20&m=1327592449&s=612x612&w=0&h=6yFQPGaxmMLgoEKibnVSRIEnnBgelAeIAf8FqpLBNww=';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// get navigatorKey.currentContext! => navigatorKey;

// mixin navigatorKey {
//   var currentState;
// }

MediaQueryData get _mediaQuery => MediaQuery.of(navigatorKey.currentContext!);

double get _tS => _mediaQuery.textScaleFactor;

bool get isGuest => Provider.of<AuthProvider>(
  navigatorKey.currentContext!,
  listen: false,
).user.isGuest;

List<Color> gradientColors = [const Color(0xFF0197FC), const Color(0xFF01B0B1)];

Gradient get linearGradient => LinearGradient(colors: gradientColors);

hideKeyBoard() =>
    FocusScope.of(navigatorKey.currentContext!).requestFocus(FocusNode());

double horizontalPaddingFactor = 0.06;

navigateTo(LatLng coords) async {
  var uri;
  if (Platform.isIOS) {
    uri = Uri.parse(
      'comgooglemaps://?saddr=&daddr=${coords.latitude},${coords.longitude}&directionsmode=driving',
    );
  } else {
    uri = Uri.parse(
      "google.navigation:q=${coords.latitude},${coords.longitude}&mode=d",
    );
  }
  // if (await canLaunch(uri.toString())) {
  await launch(uri.toString());
  // } else {
  //   throw 'Could not launch ${uri.toString()}';
  // }
}

handlePermissionsFunction() async {
  try {
    Map<Permission, PermissionStatus> statuses = {};
    if (Platform.isIOS) {
      statuses = await [
        Permission.location,
        Permission.locationAlways,
      ].request();

      if (statuses.containsValue(PermissionStatus.permanentlyDenied) ||
          statuses.containsValue(PermissionStatus.denied)) {
        // showSnackbar('Please enable location', Colors.red);
        return false;
      } else
        return true;
    } else {
      statuses = await [Permission.location].request();

      if ((statuses[Permission.location] == PermissionStatus.denied) ||
          (statuses[Permission.location] ==
              PermissionStatus.permanentlyDenied)) {
        // showSnackbar('Please enable location', Colors.red);
        return false;
      } else
        return true;
    }
  } catch (e) {
    return false;
  }
}

String convertToTime(num num) {
  String toReturn = '';

  if (num.toString().contains('.')) {
    final split = num.toString().split('.');
    late int hour;
    if (int.parse(split[0]) > 12) {
      hour = int.parse(split[0]) - 12;
    } else {
      hour = int.parse(split[0]);
    }
    toReturn =
        '${hour.toString().padLeft(2, '0')}:${split[1].padRight(2, '0')}';
    if (int.parse(split[0]) > 12) {
      toReturn += ' PM';
    } else {
      toReturn += ' AM';
    }
  } else {
    if (num > 12) {
      toReturn = '${(num - 12).toString().padLeft(2, '0')}:00';
      toReturn += ' PM';
    } else {
      toReturn = '${num.toString().padLeft(2, '0')}:00';
      toReturn += ' AM';
    }
  }
  return toReturn;
}

DateTime convertNumberToDate(num element) {
  final today = DateTime.now();
  if (element.toString().contains('.')) {
    final split = element.toString().split('.');

    return DateTime(
      today.year,
      today.month,
      today.day,
      int.parse(split[0]),
      int.parse(split[1]),
    );
  } else {
    return DateTime(today.year, today.month, today.day, element.toInt());
  }
}

screenHorizontalPadding(double dW, {double? verticalF}) => EdgeInsets.symmetric(
  horizontal: dW * horizontalPaddingFactor,
  vertical: verticalF != null ? (dW * verticalF) : 0.0,
);

List<BoxShadow> get shadow => [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 4),
    spreadRadius: 0,
    blurRadius: 10,
  ),
];

bool iOSCondition(double dH) => Platform.isIOS && dH > 850;

Text subHeaderText(String title, [Color color = lightGray]) => Text(
  title,
  style: Theme.of(
    navigatorKey.currentContext!,
  ).textTheme.displayLarge!.copyWith(fontSize: _tS * 16, color: color),
);

BorderSide get greyBorderSide =>
    const BorderSide(width: 1, color: Color(0xFFEAEAEA));

String amountText(double amount) {
  String amountString = amount.toStringAsFixed(2);

  if (amountString.split('.')[1][1] == '0') {
    amountString =
        amountString.split('.')[0] + '.' + amountString.split('.')[1][0];
    if (amountString.split('.')[1][0] == '0') {
      amountString = amountString.split('.')[0];
    }
  }
  return amountString;
}

BorderSide get dividerBorder => const BorderSide(color: dividerColor, width: 1);

String convertAmountString(double amount) {
  var strToReturn;
  String aS = amount.round().toStringAsFixed(0);
  // if (amount < 100000) {
  //   return regExpText(aS);
  // }
  final list = aS.split('.');
  aS = list[0];
  final length = aS.length;
  if (length < 6) {
    strToReturn = amountText(amount);
  } else if (length == 6) {
    String trail = aS.substring(length - 5, length);
    String lead = aS.substring(0, length - 5);
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'L';
  } else if (length == 7) {
    String trail = aS.substring(length - 6, length);
    String lead = aS.substring(0, length - 6) + '0';
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'L';
  } else if (length > 7) {
    String trail = aS.substring(length - 7, length);
    String lead = aS.substring(0, length - 7);
    if (trail[0] != '0') lead = lead + '.${trail[0]}';
    strToReturn = lead + 'Cr';
  }
  return strToReturn;
}

pickImage(ImageSource source) async {
  try {
    ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    return image;
  } catch (e) {
    return null;
  }
}

void showSnackbar(String msg, [Color color = Colors.red, int duration = 2]) {
  // final context = navigatorKey.currentContext;
  final context = navigatorKey.currentContext!;

  if (context == null) {
    debugPrint("⚠️ Cannot show snackbar: navigatorKey.currentContext is null");
    return;
  }

  final textTheme = Theme.of(context).textTheme;
  final mediaQuery = MediaQuery.of(context);
  final textScale = mediaQuery.textScaleFactor;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          msg,
          softWrap: true,
          style: textTheme.titleLarge?.copyWith(
            fontSize: textScale * 16,
            color: Colors.white,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: Duration(seconds: duration),
      dismissDirection: DismissDirection.down,
      margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
    ),
  );
}

DateTime? getParseDate(String? date) =>
    date != null ? DateTime.parse(date).toLocal() : null;

PopupMenuEntry popupMenuItem({
  required String position,
  required String title,
  String? icon,
  required double dW,
}) {
  return PopupMenuItem(
    value: position,
    height: dW * 0.07,
    child: Container(
      margin: EdgeInsets.only(bottom: dW * 0.02, top: dW * 0.02),
      child: Row(
        children: [
          TextWidget(title: title, fontWeight: FontWeight.w500),
          if (icon != null) ...[
            SizedBox(width: dW * 0.025),
            AssetSvgIcon(icon),
          ],
        ],
      ),
    ),
  );
}

selectDateRange(
  String selectedFilter,
  DateTime startDate,
  DateTime endDate,
) async {
  return await showDateRangePicker(
    context: navigatorKey.currentContext!,
    firstDate: DateTime.now().subtract(const Duration(days: 90)),
    lastDate: DateTime.now(),
    initialDateRange: selectedFilter == 'customDateRange'
        ? DateTimeRange(start: startDate, end: endDate)
        : null,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          //Header background color
          primaryColor: Colors.blue,
          //Background color
          scaffoldBackgroundColor: Colors.grey[50],
          //Divider color
          dividerColor: Colors.grey,
          //Non selected days of the month color
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            //Selected dates background color
            primary: Colors.blue,
            //Month title and week days color
            onSurface: Colors.black,
            //Header elements and selected dates text color
            //onPrimary: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );
}

bool isSameDay(DateTime date1, DateTime date2) =>
    date1.day == date2.day &&
    date1.month == date2.month &&
    date1.year == date2.year;

Future getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  }
  return false;
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
  return Container(
    width: radius,
    height: radius,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
    ),
    child: avatar == null || avatar == ''
        ? Text(
            name != null ? getInitials(name) : '',
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
              child: CachedNetworkImage(
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                width: 32,
                height: 32,
                imageUrl: avatar,
                placeholder: (_, __) => Image.asset(
                  'assets/placeholders/placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
  );
}

String getInitials(String inputString) {
  String toReturn = '';
  final List<String> sep = inputString.split(' ');
  for (String s in sep) {
    if (toReturn.length < 2) {
      toReturn += s != '' ? s[0] : '';
    }
  }
  return toReturn;
}

// void launchCall(mobileNumber) async {
//   try {
//     var url = Uri.parse('tel:$mobileNumber');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       showSnackbar('Failed to call');
//     }
//   } catch (e) {
//     showSnackbar('Failed to call');
//   }
// }

void launchWhatsApp({required String phoneNumber}) async {
  try {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      showSnackbar('Failed to open WhatsApp');
    }
  } catch (e) {
    showSnackbar('Failed to open WhatsApp');
  }
}

const bouncing = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

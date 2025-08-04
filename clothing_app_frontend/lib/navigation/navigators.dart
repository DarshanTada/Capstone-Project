import 'package:clothing_app_frontend/common_functions.dart';


Future<dynamic> push(String routeName, {Object? arguments}) async {
  return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  // return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
}

Future<dynamic> popAndPush(String routeName, {Object? arguments}) async {
  navigatorKey.currentState?.pop();
  return await navigatorKey.currentState?.pushNamed(
    routeName,
    arguments: arguments,
  );
}

Future<dynamic> pushReplacement(String routeName, {Object? arguments}) async =>
    navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );

Future<dynamic> pushAndRemoveUntil(
  String routeName, {
  Object? arguments,
}) async => navigatorKey.currentState?.pushNamedAndRemoveUntil(
  routeName,
  (route) => false,
  arguments: arguments,
);

pop([data]) => navigatorKey.currentState?.pop(data);

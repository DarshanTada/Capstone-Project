// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:clothing_app_frontend/authModule/screens/intro_screen_1.dart';
import 'package:clothing_app_frontend/authModule/screens/login.dart';
import 'package:clothing_app_frontend/categoryModule/screens/category.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'authModule/providers/auth_provider.dart';
import 'authModule/screens/splash_screen.dart';
import 'navigation/navigation_service.dart';
import 'theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final LocalStorage storage = LocalStorage('re_household');

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {}

awaitStorageReady() async {
  await storage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (double.parse(androidInfo.version.release.split('')[0]) <= 8.0) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  myInit() async {
    // await this.initDynamicLinks();
  }

  // processDynamicLink(PendingDynamicLinkData dynamicLink) async {
  //   final Uri deepLink = dynamicLink.link;
  //   final queryParams = deepLink.queryParameters;

  //   // refer a friend
  //   var userId = queryParams['userId'];
  //   var cafeId = queryParams['cafeId'];
  //   if (userId != null) {
  //     // navigatorKey.currentState!.push(MaterialPageRoute(
  //     //     builder: (context) => ViewPostScreen(postId: postId)));
  //   }
  //   if (cafeId != null) {
  //     push(NamedRoute.loadingScreen,
  //         arguments: LoadingScreenArguments(featureId: cafeId, type: 'cafe'));
  //   }
  // }

  // initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //     processDynamicLink(dynamicLinkData);
  //   }).onError((error) {
  //     debugPrint('onLink error');
  //     debugPrint(error.message);
  //   });

  //   final PendingDynamicLinkData? dynamicLink =
  //       await FirebaseDynamicLinks.instance.getInitialLink();

  //   if (dynamicLink != null) {
  //     processDynamicLink(dynamicLink);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // myInit();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: Consumer(
        builder: (context, theme, _) => MaterialApp(
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          title: 'clothing_app_frontend',
          // theme: theme.getTheme(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: generateRoute,
          routes: {
            '/': (BuildContext context) =>  IntroScreen1()
            // LoginScreen(),

            // '/': (BuildContext context) =>
            //     HomeScreen(args: HomeScreenArguments()),
          },
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
// import 'package:clothing_app_frontend/common_functions.dart';
// import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//   @override
//   ProfileScreenState createState() => ProfileScreenState();
// }
// class ProfileScreenState extends State<ProfileScreen> {
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
//       appBar: CustomAppBar(title: 'Title', dW: dW),
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
//                   SizedBox(height: dW * 0.05),TextWidget(title: 'Profile...')

//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:clothing_app_frontend/profileModule/screens/creator.dart';
import 'package:clothing_app_frontend/profileModule/screens/viewer.dart';
import 'package:clothing_app_frontend/profileModule/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData? user;

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  Future<void> loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => user = userFromPrefs(prefs));
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = user?.avatarId != null
        ? 'https://api.readyplayer.me/v1/avatars/${user!.avatarId}.png'
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatarImage != null
                ? CircleAvatar(radius: 80, backgroundImage: NetworkImage(avatarImage))
                : const Icon(Icons.person, size: 100, color: Colors.grey),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AvatarCreatorPage()),
                );
                loadAvatar();
              },
              child: const Text("Create 3D Avatar"),
            ),

            if (user?.avatarUrl != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AvatarViewerPage(data: user!)),
                  );
                },
                child: const Text("View 3D Avatar"),
              ),
          ],
        ),
      ),
    );
  }
}
// // profile_screen.dart
// import 'package:clothing_app_frontend/profileModule/screens/creator.dart';
// import 'package:clothing_app_frontend/profileModule/screens/viewer.dart';
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.camera_alt),
//           label: const Text('Create 3D Avatar'),
//           onPressed: () {
//            Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => AvatarCreator(
//       onAvatarCreated: (avatarUrl) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AvatarViewer(avatarUrl: avatarUrl),
//           ),
//         );
//       },
//     ),
//   ),
// );

//           },
//         ),
//       ),
//     );
//   }
// }

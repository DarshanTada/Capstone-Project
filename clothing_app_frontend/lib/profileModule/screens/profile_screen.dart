import 'package:clothing_app_frontend/profileModule/screens/creator.dart';
import 'package:clothing_app_frontend/profileModule/screens/viewer.dart';
import 'package:clothing_app_frontend/profileModule/screens/faq_screen.dart';
import 'package:clothing_app_frontend/profileModule/screens/privacy_policy_screen.dart';
import 'package:clothing_app_frontend/profileModule/screens/app_version_screen.dart';
import 'package:clothing_app_frontend/profileModule/screens/contact_us_screen.dart';
import 'package:clothing_app_frontend/profileModule/utils.dart';
import 'package:clothing_app_frontend/orderHistoryModule/screens/order_history_screen.dart';
import 'package:clothing_app_frontend/addressModule/screens/addresses_screen.dart';
import 'package:clothing_app_frontend/preferenceModule/screen/preference_screen.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/authModule/providers/logout_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData? user;
  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    loadAvatar();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Ensure auth provider loads user data from preferences
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserFromPrefs();

    if (mounted) {
      setState(() {
        _isLoadingUserData = false;
      });
    }
  }

  Future<void> loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => user = userFromPrefs(prefs));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_outlined, color: Color(0xFFB8956A), size: 24),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD2B193),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog first
                await _logout(); // Then perform logout
              },
              child: Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      // Get providers
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final logoutProvider = Provider.of<LogoutProvider>(
        context,
        listen: false,
      );

      // Check if user is logged in and has a token
      if (!authProvider.isLoggedIn || authProvider.user.token == null) {
        // If no valid session, just do local logout
        if (mounted) {
          logoutProvider.forceLogout(context);
        }
        return;
      }

      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD2B193)),
                ),
                SizedBox(height: 16),
                Text(
                  'Logging out...',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }

      // Call logout API and Firebase logout
      final result = await logoutProvider.logoutUser(
        context: context,
        token: authProvider.user.token!,
      );

      // Dismiss loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show result message if there was an error
      if (!result['status'] && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Logout completed'),
            backgroundColor: Colors.orange.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      // Clear local user data from auth provider
      await authProvider.logout();
    } catch (e) {
      // Dismiss loading dialog if it's showing
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
      }

      // Force logout even if there's an error
      if (mounted) {
        final logoutProvider = Provider.of<LogoutProvider>(
          context,
          listen: false,
        );
        await logoutProvider.forceLogout(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout completed despite error: $e'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = user?.avatarId != null
        ? 'https://api.readyplayer.me/v1/avatars/${user!.avatarId}.png'
        : null;

    double dH = MediaQuery.of(context).size.height;
    double dW = MediaQuery.of(context).size.width;

    // Get user data from auth provider
    final authProvider = Provider.of<AuthProvider>(context);
    final activePreference = authProvider.activePreference;

    // Show loading indicator if data is still being loaded
    if (_isLoadingUserData && activePreference == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD2B193)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading profile...',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Extract user information with fallbacks
    final userName = activePreference?.username ?? "Hi, There";
    final userHeight = activePreference?.height != null
        ? "${activePreference!.height!.toStringAsFixed(0)} cm"
        : "";
    final userBodyType = activePreference?.bodyType ?? "";
    final userGender = activePreference?.gender ?? "";
    final userAge = activePreference?.age != null
        ? "${activePreference!.age} years"
        : "";

    // Debug: Print current preference data
    print('Profile Screen Debug:');
    print('- isLoggedIn: ${authProvider.isLoggedIn}');
    print('- activePreference: $activePreference');
    print('- userName: $userName');
    print('- userHeight: $userHeight');
    print('- userBodyType: $userBodyType');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.brown.shade300),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferenceScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: dH * 0.02),
            // Profile Card
            Container(
              padding: EdgeInsets.all(dW * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Edit Icon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreferenceScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B193).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFD2B193).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Color(0xFFB8956A),
                        ),
                      ),
                    ),
                  ),
                  // Profile Content
                  Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: avatarImage != null
                                ? Image.network(
                                    avatarImage,
                                    height: dW * 0.24,
                                    width: dW * 0.24,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: dW * 0.24,
                                    width: dW * 0.24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFD2B193),
                                          Color(0xFFB8956A),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: user?.avatarUrl != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AvatarViewerPage(data: user!),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD2B193),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.visibility,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: dW * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$userGender • $userAge",
                                style: TextStyle(
                                  color: Color(0xFFB8956A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Row(
                              children: [
                                Icon(
                                  Icons.height,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  userHeight,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.fitness_center,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  userBodyType,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dH * 0.018),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: dH * 0.012,
                                      ),
                                      backgroundColor: Color(0xFFD2B193),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AvatarCreatorPage(),
                                        ),
                                      );
                                      loadAvatar();
                                    },
                                    icon: Icon(Icons.person_3, size: 16),
                                    label: Text(
                                      "Create Avatar",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: dH * 0.025),
            // Action Tiles Container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD2B193),
                    Color(0xFFB8956A),
                    Color(0xFFA67C52),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFB8956A).withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                vertical: dH * 0.035,
                horizontal: dW * 0.05,
              ),
              child: Column(
                children: [
                  // Enhanced Header for action tiles
                  Container(
                    margin: EdgeInsets.only(bottom: dH * 0.03),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.dashboard_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Manage your account & preferences',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ProfileActionTile(
                          icon: Icons.history_outlined,
                          label: 'Order History',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: dW * 0.035,
                      ), // Added spacing between buttons
                      Expanded(
                        child: ProfileActionTile(
                          icon: Icons.location_on_outlined,
                          label: 'Address',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddressesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dH * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ProfileActionTile(
                          icon: Icons.mail_outline,
                          label: 'Contact Us',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: dW * 0.035,
                      ), // Added spacing between buttons
                      Expanded(
                        child: ProfileActionTile(
                          icon: Icons.help_outline_outlined,
                          label: 'FAQ',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FAQScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dH * 0.01), // Reduced vertical spacing
                  ProfileActionTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    isFullWidth: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: dH * 0.01),
                  ProfileActionTile(
                    icon: Icons.verified_outlined,
                    label: 'App Version & Info',
                    isFullWidth: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppVersionScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: dH * 0.01),
                  ProfileActionTile(
                    icon: Icons.logout_outlined,
                    label: 'Logout',
                    isFullWidth: true,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: dH * 0.03),
          ],
        ),
      ),
    );
  }

  Widget profileTile({required IconData icon, required String label}) {
    double dW = MediaQuery.of(context).size.width;
    double dH = MediaQuery.of(context).size.height;

    return Container(
      width: 80,
      margin: EdgeInsets.only(right: dW * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFD2B193).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Color(0xFFB8956A)),
          ),
          SizedBox(height: dH * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget profileTileWithImage({bool selected = false}) {
    double dW = MediaQuery.of(context).size.width;

    return Container(
      width: 80,
      margin: EdgeInsets.only(right: dW * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: selected
            ? Border.all(color: const Color(0xFFD2B193), width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: selected
                ? Color(0xFFD2B193).withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: selected ? 15 : 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(dW * 0.025),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected ? null : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person,
              size: 32,
              color: selected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isFullWidth;
  final VoidCallback? onTap;

  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.isFullWidth = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double dW = MediaQuery.of(context).size.width;
    double dH = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth
            ? double.infinity
            : null, // Let Expanded handle width for grid items
        margin: EdgeInsets.symmetric(vertical: dH * 0.005),
        padding: EdgeInsets.symmetric(
          horizontal: dW * 0.025,
          vertical: dH * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 6,
              offset: Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD2B193).withOpacity(0.2),
                          Color(0xFFB8956A).withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFFD2B193).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(icon, color: Color(0xFFB8956A), size: 18),
                  ),
                  SizedBox(width: dW * 0.02),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.1,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (isFullWidth)
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFD2B193).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFFB8956A),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

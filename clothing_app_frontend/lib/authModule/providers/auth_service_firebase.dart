import 'package:clothing_app_frontend/authModule/screens/phone_number_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen2.dart';
import 'package:clothing_app_frontend/homeModule/screens/home_screen.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';

class AuthRepo {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static void verifyPhoneNumber(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+1 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(
          context,
          credential.verificationId!,
          credential.smsCode!,
          number,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The provided phone number is not valid.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return VerifyOtpScreen2(
                args: VerifyOtpArguments(mobileNo: number),
              );
            },
          ),
        );
        print("code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static void logoutApp(BuildContext context) async {
    await _firebaseAuth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const PhoneNumberScreen()),
    );
  }

  static void submitOtp(BuildContext context, String otp, String number) {
    signInWithPhoneNumber(context, verId, otp, number);
  }

  static Future<void> signInWithPhoneNumber(
    BuildContext context,
    String verificationId,
    String smsCode,
    String phoneNumber,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _firebaseAuth.signInWithCredential(credential);

      // Now call the loginUser API after Firebase auth
      final data = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).loginUser(context, phoneNumber);

      // Dismiss loading
      Navigator.of(context).pop();

      if (data['status'] == true) {
        // Navigate to home screen
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomeScreen()),

        // );
        pushAndRemoveUntil(
          NamedRoute.bottomNavBarScreen,
          arguments: BottomNavArgumnets(),
        );
      } else {
        // Show API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss loading if error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong.'),
          backgroundColor: Colors.red,
        ),
      );
      if (e is FirebaseAuthException) {
        print('Code: ${e.code}');
        print('Message: ${e.message}');
      }
    }
  }

  static int? _resendToken;

  static void resendOtp(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+1 $number',
      forceResendingToken: _resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(
          context,
          credential.verificationId!,
          credential.smsCode!,
          number,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The provided phone number is not valid.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        _resendToken = resendToken;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verId = verificationId;
      },
    );
  }
}

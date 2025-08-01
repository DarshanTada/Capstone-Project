import 'package:clothing_app_frontend/authModule/model/user_model.dart';

class SelectLanguageScreenArguments {
  final bool fromOnboarding;
  const SelectLanguageScreenArguments({this.fromOnboarding = false});
}

class BottomNavArgumnets {
  final int index;
  BottomNavArgumnets({this.index = 0});
}
class VerifyOtpArguments {
  final String mobileNo;
  // final String verificationId;
  // , required this.verificationId
  VerifyOtpArguments({required this.mobileNo});
}

class RegistrationArguments {
  final String mobileNo;
  RegistrationArguments({required this.mobileNo});
}

class LoadingScreenArguments {
  final String featureId;
  final String type;
  LoadingScreenArguments({required this.featureId, required this.type});
}

class PrivacyPolicyAndTcScreenArguments {
  final String contentType;
  final String title;
  PrivacyPolicyAndTcScreenArguments({
    required this.contentType,
    required this.title,
  });
}

class CafeImageArguments {
  final String otherPhoto;
  CafeImageArguments({required this.otherPhoto});
}

class MenuImageArguments {
  final String menuPhoto;
  MenuImageArguments({required this.menuPhoto});
}

class EditProfileScreenArguments {
  final User user;
  EditProfileScreenArguments({required this.user});
}

class ProductDetailScreenArguments{
  ProductDetailScreenArguments({
  Null
  });
}

class CategoryRelationScreenArguments{
    final String category ;
 CategoryRelationScreenArguments ({
required this.category
  });
}

class PaymentScreenArguments {
  final String orderId;
  final num amount;
  final String type;
  final Map transaction;
  // final List subscription;
  // final String subType;

  PaymentScreenArguments({
    required this.orderId,
    required this.amount,
    required this.type,
    required this.transaction,
    // this.subscription = const [],
    // this.subType = '',
  });
}

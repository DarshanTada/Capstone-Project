// import 'dart:io';

// import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
// import 'package:clothing_app_frontend/colors.dart';
// import 'package:clothing_app_frontend/common_functions.dart';
// import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:clothing_app_frontend/navigation/navigators.dart';
// import 'package:face_camera/face_camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class CaptureFaceScreen extends StatefulWidget {
//   const CaptureFaceScreen({Key? key}) : super(key: key);
//   @override
//   CaptureFaceScreenState createState() => CaptureFaceScreenState();
// }

// class CaptureFaceScreenState extends State<CaptureFaceScreen> {
//   double dH = 0.0;
//   double dW = 0.0;
//   double tS = 0.0;
//   TextTheme customTextTheme = const TextTheme();
//   Map language = {};
//   bool isLoading = false;
//   String imgPath = '';
//   late FaceCameraController _faceCameraController;

//   fetchData() async {}

//   pickImage(ImageSource source) async {
//     try {
//       ImagePicker picker = ImagePicker();
//       final image = await picker.pickImage(source: source);

//       setState(() {
//         imgPath = image?.path ?? '';
//       });
//       pop();
//       return image;
//     } catch (e) {
//       return null;
//     }
//   }

//   Widget getProfilePic({
//     required BuildContext context,
//     required String? name,
//     required String? avatar,
//     required double radius,
//     Color? backgroundColor,
//     double fontSize = 18,
//     FontWeight? fontWeight,
//     Color? fontColor,
//     required double tS,
//   }) {
//     return Stack(
//       alignment: Alignment.bottomRight,
//       children: [
//         Container(
//           width: radius,
//           height: radius,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color:
//                 backgroundColor ??
//                 Theme.of(context).primaryColor.withOpacity(0.2),
//           ),
//           child: avatar == null || avatar == ''
//               ? Text(
//                   name != null
//                       ? getInitials('DT')
//                       :
//                         //  getInitials(userName) :
//                         '',
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                     fontSize: tS * fontSize,
//                     fontWeight: fontWeight ?? FontWeight.w600,
//                     color: fontColor ?? Theme.of(context).primaryColor,
//                   ),
//                 )
//               : Container(
//                   width: radius,
//                   height: radius,
//                   decoration: const BoxDecoration(shape: BoxShape.circle),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image.file(
//                       File(imgPath),
//                       repeat: ImageRepeat.repeat,
//                       fit: BoxFit.cover,
//                       width: 32,
//                       height: 32,
//                     ),
//                   ),
//                 ),
//         ),
//         Container(
//           padding: EdgeInsets.all(dW * 0.02),
//           decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
//           child: const Icon(Icons.edit, color: Colors.white),
//         ),
//       ],
//     );
//   }

//   imagePicker(BuildContext ctx) {
//     showModalBottomSheet(
//       context: ctx,
//       builder: (BuildContext context) {
//         return SizedBox(
//           height: dH * .2,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: dW * .05),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: dW * .02),
//                 const Text(
//                   'Profile Photo',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: dW * .03),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     if (imgPath != '')
//                       Container(
//                         margin: EdgeInsets.only(right: dW * 0.05),
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() => imgPath = '');
//                             pop();
//                           },
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: dW * .08,
//                                 backgroundColor: Colors.grey.withOpacity(0.4),
//                                 child: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               SizedBox(height: dW * .02),
//                               const Text('Remove '),
//                               const Text('Photo'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     // SizedBox(width: dW * .05),
//                     GestureDetector(
//                       onTap: () => pickImage(ImageSource.gallery),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: dW * .08,
//                             backgroundColor: Colors.grey.withOpacity(0.4),
//                             child: const Icon(
//                               Icons.image,
//                               color: Colors.purple,
//                             ),
//                           ),
//                           SizedBox(height: dW * .02),
//                           const Text('Gallery'),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: dW * .05),
//                     GestureDetector(
//                       onTap: () => pickImage(ImageSource.camera),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: dW * .08,
//                             backgroundColor: Colors.grey.withOpacity(0.4),
//                             child: const Icon(
//                               Icons.camera_alt_rounded,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           SizedBox(height: dW * .02),
//                           const Text('Camera'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     _faceCameraController = FaceCameraController(
//       onCapture: (File? image) {
//         if (image != null && mounted) {
//           setState(() {
//             imgPath = image.path;
//           });
//         }
//       },
//     );

//     FaceCamera.initialize();

//     _faceCameraController.addListener(() {
//       // If you want to listen for other changes, do it here
//     });

//     fetchData();
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   Future.delayed(const Duration(seconds: 0), () {
//   //     if (mounted) imagePicker(context);
//   //   });
//   //   _faceCameraController = FaceCameraController(onCapture: (File? image) {});
//   //   FaceCamera.initialize();
//   //   fetchData();
//   // }

//   @override
//   void dispose() {
//     _faceCameraController.dispose();
//     super.dispose();
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
//                   SizedBox(height: dW * 0.05),
//                   TextWidget(title: 'Capture Face'),
//                   TextWidget(title: imgPath),
//                   Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       SmartFaceCamera(
//                         controller: _faceCameraController,
//                         showControls: false,
//                         indicatorShape: IndicatorShape.defaultShape,
//                         message:
//                             'Align your face in the oval and tap the button',
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 24),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: const CircleBorder(),
//                             padding: const EdgeInsets.all(20),
//                             backgroundColor: Colors.blue,
//                           ),
//                           onPressed: () {
//                             _faceCameraController.captureImage();
//                             // No await or assign here — the onCapture callback will update imgPath
//                           },
//                           child: const Icon(
//                             Icons.camera_alt,
//                             size: 32,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class CaptureFaceScreen extends StatefulWidget {
  @override
  _CaptureFaceScreenState createState() => _CaptureFaceScreenState();
}

class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
  late FaceCameraController _faceCameraController;
  String? _imagePath;
  bool _showFaceCamera = false;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    FaceCamera.initialize();
    _faceCameraController = FaceCameraController(
      onCapture: (File? image) async {
        if (image != null) {
          setState(() {
            _showFaceCamera = false;
            _imagePath = image.path;
            _isValidating = true;
          });

          bool valid = await validateFacePhoto(image);
          setState(() {
            _isValidating = false;
          });

          _showValidationDialog(valid);
        }
      },
    );
  }

  @override
  void dispose() {
    _faceCameraController.dispose();
    super.dispose();
  }

  Future<bool> validateFacePhoto(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final options = FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    );
    final faceDetector = FaceDetector(options: options);

    final List<Face> faces = await faceDetector.processImage(inputImage);

    await faceDetector.close();

    if (faces.length != 1) return false; // Exactly one face only

    final Face face = faces.first;

    // Example extra check: face frontal (yaw close to 0)
    if (face.headEulerAngleY != null && (face.headEulerAngleY!.abs() > 15)) {
      return false;
    }

    return true;
  }

  void _showValidationDialog(bool isValid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isValid ? 'Face Photo Valid' : 'Invalid Face Photo'),
        content: Text(
          isValid
              ? 'Your photo is valid with a single, frontal face.'
              : 'Please make sure there is only one face and it is frontal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        _imagePath = pickedImage.path;
        _showFaceCamera = false;
        _isValidating = true;
      });
      bool valid = await validateFacePhoto(imageFile);
      setState(() {
        _isValidating = false;
      });
      _showValidationDialog(valid);
    }
  }

  void _openFaceCamera() {
    setState(() {
      _showFaceCamera = true;
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Face Photo'),
        leading: _showFaceCamera
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(() => _showFaceCamera = false),
              )
            : null,
      ),
      body: _showFaceCamera
          ? Stack(
              children: [
                SmartFaceCamera(
                  controller: _faceCameraController,
                  showControls: false,
                  indicatorShape: IndicatorShape.defaultShape,
                  message: 'Align your face inside the oval and tap the button',
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                      onPressed: () => _faceCameraController.captureImage(),
                      child: Icon(Icons.camera_alt, size: 32),
                    ),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_imagePath != null) ...[
                    Image.file(
                      File(_imagePath!),
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_isValidating)
                    const CircularProgressIndicator()
                  else ...[
                    ElevatedButton.icon(
                      onPressed: _openFaceCamera,
                      icon: Icon(Icons.camera_alt),
                      label: Text('Open Face Camera'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: Icon(Icons.photo_library),
                      label: Text('Pick From Gallery'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

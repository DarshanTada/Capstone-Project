// import 'package:clothing_app_frontend/navigation/navigators.dart';
// import 'package:clothing_app_frontend/navigation/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:async';

// class CaptureFaceScreen extends StatefulWidget {
//   const CaptureFaceScreen({Key? key}) : super(key: key);

//   @override
//   State<CaptureFaceScreen> createState() => _CaptureFaceScreenState();
// }

// class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
//   String _selectedMode = ''; // 'camera' or 'gallery'

//   @override
//   Widget build(BuildContext context) {
//     if (_selectedMode.isEmpty) {
//       return _buildSelectionScreen();
//     } else if (_selectedMode == 'camera') {
//       return CameraCaptureScreen(
//         onBack: () {
//           setState(() {
//             _selectedMode = '';
//           });
//         },
//         onPhotoSaved: (String savedPath) {
//           _handlePhotoSaved(savedPath);
//         },
//       );
//     } else {
//       return GallerySelectionScreen(
//         onBack: () {
//           setState(() {
//             _selectedMode = '';
//           });
//         },
//         onPhotoSaved: (String savedPath) {
//           _handlePhotoSaved(savedPath);
//         },
//       );
//     }
//   }

//   void _handlePhotoSaved(String savedPath) {
//     // Handle the saved photo path - you can navigate to next screen,
//     // update user profile, etc.
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Selfie saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     Navigator.pushNamed(context, NamedRoute.preferenceScreen);
//   }

//   Widget _buildSelectionScreen() {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2D2D2D),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             children: [
//               // Header
//               const SizedBox(height: 40),
//               const Text(
//                 'Add Your Selfie',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Choose how you\'d like to add your selfie photo',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.grey[300],
//                   fontSize: 16,
//                   height: 1.4,
//                 ),
//               ),

//               const SizedBox(height: 60),

//               // Camera option
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedMode = 'camera';
//                   });
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.blue.withOpacity(0.3),
//                       width: 2,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: const Icon(
//                           Icons.camera_alt,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Take Photo',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Use your camera to take a new selfie with automatic face detection',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey[300],
//                           fontSize: 14,
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Gallery option
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedMode = 'gallery';
//                   });
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.green.withOpacity(0.3),
//                       width: 2,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: const Icon(
//                           Icons.photo_library,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Choose from Gallery',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Select an existing photo from your gallery with face validation',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey[300],
//                           fontSize: 14,
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const Spacer(),

//               // Skip button
//               GestureDetector(
//                 onTap: () => push(NamedRoute.preferenceScreen),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: Text(
//                     'Skip for now',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 16,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Photo Storage Helper Class
// class PhotoStorageHelper {
//   static const String _selfiePathKey = 'user_selfie_path';

//   // Save photo to app's document directory and store path in SharedPreferences
//   static Future<String> savePhoto(XFile photo) async {
//     try {
//       // Get app's document directory
//       final Directory appDocDir = await getApplicationDocumentsDirectory();
//       final String appDocPath = appDocDir.path;

//       // Create selfies directory if it doesn't exist
//       final Directory selfiesDir = Directory('$appDocPath/selfies');
//       if (!await selfiesDir.exists()) {
//         await selfiesDir.create(recursive: true);
//       }

//       // Generate unique filename with timestamp
//       final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//       final String fileName = 'selfie_$timestamp.jpg';
//       final String savedPath = '${selfiesDir.path}/$fileName';

//       // Copy the photo to the new location
//       final File originalFile = File(photo.path);
//       final File savedFile = await originalFile.copy(savedPath);

//       // Save the path in SharedPreferences
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_selfiePathKey, savedPath);

//       print('Photo saved to: $savedPath');
//       return savedPath;
//     } catch (e) {
//       print('Error saving photo: $e');
//       throw Exception('Failed to save photo: $e');
//     }
//   }

//   // Get saved selfie path from SharedPreferences
//   static Future<String?> getSavedSelfiePath() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       return prefs.getString(_selfiePathKey);
//     } catch (e) {
//       print('Error getting saved selfie path: $e');
//       return null;
//     }
//   }

//   // Check if saved selfie file still exists
//   static Future<bool> savedSelfieExists() async {
//     try {
//       final String? savedPath = await getSavedSelfiePath();
//       if (savedPath == null) return false;

//       final File file = File(savedPath);
//       return await file.exists();
//     } catch (e) {
//       print('Error checking if selfie exists: $e');
//       return false;
//     }
//   }

//   // Delete saved selfie
//   static Future<bool> deleteSavedSelfie() async {
//     try {
//       final String? savedPath = await getSavedSelfiePath();
//       if (savedPath == null) return false;

//       final File file = File(savedPath);
//       if (await file.exists()) {
//         await file.delete();
//       }

//       // Remove from SharedPreferences
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_selfiePathKey);

//       return true;
//     } catch (e) {
//       print('Error deleting saved selfie: $e');
//       return false;
//     }
//   }
// }

// // Camera Capture Screen
// class CameraCaptureScreen extends StatefulWidget {
//   final VoidCallback onBack;
//   final Function(String) onPhotoSaved;

//   const CameraCaptureScreen({
//     Key? key,
//     required this.onBack,
//     required this.onPhotoSaved,
//   }) : super(key: key);

//   @override
//   State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
// }

// class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
//   CameraController? _cameraController;
//   List<CameraDescription>? _cameras;
//   bool _isCameraInitialized = false;
//   bool _isCapturing = false;
//   bool _faceDetected = false;
//   bool _faceInPosition = false;
//   bool _isSaving = false;

//   // Face detection
//   FaceDetector? _faceDetector;
//   bool _faceDetectionWorking = false;

//   Timer? _faceCheckTimer;
//   int _stableFrameCount = 0;
//   static const int _requiredStableFrames = 3;
//   bool _isCheckingFace = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFaceDetector();
//     _initializeCamera();
//   }

//   void _initializeFaceDetector() {
//     try {
//       _faceDetector = FaceDetector(
//         options: FaceDetectorOptions(
//           enableContours: false,
//           enableLandmarks: false,
//           performanceMode: FaceDetectorMode.fast,
//           enableClassification: false,
//         ),
//       );
//     } catch (e) {
//       print('Face detector failed: $e');
//     }
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();

//       if (_cameras!.isNotEmpty) {
//         final frontCamera = _cameras!.firstWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.front,
//           orElse: () => _cameras!.first,
//         );

//         _cameraController = CameraController(
//           frontCamera,
//           ResolutionPreset.medium,
//           enableAudio: false,
//         );

//         await _cameraController!.initialize();
//         if (mounted) {
//           setState(() {
//             _isCameraInitialized = true;
//           });

//           await Future.delayed(const Duration(seconds: 1));
//           _startPeriodicFaceCheck();
//         }
//       }
//     } catch (e) {
//       print('Camera initialization error: $e');
//     }
//   }

//   void _startPeriodicFaceCheck() {
//     if (_faceDetector == null) {
//       setState(() {
//         _faceDetectionWorking = false;
//       });
//       return;
//     }

//     setState(() {
//       _faceDetectionWorking = true;
//     });

//     _faceCheckTimer = Timer.periodic(const Duration(milliseconds: 800), (
//       timer,
//     ) {
//       if (!_isCheckingFace &&
//           !_isCapturing &&
//           _cameraController != null &&
//           _cameraController!.value.isInitialized) {
//         _checkFaceInCurrentFrame();
//       }
//     });
//   }

//   Future<void> _checkFaceInCurrentFrame() async {
//     if (_isCheckingFace || _isCapturing || _cameraController == null) return;

//     _isCheckingFace = true;

//     try {
//       final XFile tempImage = await _cameraController!.takePicture();
//       final inputImage = InputImage.fromFilePath(tempImage.path);
//       final List<Face> faces = await _faceDetector!.processImage(inputImage);

//       try {
//         await File(tempImage.path).delete();
//       } catch (e) {
//         print('Error deleting temp file: $e');
//       }

//       _processFaces(faces);
//     } catch (e) {
//       setState(() {
//         _faceDetectionWorking = false;
//       });
//       _faceCheckTimer?.cancel();
//     } finally {
//       _isCheckingFace = false;
//     }
//   }

//   void _processFaces(List<Face> faces) {
//     bool faceDetected = faces.isNotEmpty;
//     bool faceInPosition = false;

//     if (faceDetected) {
//       final face = faces.first;
//       final faceRect = face.boundingBox;

//       final faceArea = faceRect.width * faceRect.height;
//       final minFaceArea = 8000;
//       final maxFaceArea = 250000;

//       faceInPosition = faceArea > minFaceArea && faceArea < maxFaceArea;
//     }

//     if (mounted) {
//       setState(() {
//         _faceDetected = faceDetected;
//         _faceInPosition = faceInPosition;
//       });

//       if (faceInPosition) {
//         _stableFrameCount++;
//         if (_stableFrameCount >= _requiredStableFrames && !_isCapturing) {
//           _autoCapture();
//         }
//       } else {
//         _stableFrameCount = 0;
//       }
//     }
//   }

//   Future<void> _autoCapture() async {
//     _faceCheckTimer?.cancel();
//     await _capturePhoto();
//   }

//   Future<void> _capturePhoto() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     setState(() {
//       _isCapturing = true;
//     });

//     try {
//       final XFile photo = await _cameraController!.takePicture();
//       _showCapturedImage(photo);
//     } catch (e) {
//       setState(() {
//         _isCapturing = false;
//       });

//       if (_faceDetectionWorking) {
//         await Future.delayed(const Duration(milliseconds: 500));
//         _startPeriodicFaceCheck();
//       }
//     }
//   }

//   void _manualCapture() {
//     _faceCheckTimer?.cancel();

//     if (_faceDetectionWorking && !_faceDetected) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please position your face in the circle first'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       _startPeriodicFaceCheck();
//       return;
//     }

//     _capturePhoto();
//   }

//   void _showCapturedImage(XFile photo) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.file(File(photo.path)),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: _isSaving
//                         ? null
//                         : () {
//                             Navigator.pop(context);
//                             setState(() {
//                               _isCapturing = false;
//                               _stableFrameCount = 0;
//                             });

//                             if (_faceDetectionWorking) {
//                               Future.delayed(
//                                 const Duration(milliseconds: 500),
//                                 () {
//                                   _startPeriodicFaceCheck();
//                                 },
//                               );
//                             }
//                           },
//                     child: const Text('Retake'),
//                   ),
//                   ElevatedButton(
//                     onPressed: _isSaving
//                         ? null
//                         : () async {
//                             await _saveAndAcceptPhoto(photo);
//                           },
//                     child: _isSaving
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text('Use Photo'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _saveAndAcceptPhoto(XFile photo) async {
//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       // Save the photo using PhotoStorageHelper
//       final String savedPath = await PhotoStorageHelper.savePhoto(photo);

//       Navigator.pop(context); // Close dialog
//       widget.onPhotoSaved(savedPath); // Notify parent with saved path
//     } catch (e) {
//       setState(() {
//         _isSaving = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error saving photo: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _faceCheckTimer?.cancel();
//     _cameraController?.dispose();
//     _faceDetector?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2D2D2D),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with back button
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: widget.onBack,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Text(
//                     'Take Selfie',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Instruction text
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 _isCapturing
//                     ? 'Capturing photo...'
//                     : !_faceDetectionWorking
//                     ? 'Position yourself and tap the capture button'
//                     : _faceDetected
//                     ? (_faceInPosition
//                           ? 'Perfect! Hold still for auto-capture...'
//                           : 'Center your face in the circle')
//                     : 'Position your face in the circle for auto-capture',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: _faceInPosition ? Colors.green[300] : Colors.grey[300],
//                   fontSize: 16,
//                   height: 1.4,
//                   fontWeight: _faceInPosition
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                 ),
//               ),
//             ),

//             // Camera preview
//             Expanded(
//               child: Stack(
//                 children: [
//                   if (_isCameraInitialized && _cameraController != null)
//                     Container(
//                       width: double.infinity,
//                       child: CameraPreview(_cameraController!),
//                     )
//                   else
//                     Container(
//                       width: double.infinity,
//                       color: Colors.black,
//                       child: const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       ),
//                     ),

//                   // Face guide overlay
//                   Center(
//                     child: CustomPaint(
//                       size: const Size(280, 350),
//                       painter: FaceGuidePainter(
//                         faceDetected: _faceDetected,
//                         faceInPosition: _faceInPosition,
//                         faceDetectionWorking: _faceDetectionWorking,
//                       ),
//                     ),
//                   ),

//                   // Manual capture button
//                   Positioned(
//                     bottom: 30,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: GestureDetector(
//                         onTap: _isCapturing ? null : _manualCapture,
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: (_faceDetectionWorking && !_faceDetected)
//                                 ? Colors.grey[600]
//                                 : Colors.white,
//                             border: Border.all(
//                               color: (_faceDetectionWorking && !_faceDetected)
//                                   ? Colors.grey[500]!
//                                   : Colors.grey[300]!,
//                               width: 4,
//                             ),
//                           ),
//                           child: _isCapturing
//                               ? const Center(
//                                   child: CircularProgressIndicator(
//                                     color: Colors.grey,
//                                   ),
//                                 )
//                               : Icon(
//                                   Icons.camera_alt,
//                                   size: 40,
//                                   color:
//                                       (_faceDetectionWorking && !_faceDetected)
//                                       ? Colors.grey[400]
//                                       : Colors.grey[700],
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Bottom status indicator
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: !_faceDetectionWorking
//                       ? Colors.grey.withOpacity(0.2)
//                       : _faceInPosition
//                       ? Colors.green.withOpacity(0.2)
//                       : _faceDetected
//                       ? Colors.orange.withOpacity(0.2)
//                       : Colors.red.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   !_faceDetectionWorking
//                       ? '⚠ Manual capture mode'
//                       : _faceInPosition
//                       ? '✓ Ready for auto-capture'
//                       : _faceDetected
//                       ? '⚠ Adjust your position'
//                       : '✗ No face detected',
//                   style: TextStyle(
//                     color: !_faceDetectionWorking
//                         ? Colors.grey[300]
//                         : _faceInPosition
//                         ? Colors.green[300]
//                         : _faceDetected
//                         ? Colors.orange[300]
//                         : Colors.red[300],
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Gallery Selection Screen
// class GallerySelectionScreen extends StatefulWidget {
//   final VoidCallback onBack;
//   final Function(String) onPhotoSaved;

//   const GallerySelectionScreen({
//     Key? key,
//     required this.onBack,
//     required this.onPhotoSaved,
//   }) : super(key: key);

//   @override
//   State<GallerySelectionScreen> createState() => _GallerySelectionScreenState();
// }

// class _GallerySelectionScreenState extends State<GallerySelectionScreen> {
//   final ImagePicker _imagePicker = ImagePicker();
//   FaceDetector? _faceDetector;
//   bool _isValidating = false;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFaceDetector();
//     _selectFromGallery();
//   }

//   void _initializeFaceDetector() {
//     try {
//       _faceDetector = FaceDetector(
//         options: FaceDetectorOptions(
//           enableContours: false,
//           enableLandmarks: false,
//           performanceMode: FaceDetectorMode.accurate,
//           enableClassification: false,
//         ),
//       );
//     } catch (e) {
//       print('Face detector initialization failed: $e');
//     }
//   }

//   Future<void> _selectFromGallery() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (image != null) {
//         await _validateGalleryImage(image);
//       } else {
//         widget.onBack();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error selecting image: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       widget.onBack();
//     }
//   }

//   Future<void> _validateGalleryImage(XFile imageFile) async {
//     if (_faceDetector == null) {
//       await _saveAndAcceptPhoto(imageFile);
//       return;
//     }

//     setState(() {
//       _isValidating = true;
//     });

//     try {
//       final inputImage = InputImage.fromFilePath(imageFile.path);
//       final List<Face> faces = await _faceDetector!.processImage(inputImage);

//       await _showGalleryValidationResult(imageFile, faces);
//     } catch (e) {
//       setState(() {
//         _isValidating = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Face validation unavailable - accepting image'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       await _saveAndAcceptPhoto(imageFile);
//     }
//   }

//   Future<void> _showGalleryValidationResult(
//     XFile imageFile,
//     List<Face> faces,
//   ) async {
//     setState(() {
//       _isValidating = false;
//     });

//     String validationMessage;
//     Color messageColor;
//     bool isValid = false;

//     if (faces.isEmpty) {
//       validationMessage =
//           'No face detected in the selected image. Please choose a clear selfie with your face visible.';
//       messageColor = Colors.red;
//     } else if (faces.length > 1) {
//       validationMessage =
//           'Multiple faces detected. Please choose an image with only your face.';
//       messageColor = Colors.orange;
//     } else {
//       final face = faces.first;
//       final faceRect = face.boundingBox;

//       final imageBytes = await File(imageFile.path).readAsBytes();
//       final image = await decodeImageFromList(imageBytes);
//       final imageSize = Size(image.width.toDouble(), image.height.toDouble());

//       final faceArea = faceRect.width * faceRect.height;
//       final imageArea = imageSize.width * imageSize.height;
//       final faceRatio = faceArea / imageArea;

//       if (faceRatio < 0.03) {
//         validationMessage =
//             'Face is too small in the image. Please choose a closer selfie.';
//         messageColor = Colors.orange;
//       } else if (faceRatio > 0.9) {
//         validationMessage =
//             'Face is too close. Please choose an image with more space around your face.';
//         messageColor = Colors.orange;
//       } else {
//         validationMessage = 'Great! Face detected successfully.';
//         messageColor = Colors.green;
//         isValid = true;
//       }
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Image.file(File(imageFile.path), fit: BoxFit.cover),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: messageColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: messageColor.withOpacity(0.3)),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           isValid ? Icons.check_circle : Icons.warning,
//                           color: messageColor,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             validationMessage,
//                             style: TextStyle(color: messageColor, fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TextButton(
//                         onPressed: _isSaving
//                             ? null
//                             : () {
//                                 Navigator.pop(context);
//                                 widget.onBack();
//                               },
//                         child: const Text('Go Back'),
//                       ),
//                       if (isValid)
//                         ElevatedButton(
//                           onPressed: _isSaving
//                               ? null
//                               : () async {
//                                   ;
//                                   await _saveAndAcceptPhoto(imageFile);
//                                 },
//                           child: _isSaving
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Text('Use This Photo'),
//                         )
//                       else
//                         ElevatedButton(
//                           onPressed: _isSaving
//                               ? null
//                               : () {
//                                   Navigator.pop(context);
//                                   _selectFromGallery();
//                                 },
//                           child: const Text('Try Again'),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _saveAndAcceptPhoto(XFile photo) async {
//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       // Save the photo using PhotoStorageHelper
//       final String savedPath = await PhotoStorageHelper.savePhoto(photo);
//       widget.onPhotoSaved(savedPath); // Notify parent with saved path
//     } catch (e) {
//       setState(() {
//         _isSaving = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error saving photo: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _faceDetector?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2D2D2D),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: widget.onBack,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Text(
//                     'Select from Gallery',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Loading content
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (_isValidating || _isSaving) ...[
//                       const CircularProgressIndicator(color: Colors.white),
//                       const SizedBox(height: 24),
//                       Text(
//                         _isSaving
//                             ? 'Saving photo...'
//                             : 'Validating face in image...',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ] else ...[
//                       const Icon(
//                         Icons.photo_library,
//                         color: Colors.white,
//                         size: 64,
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Opening Gallery...',
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FaceGuidePainter extends CustomPainter {
//   final bool faceDetected;
//   final bool faceInPosition;
//   final bool faceDetectionWorking;

//   FaceGuidePainter({
//     required this.faceDetected,
//     required this.faceInPosition,
//     required this.faceDetectionWorking,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = !faceDetectionWorking
//           ? Colors.grey[400]!
//           : faceInPosition
//           ? Colors.green
//           : faceDetected
//           ? Colors.orange
//           : Colors.grey[400]!
//       ..strokeWidth = 3.0
//       ..style = PaintingStyle.stroke;

//     final center = Offset(size.width / 2, size.height / 2);
//     final rect = Rect.fromCenter(
//       center: center,
//       width: size.width * 0.8,
//       height: size.height * 0.9,
//     );

//     if (faceInPosition) {
//       canvas.drawOval(rect, paint);
//     } else {
//       _drawDashedOval(canvas, rect, paint);
//     }
//   }

//   void _drawDashedOval(Canvas canvas, Rect rect, Paint paint) {
//     const dashWidth = 8.0;
//     const dashSpace = 6.0;

//     final path = Path()..addOval(rect);
//     final pathMetrics = path.computeMetrics();

//     for (final pathMetric in pathMetrics) {
//       double distance = 0.0;
//       bool draw = true;

//       while (distance < pathMetric.length) {
//         final length = draw ? dashWidth : dashSpace;
//         final nextDistance = distance + length;

//         if (draw) {
//           final extractPath = pathMetric.extractPath(
//             distance,
//             nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
//           );
//           canvas.drawPath(extractPath, paint);
//         }

//         distance = nextDistance;
//         draw = !draw;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(FaceGuidePainter oldDelegate) {
//     return oldDelegate.faceDetected != faceDetected ||
//         oldDelegate.faceInPosition != faceInPosition ||
//         oldDelegate.faceDetectionWorking != faceDetectionWorking;
//   }
// }

import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:clothing_app_frontend/preferenceModule/service/ml_preference_service.dart';
import 'package:clothing_app_frontend/preferenceModule/model/preference_model.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class CaptureFaceScreen extends StatefulWidget {
  const CaptureFaceScreen({super.key});

  @override
  State<CaptureFaceScreen> createState() => _CaptureFaceScreenState();
}

class _CaptureFaceScreenState extends State<CaptureFaceScreen> {
  String _selectedMode = ''; // 'camera' or 'gallery'

  @override
  Widget build(BuildContext context) {
    if (_selectedMode.isEmpty) {
      return _buildSelectionScreen();
    } else if (_selectedMode == 'camera') {
      return CameraCaptureScreen(
        onBack: () {
          setState(() {
            _selectedMode = '';
          });
        },
        onPhotoSaved: (String savedPath) {
          _handlePhotoSaved(savedPath);
        },
      );
    } else {
      return GallerySelectionScreen(
        onBack: () {
          setState(() {
            _selectedMode = '';
          });
        },
        onPhotoSaved: (String savedPath) {
          _handlePhotoSaved(savedPath);
        },
      );
    }
  }

  void _handlePhotoSaved(String savedPath) async {
    // Handle the saved photo path
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selfie saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Get the current user ID
    final userId = await MLPreferenceService.getCurrentUserId();
    
    if (userId != null) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing your preferences...'),
              ],
            ),
          ),
        );

        // Get base64 image
        final base64Image = await PhotoStorageHelper.getSavedSelfieAsBase64();
        
        if (base64Image != null) {
          // Analyze preferences using ML service
          final preferences = await MLPreferenceService.analyzeAndGetPreferences(
            userId: userId,
            imageBase64: base64Image,
          );

          // Close loading dialog
          Navigator.pop(context);

          if (preferences != null) {
            // Save preferences locally using extension
            await preferences.saveToPrefs();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Preferences analyzed and saved!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to analyze preferences. You can set them manually.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else {
          // Close loading dialog
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get image data. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Close loading dialog if open
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    // Navigate to preference screen after photo is saved
    Navigator.pushNamed(context, NamedRoute.preferenceScreen);
  }

  Widget _buildSelectionScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 40),
              const Text(
                'Add Your Selfie',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose how you\'d like to add your selfie photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 60),

              // Camera option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMode = 'camera';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Take Photo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use your camera to take a new selfie with automatic face detection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Gallery option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMode = 'gallery';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose from Gallery',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select an existing photo from your gallery with face validation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Skip button
              GestureDetector(
                onTap: () => push(NamedRoute.preferenceScreen),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Skip for now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Photo Storage Helper Class
class PhotoStorageHelper {
  static const String _selfiePathKey = 'user_selfie_path';

  // Save photo to app's document directory and store path in SharedPreferences
  static Future<String> savePhoto(XFile photo) async {
    try {
      // Get app's document directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      // Create selfies directory if it doesn't exist
      final Directory selfiesDir = Directory('$appDocPath/selfies');
      if (!await selfiesDir.exists()) {
        await selfiesDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'selfie_$timestamp.jpg';
      final String savedPath = '${selfiesDir.path}/$fileName';

      // Copy the photo to the new location
      final File originalFile = File(photo.path);
      await originalFile.copy(savedPath);

      // Save the path in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selfiePathKey, savedPath);

      print('Photo saved to: $savedPath');
      return savedPath;
    } catch (e) {
      print('Error saving photo: $e');
      throw Exception('Failed to save photo: $e');
    }
  }

  // Get saved selfie path from SharedPreferences
  static Future<String?> getSavedSelfiePath() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selfiePathKey);
    } catch (e) {
      print('Error getting saved selfie path: $e');
      return null;
    }
  }

  // Check if saved selfie file still exists
  static Future<bool> savedSelfieExists() async {
    try {
      final String? savedPath = await getSavedSelfiePath();
      if (savedPath == null) return false;

      final File file = File(savedPath);
      return await file.exists();
    } catch (e) {
      print('Error checking if selfie exists: $e');
      return false;
    }
  }

  // Delete saved selfie
  static Future<bool> deleteSavedSelfie() async {
    try {
      final String? savedPath = await getSavedSelfiePath();
      if (savedPath == null) return false;

      final File file = File(savedPath);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selfiePathKey);

      return true;
    } catch (e) {
      print('Error deleting saved selfie: $e');
      return false;
    }
  }

  // Get saved selfie as Base64 string
  static Future<String?> getSavedSelfieAsBase64() async {
    try {
      final String? savedPath = await getSavedSelfiePath();
      if (savedPath == null) return null;

      final File file = File(savedPath);
      if (!await file.exists()) return null;

      // Read file as bytes and convert to base64
      final List<int> imageBytes = await file.readAsBytes();
      final String base64String = base64Encode(imageBytes);
      
      return base64String;
    } catch (e) {
      print('Error getting saved selfie as base64: $e');
      return null;
    }
  }

  // Get saved selfie file directly
  static Future<File?> getSavedSelfieFile() async {
    try {
      final String? savedPath = await getSavedSelfiePath();
      if (savedPath == null) return null;

      final File file = File(savedPath);
      if (!await file.exists()) return null;

      return file;
    } catch (e) {
      print('Error getting saved selfie file: $e');
      return null;
    }
  }
}

// Camera Capture Screen
class CameraCaptureScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onPhotoSaved;

  const CameraCaptureScreen({
    super.key,
    required this.onBack,
    required this.onPhotoSaved,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _faceDetected = false;
  bool _faceInPosition = false;
  bool _isSaving = false;

  // Face detection
  FaceDetector? _faceDetector;
  bool _faceDetectionWorking = false;

  Timer? _faceCheckTimer;
  int _stableFrameCount = 0;
  static const int _requiredStableFrames = 3;
  bool _isCheckingFace = false;

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera();
  }

  void _initializeFaceDetector() {
    try {
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: false,
          enableLandmarks: false,
          performanceMode: FaceDetectorMode.fast,
          enableClassification: false,
        ),
      );
    } catch (e) {
      print('Face detector failed: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras!.isNotEmpty) {
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg, // Specify format to reduce buffer issues
        );

        await _cameraController!.initialize();
        
        // Configure camera for better buffer management
        try {
          await _cameraController!.setFlashMode(FlashMode.off);
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setExposureMode(ExposureMode.auto);
        } catch (e) {
          print('Error configuring camera settings: $e');
        }
        
        // Add a longer delay to ensure camera is fully ready and buffers are initialized
        await Future.delayed(const Duration(milliseconds: 1000));
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });

          // Wait longer before starting face detection to avoid initial buffer conflicts
          await Future.delayed(const Duration(seconds: 1500));
          if (mounted && !_isCapturing && !_isSaving) {
            _startPeriodicFaceCheck();
          }
        }
      }
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startPeriodicFaceCheck() {
    if (_faceDetector == null) {
      setState(() {
        _faceDetectionWorking = false;
      });
      return;
    }

    setState(() {
      _faceDetectionWorking = true;
    });

    // Increase interval to reduce buffer pressure and add additional safety checks
    _faceCheckTimer = Timer.periodic(const Duration(milliseconds: 1200), (
      timer,
    ) {
      if (!_isCheckingFace &&
          !_isCapturing &&
          !_isSaving &&
          _cameraController != null &&
          _cameraController!.value.isInitialized &&
          mounted) {
        _checkFaceInCurrentFrame();
      }
    });
  }

  Future<void> _checkFaceInCurrentFrame() async {
    if (_isCheckingFace || _isCapturing || _isSaving || _cameraController == null || !mounted) return;

    _isCheckingFace = true;

    try {
      // Add a small delay to prevent rapid consecutive captures
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (!mounted || _isCapturing || _isSaving) {
        _isCheckingFace = false;
        return;
      }
      
      final XFile tempImage = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(tempImage.path);
      final List<Face> faces = await _faceDetector!.processImage(inputImage);

      // Clean up temp file immediately to free resources
      try {
        await File(tempImage.path).delete();
      } catch (e) {
        print('Error deleting temp file: $e');
      }

      if (mounted) {
        _processFaces(faces);
      }
    } catch (e) {
      print('Error in face detection: $e');
      // Stop face detection on error to prevent continuous buffer issues
      if (mounted) {
        setState(() {
          _faceDetectionWorking = false;
        });
        _faceCheckTimer?.cancel();
        
        // Restart after a longer delay to let buffers clear
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isCapturing && !_isSaving) {
            _startPeriodicFaceCheck();
          }
        });
      }
    } finally {
      _isCheckingFace = false;
    }
  }

  void _processFaces(List<Face> faces) {
    bool faceDetected = faces.isNotEmpty;
    bool faceInPosition = false;

    if (faceDetected) {
      final face = faces.first;
      final faceRect = face.boundingBox;

      final faceArea = faceRect.width * faceRect.height;
      final minFaceArea = 8000;
      final maxFaceArea = 250000;

      faceInPosition = faceArea > minFaceArea && faceArea < maxFaceArea;
    }

    if (mounted) {
      setState(() {
        _faceDetected = faceDetected;
        _faceInPosition = faceInPosition;
      });

      if (faceInPosition) {
        _stableFrameCount++;
        if (_stableFrameCount >= _requiredStableFrames && !_isCapturing) {
          _autoCapture();
        }
      } else {
        _stableFrameCount = 0;
      }
    }
  }

  Future<void> _autoCapture() async {
    _faceCheckTimer?.cancel();
    await _capturePhoto();
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera not initialized for capture');
      return;
    }

    // Stop face detection completely to free up all camera resources
    _faceCheckTimer?.cancel();
    _faceDetectionWorking = false;
    _isCheckingFace = false;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Add a longer delay to ensure all background camera operations have stopped
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      
      print('📸 Taking picture...');
      final XFile photo = await _cameraController!.takePicture();
      print('✅ Picture taken successfully: ${photo.path}');
      
      if (mounted) {
        _showCapturedImage(photo);
      }
    } catch (e) {
      print('❌ Error capturing photo: $e');
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });

        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture photo: $e'),
            backgroundColor: Colors.red,
          ),
        );

        // Restart face detection after a longer delay to let system recover
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _faceDetector != null && !_isCapturing && !_isSaving) {
            _startPeriodicFaceCheck();
          }
        });
      }
    }
  }

  void _manualCapture() {
    _faceCheckTimer?.cancel();

    if (_faceDetectionWorking && !_faceDetected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please position your face in the circle first'),
          backgroundColor: Colors.red,
        ),
      );
      _startPeriodicFaceCheck();
      return;
    }

    _capturePhoto();
  }

  void _showCapturedImage(XFile photo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(photo.path)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            Navigator.pop(context);
                            setState(() {
                              _isCapturing = false;
                              _stableFrameCount = 0;
                            });

                            if (_faceDetectionWorking) {
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  _startPeriodicFaceCheck();
                                },
                              );
                            }
                          },
                    child: const Text('Retake'),
                  ),
                  ElevatedButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            await _saveAndAcceptPhoto(photo);
                          },
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Use Photo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAndAcceptPhoto(XFile photo) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Save the photo using PhotoStorageHelper
      final String savedPath = await PhotoStorageHelper.savePhoto(photo);

      Navigator.pop(context); // Close dialog
      widget.onPhotoSaved(
        savedPath,
      ); // This will trigger navigation to preference screen
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Stop any ongoing timers first
    _faceCheckTimer?.cancel();
    
    // Stop image stream processing if active
    _faceDetectionWorking = false;
    _isCheckingFace = false;
    
    // Clean up camera controller
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized) {
        _cameraController!.stopImageStream().catchError((e) {
          print('Error stopping image stream: $e');
        });
      }
      _cameraController!.dispose().catchError((e) {
        print('Error disposing camera: $e');
      });
    }
    
    // Clean up face detector
    _faceDetector?.close().catchError((e) {
      print('Error closing face detector: $e');
    });
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Take Selfie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Instruction text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _isCapturing
                    ? 'Capturing photo...'
                    : !_faceDetectionWorking
                    ? 'Position yourself and tap the capture button'
                    : _faceDetected
                    ? (_faceInPosition
                          ? 'Perfect! Hold still for auto-capture...'
                          : 'Center your face in the circle')
                    : 'Position your face in the circle for auto-capture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _faceInPosition ? Colors.green[300] : Colors.grey[300],
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: _faceInPosition
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),

            // Camera preview
            Expanded(
              child: Stack(
                children: [
                  if (_isCameraInitialized && _cameraController != null)
                    SizedBox(
                      width: double.infinity,
                      child: CameraPreview(_cameraController!),
                    )
                  else
                    Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),

                  // Face guide overlay
                  Center(
                    child: CustomPaint(
                      size: const Size(280, 350),
                      painter: FaceGuidePainter(
                        faceDetected: _faceDetected,
                        faceInPosition: _faceInPosition,
                        faceDetectionWorking: _faceDetectionWorking,
                      ),
                    ),
                  ),

                  // Manual capture button
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _isCapturing ? null : _manualCapture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (_faceDetectionWorking && !_faceDetected)
                                ? Colors.grey[600]
                                : Colors.white,
                            border: Border.all(
                              color: (_faceDetectionWorking && !_faceDetected)
                                  ? Colors.grey[500]!
                                  : Colors.grey[300]!,
                              width: 4,
                            ),
                          ),
                          child: _isCapturing
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color:
                                      (_faceDetectionWorking && !_faceDetected)
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom status indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: !_faceDetectionWorking
                      ? Colors.grey.withOpacity(0.2)
                      : _faceInPosition
                      ? Colors.green.withOpacity(0.2)
                      : _faceDetected
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  !_faceDetectionWorking
                      ? '⚠ Manual capture mode'
                      : _faceInPosition
                      ? '✓ Ready for auto-capture'
                      : _faceDetected
                      ? '⚠ Adjust your position'
                      : '✗ No face detected',
                  style: TextStyle(
                    color: !_faceDetectionWorking
                        ? Colors.grey[300]
                        : _faceInPosition
                        ? Colors.green[300]
                        : _faceDetected
                        ? Colors.orange[300]
                        : Colors.red[300],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Gallery Selection Screen
class GallerySelectionScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onPhotoSaved;

  const GallerySelectionScreen({
    super.key,
    required this.onBack,
    required this.onPhotoSaved,
  });

  @override
  State<GallerySelectionScreen> createState() => _GallerySelectionScreenState();
}

class _GallerySelectionScreenState extends State<GallerySelectionScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  FaceDetector? _faceDetector;
  bool _isValidating = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _selectFromGallery();
  }

  void _initializeFaceDetector() {
    try {
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: false,
          enableLandmarks: false,
          performanceMode: FaceDetectorMode.accurate,
          enableClassification: false,
        ),
      );
    } catch (e) {
      print('Face detector initialization failed: $e');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _validateGalleryImage(image);
      } else {
        widget.onBack();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      widget.onBack();
    }
  }

  Future<void> _validateGalleryImage(XFile imageFile) async {
    if (_faceDetector == null) {
      await _saveAndAcceptPhoto(imageFile);
      return;
    }

    setState(() {
      _isValidating = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector!.processImage(inputImage);

      await _showGalleryValidationResult(imageFile, faces);
    } catch (e) {
      setState(() {
        _isValidating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Face validation unavailable - accepting image'),
          backgroundColor: Colors.orange,
        ),
      );
      await _saveAndAcceptPhoto(imageFile);
    }
  }

  Future<void> _showGalleryValidationResult(
    XFile imageFile,
    List<Face> faces,
  ) async {
    setState(() {
      _isValidating = false;
    });

    String validationMessage;
    Color messageColor;
    bool isValid = false;

    if (faces.isEmpty) {
      validationMessage =
          'No face detected in the selected image. Please choose a clear selfie with your face visible.';
      messageColor = Colors.red;
    } else if (faces.length > 1) {
      validationMessage =
          'Multiple faces detected. Please choose an image with only your face.';
      messageColor = Colors.orange;
    } else {
      final face = faces.first;
      final faceRect = face.boundingBox;

      final imageBytes = await File(imageFile.path).readAsBytes();
      final image = await decodeImageFromList(imageBytes);
      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final faceArea = faceRect.width * faceRect.height;
      final imageArea = imageSize.width * imageSize.height;
      final faceRatio = faceArea / imageArea;

      if (faceRatio < 0.03) {
        validationMessage =
            'Face is too small in the image. Please choose a closer selfie.';
        messageColor = Colors.orange;
      } else if (faceRatio > 0.9) {
        validationMessage =
            'Face is too close. Please choose an image with more space around your face.';
        messageColor = Colors.orange;
      } else {
        validationMessage = 'Great! Face detected successfully.';
        messageColor = Colors.green;
        isValid = true;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.file(File(imageFile.path), fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: messageColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: messageColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.warning,
                          color: messageColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            validationMessage,
                            style: TextStyle(color: messageColor, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                Navigator.pop(context);
                                widget.onBack();
                              },
                        child: const Text('Go Back'),
                      ),
                      if (isValid)
                        ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  Navigator.pop(context);
                                  await _saveAndAcceptPhoto(imageFile);
                                },
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Use This Photo'),
                        )
                      else
                        ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _selectFromGallery();
                                },
                          child: const Text('Try Again'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAndAcceptPhoto(XFile photo) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Save the photo using PhotoStorageHelper
      final String savedPath = await PhotoStorageHelper.savePhoto(photo);
      widget.onPhotoSaved(
        savedPath,
      ); // This will trigger navigation to preference screen
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Select from Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Loading content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isValidating || _isSaving) ...[
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        _isSaving
                            ? 'Saving photo...'
                            : 'Validating face in image...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Opening Gallery...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceGuidePainter extends CustomPainter {
  final bool faceDetected;
  final bool faceInPosition;
  final bool faceDetectionWorking;

  FaceGuidePainter({
    required this.faceDetected,
    required this.faceInPosition,
    required this.faceDetectionWorking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = !faceDetectionWorking
          ? Colors.grey[400]!
          : faceInPosition
          ? Colors.green
          : faceDetected
          ? Colors.orange
          : Colors.grey[400]!
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.8,
      height: size.height * 0.9,
    );

    if (faceInPosition) {
      canvas.drawOval(rect, paint);
    } else {
      _drawDashedOval(canvas, rect, paint);
    }
  }

  void _drawDashedOval(Canvas canvas, Rect rect, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;

    final path = Path()..addOval(rect);
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        final nextDistance = distance + length;

        if (draw) {
          final extractPath = pathMetric.extractPath(
            distance,
            nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
          );
          canvas.drawPath(extractPath, paint);
        }

        distance = nextDistance;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(FaceGuidePainter oldDelegate) {
    return oldDelegate.faceDetected != faceDetected ||
        oldDelegate.faceInPosition != faceInPosition ||
        oldDelegate.faceDetectionWorking != faceDetectionWorking;
  }
}

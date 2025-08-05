import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:clothing_app_frontend/preferenceModule/service/ml_preference_service.dart';
import 'package:clothing_app_frontend/preferenceModule/model/preference_model.dart';
import 'package:clothing_app_frontend/authModule/screens/capture_face_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class CaptureBodyScreen extends StatefulWidget {
  const CaptureBodyScreen({super.key});

  @override
  State<CaptureBodyScreen> createState() => _CaptureBodyScreenState();
}

class _CaptureBodyScreenState extends State<CaptureBodyScreen> {
  String _selectedMode = ''; // 'camera' or 'gallery'

  @override
  Widget build(BuildContext context) {
    if (_selectedMode.isEmpty) {
      return _buildSelectionScreen();
    } else if (_selectedMode == 'camera') {
      return CameraCaptureBodyScreen(
        onBack: () {
          setState(() {
            _selectedMode = '';
          });
        },
        onPhotoSaved: _handlePhotoSaved,
      );
    } else {
      return GallerySelectionBodyScreen(
        onBack: () {
          setState(() {
            _selectedMode = '';
          });
        },
        onPhotoSaved: _handlePhotoSaved,
      );
    }
  }

  void _handlePhotoSaved(String savedPath) async {
    // Handle the saved photo path
    print('📸 Body image saved at: $savedPath');
    
    // Check if widget is still mounted before using context
    if (!mounted) return;

    // Get the current user ID
    final userId = await MLPreferenceService.getCurrentUserId();
    print('👤 Current user ID: $userId');
    
    if (userId != null) {
      try {
        print('🤖 Starting ML analysis with combined images...');
        
        // Check if widget is still mounted before showing dialog
        if (!mounted) return;
        
        // Show analyzing dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8956A)),
                ),
                SizedBox(height: 20),
                Text(
                  'Analyzing your preferences...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Processing face and body images',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );

        // Get combined base64 image (face + body side by side)
        final combinedBase64Image = await PhotoStorageHelper.getCombinedImagesAsBase64();
        print('📊 Combined base64 image obtained: ${combinedBase64Image != null}');
        
        if (combinedBase64Image != null) {
          print('🔬 Calling ML analysis service with combined image...');
          
          // Analyze preferences using ML service with combined image
          final preferences = await MLPreferenceService.analyzeAndGetPreferences(
            userId: userId,
            imageBase64: combinedBase64Image,
          );

          print('📋 ML analysis result: ${preferences != null}');

          // Check if widget is still mounted before closing dialog
          if (!mounted) return;

          // Close loading dialog
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          if (preferences != null) {
            print('✅ Preferences analyzed successfully');
            
            // Save preferences locally using extension
            await preferences.saveToPrefs();
            
            print('✅ Preferences analyzed and saved!');
          } else {
            print('⚠️ ML analysis failed - will allow manual preference setting');
          }
        } else {
          print('❌ Failed to get combined base64 image');
          
          // Check if widget is still mounted before closing dialog
          if (!mounted) return;
          
          // Close loading dialog
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print('💥 Error during ML analysis: $e');
        
        // Check if widget is still mounted before closing dialog
        if (!mounted) return;
        
        // Close loading dialog if open
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } else {
      print('❌ No user ID found - will allow manual preference setting');
    }

    // Wait a moment before navigation
    await Future.delayed(Duration(milliseconds: 500));

    // Check if widget is still mounted before navigation
    if (!mounted) return;

    // Navigate to preference screen after photo is saved and analyzed
    print('🧭 Navigating to preference screen...');
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                    'Full Body Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.accessibility_new,
                      color: Color(0xFFB8956A),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Full Body Photo Required',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please take or select a full body photo for better style analysis. Make sure your entire body is visible in the frame.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Camera option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMode = 'camera';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB8956A), Color(0xFF8B6F47)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB8956A).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Take Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Use camera to take a full body photo',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Gallery option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMode = 'gallery';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose from Gallery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Select an existing full body photo',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Camera Capture Screen for Body
class CameraCaptureBodyScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onPhotoSaved;

  const CameraCaptureBodyScreen({
    super.key,
    required this.onBack,
    required this.onPhotoSaved,
  });

  @override
  State<CameraCaptureBodyScreen> createState() => _CameraCaptureBodyScreenState();
}

class _CameraCaptureBodyScreenState extends State<CameraCaptureBodyScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras!.isNotEmpty) {
        // Use back camera for full body photos
        final backCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          backCamera,
          ResolutionPreset.high, // Higher resolution for body photos
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
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

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera not initialized for capture');
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      print('📸 Taking full body picture...');
      final XFile photo = await _cameraController!.takePicture();
      print('✅ Full body picture taken successfully: ${photo.path}');
      
      if (mounted) {
        _showCapturedImage(photo);
      }
    } catch (e) {
      print('❌ Error capturing photo: $e');
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCapturedImage(XFile photo) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.file(File(photo.path), fit: BoxFit.cover),
            ),
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
                            });
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
      if (!mounted) return;
      
      // Show analyzing popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF5D4E75),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Saving body photo...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Save the body photo using PhotoStorageHelper
      final String savedPath = await PhotoStorageHelper.saveBodyPhoto(photo);

      if (!mounted) return;
      
      // Close analyzing popup
      Navigator.pop(context);
      
      // Close the camera screen dialog
      Navigator.pop(context);

      widget.onPhotoSaved(savedPath);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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
                    'Take Full Body Photo',
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
                    : 'Position yourself so your full body is visible in the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                  height: 1.4,
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

                  // Body guide overlay
                  Center(
                    child: CustomPaint(
                      size: const Size(200, 400),
                      painter: BodyGuidePainter(),
                    ),
                  ),

                  // Capture button
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _isCapturing ? null : _capturePhoto,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[300]!,
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
                                  color: Colors.grey[700],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom instruction
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '📱 Stand back and ensure your full body is visible',
                  style: TextStyle(
                    color: Colors.blue[300],
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

// Gallery Selection Screen for Body
class GallerySelectionBodyScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onPhotoSaved;

  const GallerySelectionBodyScreen({
    super.key,
    required this.onBack,
    required this.onPhotoSaved,
  });

  @override
  State<GallerySelectionBodyScreen> createState() => _GallerySelectionBodyScreenState();
}

class _GallerySelectionBodyScreenState extends State<GallerySelectionBodyScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectFromGallery();
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _saveAndAcceptPhoto(image);
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

  Future<void> _saveAndAcceptPhoto(XFile photo) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final String savedPath = await PhotoStorageHelper.saveBodyPhoto(photo);
      widget.onPhotoSaved(savedPath);
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
                    'Select Body Photo',
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
                    if (_isSaving) ...[
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        'Saving photo...',
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

// Body Guide Painter for the overlay
class BodyGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw a simple human silhouette guide
    final center = Offset(size.width / 2, size.height / 2);
    
    // Head
    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.35),
      size.width * 0.08,
      paint,
    );
    
    // Body (rectangle)
    final bodyRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.4,
      height: size.height * 0.5,
    );
    canvas.drawRect(bodyRect, paint);
    
    // Arms
    canvas.drawLine(
      Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.15),
      Offset(center.dx - size.width * 0.35, center.dy + size.height * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.15),
      Offset(center.dx + size.width * 0.35, center.dy + size.height * 0.1),
      paint,
    );
    
    // Legs
    canvas.drawLine(
      Offset(center.dx - size.width * 0.1, center.dy + size.height * 0.25),
      Offset(center.dx - size.width * 0.1, center.dy + size.height * 0.45),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + size.width * 0.1, center.dy + size.height * 0.25),
      Offset(center.dx + size.width * 0.1, center.dy + size.height * 0.45),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

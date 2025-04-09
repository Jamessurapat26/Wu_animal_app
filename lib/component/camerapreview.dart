import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CameraPreviewWithBox extends StatefulWidget {
  @override
  _CameraPreviewWithBoxState createState() => _CameraPreviewWithBoxState();
}

class _CameraPreviewWithBoxState extends State<CameraPreviewWithBox> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Timer? _captureTimer;
  String? _latestImagePath;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _stopCapturing();
    _controller.dispose();
    super.dispose();
  }

  void _startCapturing() {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    _captureTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_controller.value.isInitialized) return;

      try {
        final image = await _controller.takePicture();

        // Save to app directory instead of assets
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'latest_capture.jpg';
        final savedImagePath = '${directory.path}/$fileName';

        // Copy the captured image to our destination
        await File(image.path).copy(savedImagePath);

        // Delete the original temporary file
        await File(image.path).delete();

        setState(() {
          _latestImagePath = savedImagePath;
        });

        print('Image saved to: $savedImagePath');
      } catch (e) {
        print('Error capturing image: $e');
      }
    });
  }

  void _stopCapturing() {
    _captureTimer?.cancel();
    _captureTimer = null;
    setState(() {
      _isCapturing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Camera title with capture controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Camera",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    fontSize: 28.0,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isCapturing ? Icons.stop : Icons.play_arrow,
                        color: _isCapturing ? Colors.red : theme.primaryColor,
                      ),
                      onPressed: () {
                        _isCapturing ? _stopCapturing() : _startCapturing();
                      },
                    ),
                    if (_isCapturing)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Camera preview container
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Camera ready - display with frame detection box overlay
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_controller),

                          // Detection box
                          Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          // Capturing indicator
                          if (_isCapturing)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "REC",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Instructions
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Position animal within frame",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      // Error state
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.white54,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Camera unavailable",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Loading state
                      return Container(
                        color: Colors.black87,
                        child: Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            // Display the latest captured image
            if (_latestImagePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Captured",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.file(
                          File(_latestImagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../component/descript.dart';
import '../component/camerapreview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WU Animal App',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.3),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/bg.png', // Make sure this asset exists in your pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),

          // Optional overlay to dim the background slightly
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.1),
          ),

          // Main content
          SafeArea(
            child: Row(
              children: [
                // Left column
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CameraPreviewWithBox(),
                  ),
                ),

                // Right column
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Descript(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Row(
        children: [
          //Left column
          Expanded(flex: 1, child: CameraPreviewWithBox()),
          //Right column
          Expanded(child: const Descript()),
        ],
      ),
    );
  }
}

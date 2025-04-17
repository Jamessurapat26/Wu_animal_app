import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class Classifier {
  late Interpreter _interpreter;
  late List<String> _labels;
  final int inputSize = 224;

  bool _isModelLoaded = false;

  Future<void> _loadModel() async {
    if (_isModelLoaded) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/mobilenet_v1_1.0_224.tflite',
    );

    final labelData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelData.split('\n');
    _isModelLoaded = true;
  }

  Future<Map<String, String>> predictAnimal() async {
    try {
      await _loadModel();

      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = await directory.list().toList();
      final List<File> images =
          files.whereType<File>().where((file) {
            final ext = file.path.split('.').last.toLowerCase();
            return ['jpg', 'jpeg', 'png'].contains(ext);
          }).toList();

      if (images.isEmpty) {
        return {'error': 'No image found in directory'};
      }

      final latestImage = images.last;
      final bytes = await latestImage.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return {'error': 'Cannot decode image'};

      final resized = img.copyResize(
        image,
        width: inputSize,
        height: inputSize,
      );

      final input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(inputSize, (x) {
            final pixel = resized.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      final output = List.generate(1, (_) => List.filled(1001, 0.0));
      _interpreter.run(input, output);

      final result = _processOutput(output[0]);

      print("Prediction result: $result");

      return {
        'animal': result['label'],
        // 'confidence': result['confidence'].toStringAsFixed(2),
        'description':
            'The lion is a species in the family Felidae and a member of the genus Panthera.',
        'Habitat':
            'Lions inhabit grasslands, savannas, and shrublands. Usually found in sub-Saharan Africa.',
        'imagePath': latestImage.path,
      };
    } catch (e) {
      print("Error during prediction: $e");
      return {'error': 'Prediction error: $e'};
    }
  }

  Map<String, dynamic> _processOutput(List<double> output) {
    int maxIndex = 0;
    double maxConfidence = 0;

    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxConfidence) {
        maxConfidence = output[i];
        maxIndex = i;
      }
    }

    return {'label': _labels[maxIndex], 'confidence': maxConfidence};
  }
}

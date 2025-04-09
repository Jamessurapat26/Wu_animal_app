import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class ClassNamesifier {
  ClassificationModel? _model;
  final mean = [0.5, 0.5, 0.5];
  final std = [0.5, 0.5, 0.5];

  Future<void> _initModel() async {
    if (_model != null) return;

    _model = await PytorchLite.loadClassificationModel(
      "assets/mobilenet_v2.pt",
      224,
      224,
      1000,
      labelPath: "assets/labels.txt",
    );
  }

  Future<Map<String, String>> predictAnimal() async {
    try {
      await _initModel();

      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      final List<FileSystemEntity> entities = await dir.list().toList();
      final List<File> images =
          entities.whereType<File>().where((file) {
            final extension = file.path.split('.').last.toLowerCase();
            return ['jpg', 'jpeg', 'png'].contains(extension);
          }).toList();

      if (images.isEmpty) {
        return {'error': 'No images found in directory'};
      }

      // Get the latest image
      final latestImage = images.last;
      final Uint8List imageBytes = await latestImage.readAsBytes();

      final prediction = await _model?.getImagePrediction(
        imageBytes,
        mean: mean,
        std: std,
        preProcessingMethod: PreProcessingMethod.imageLib,
      );

      if (prediction == null) {
        return {'error': 'Failed to get prediction'};
      }

      return {
        'animal': prediction.toString(),
        'description':
            'The lion is a species in the family Felidae and a member of the genus Panthera. It is the second-largest big cat species in the world after the tiger.',
        'Habitat':
            'test Lions inhabit grasslands, savannas, and shrublands. They are usually found in sub-Saharan Africa.',
        'imagePath': latestImage.path,
      };
    } catch (e) {
      print('Error during prediction: $e');
      return {'error': 'Error during prediction: $e'};
    }
  }
}

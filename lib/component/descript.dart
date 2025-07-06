import 'dart:async';
import 'package:flutter/material.dart';
import '../service/classification.dart';

class Descript extends StatefulWidget {
  const Descript({super.key});

  @override
  State<Descript> createState() => _DescriptState();
}

class _DescriptState extends State<Descript> {
  final ValueNotifier<Map<String, String>?> _animalDataNotifier =
      ValueNotifier<Map<String, String>?>(null);
  Timer? _timer;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startPrediction();
  }

  void _startPrediction() {
    _fetchAnimal(); // Initial fetch
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isLoading) {
        _fetchAnimal();
      }
    });
  }

  Future<void> _fetchAnimal() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await Classifier().predictAnimal();
      if (mounted) {
        // Only update if the prediction has changed
        if (result['animal'] != _animalDataNotifier.value?['animal'] ||
            result['description'] !=
                _animalDataNotifier.value?['description']) {
          _animalDataNotifier.value = result;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to predict: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animalDataNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchAnimal, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Container(
      color: theme.colorScheme.background.withOpacity(0.2), // Added opacity
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<Map<String, String>?>(
            valueListenable: _animalDataNotifier,
            builder: (context, animalData, child) {
              if (animalData == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final keys = animalData.keys.toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animal Name Header
                  Row(
                    children: [
                      Text(
                        animalData['animal'] ?? '',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                          // color:
                          //     theme.brightness == Brightness.dark
                          //         ? Colors.white
                          //         : Colors.black87,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(width: 16),
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Container(
                    height: 1,
                    width: 80,
                    color: theme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    animalData['description'] ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color:
                          theme.brightness == Brightness.light
                              ? Colors.white
                              : Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Additional Info (from provided code snippet)
                  if (keys.length > 2 && animalData[keys[2]] != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            theme.brightness == Brightness.dark
                                ? Colors.grey[850]
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            keys[2],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            animalData[keys[2]] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color:
                                  theme.brightness == Brightness.dark
                                      ? Colors.white70
                                      : Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // const SizedBox(height: 16),
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       Image.asset(
                  //         'assets/tiger.png',
                  //         height: 200,
                  //         fit: BoxFit.contain,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

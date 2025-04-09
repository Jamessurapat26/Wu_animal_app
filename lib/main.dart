import 'package:flutter/material.dart';
import 'screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WU Animal App',
      theme: ThemeData(
        // Primary colors
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,

        // Text themes
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.6,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Component themes
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),

        // Other UI elements
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(
          secondary: Colors.deepPurpleAccent,
          background: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        // Dark theme settings
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple[700],
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple[300] ?? Colors.deepPurple,
          secondary: Colors.deepPurpleAccent[100] ?? Colors.deepPurpleAccent,
          background: Colors.grey[900] ?? Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

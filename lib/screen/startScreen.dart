import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:google_fonts/google_fonts.dart';
import './home.dart';

class Startscreen extends StatelessWidget {
  const Startscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset('assets/bg.png', fit: BoxFit.cover),
          ),

          // Container to dim the background (optional)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.1),
          ),

          // Title text positioned at top
          Positioned(
            top: 200,
            left: 100,
            child: StrokeText(
              text: "เกมอะไรก็ไม่รู้ \nยังไม่คิดชื่อ",
              textStyle: GoogleFonts.kanit(
                fontSize: 100,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w900,
              ),
              strokeColor: Colors.white,
              strokeWidth: 8,
            ),
          ),

          // Button positioned at bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 300, right: 550),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.lightBlueAccent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      // navigete to main screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'เริ่มเกม',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

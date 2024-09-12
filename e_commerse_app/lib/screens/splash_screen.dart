import 'package:e_commerse_app/screens/custom_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // Logo
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 225),
                child: Image.asset(
                  'images/Splash.png', // Path to the logo image
                  height: 270, // Adjust as needed
                ),
              ),
            ),
            SizedBox(height: 130), // Space between tagline and button
            // "Let's Get Started" Button
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Center(
                  child: Text(
                    'Let’s Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFFFFF),
                    ),
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

import 'package:e_commerse_app/screens/custmor_screen1.dart';
import 'package:flutter/material.dart';
class CustomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of the screen
      body: SingleChildScrollView( // Make the entire screen scrollable
        child: Column(
          children: [
            // White container for the image
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Image with padding
                    Padding(
                      padding: const EdgeInsets.only(top: 130), // Adjust this as needed
                      child: Image.asset(
                        'images/img_2.png', // Add the correct path to your image
                        height: 300, // Adjust as needed
                      ),
                    ),
                    SizedBox(height: 20), // Add spacing between the image and indicators
                    // Page Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 15,
                          height: 3,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 5,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 5,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Adjust spacing between sections
            // Black container with rounded corners for content
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Free-Spirited Fashion Finds',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20), // Add spacing
                    // Subtitle
                    Text(
                      'Browse thousands of products, from fashion\n      to tech. Find what you love, effortlessly.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,), // Space between tagline and button
                    // "Let's Get Started" Button
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomScreen1(),
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
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Add spacing
                    // "Already have an account?" text and "Log In" link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle log in action
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'signup_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Password visibility toggle
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle login
  Future<void> _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Storing user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'mobile_number': _phoneController.text.trim(),
        'last_login': DateTime.now(),
      });

      // Navigate to home screen or other page
      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Back icon button
            Padding(
              padding: const EdgeInsets.only(right: 260, top: 5),
              child: Container(
                height: 35, // Increased height to accommodate the icon size
                width: 35, // Increased width to accommodate the icon size
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left_sharp, size: 20, color: Colors.black),
                    onPressed: () {
                      // Handle back action here
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            // Logo
            Image.asset(
              'images/Splash.png', // Your logo asset
              height: 180,
            ),
            SizedBox(height: 5),
            // Black container with rounded corners at the top
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40), // Rounded top corners
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome text
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter your details below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  // Mobile Number Field
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(color: Color(0xff636363)),
                      fillColor: Colors.grey[900], // Darker input field color
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff636363)),
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff636363),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0xff636363)),
                  ),

                  SizedBox(height: 20),
                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Color(0xff636363)),
                      fillColor: Colors.grey[900],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xff636363)),
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff636363),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0xff636363)),
                  ),
                  SizedBox(height: 10),
                  // Forgot password text
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password action
                      },
                      child: Text(
                        'Forget your password?',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loginUser, // Call the login function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sign Up text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),)) ;  // Handle sign-up action
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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

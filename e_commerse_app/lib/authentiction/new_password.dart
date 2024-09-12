import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'password_update.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _obscureText = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isKeyboardVisible = false; // Define the variable here
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? _currentTextController;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = _auth.currentUser;
        if (user != null) {
          await user.updatePassword(_passwordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password updated successfully")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordupdateScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not logged in")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update password: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the default keyboard
        setState(() {
          _isKeyboardVisible = false; // Hide the custom keyboard when tapping outside
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Back icon button
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_left_sharp, size: 20, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Logo
              Image.asset(
                'images/Splash.png', // Your logo asset
                height: 100,
              ),
              SizedBox(height: 30),
              // Create New Password container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Create New Password text
                    Text(
                      'Create New Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Create a new password to secure your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    // Password Input Field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey[850],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff636363)),
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff636363),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff636363),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onTap: () {
                        _currentTextController = _passwordController;
                        setState(() {
                          _isKeyboardVisible = true; // Show the custom keyboard when this field is tapped
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Confirm Password Input Field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey[850],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xff636363)),
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff636363),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff636363),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onTap: () {
                        _currentTextController = _confirmPasswordController;
                        setState(() {
                          _isKeyboardVisible = true; // Show the custom keyboard when this field is tapped
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    // Create New Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Create New Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Custom Keyboard
                    if (_isKeyboardVisible) CustomKeyboard(onNumberSelected: _onNumberSelected),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle custom keyboard input
  void _onNumberSelected(String value) {
    final TextEditingController? controller = _currentTextController;
    if (controller == null) return;

    if (value == 'CLEAR') {
      controller.clear();
    } else if (value == 'DELETE') {
      final text = controller.text;
      if (text.isNotEmpty) {
        controller.text = text.substring(0, text.length - 1);
      }
    } else {
      controller.text = '${controller.text}$value';
    }
  }
}

// Custom Keyboard widget
class CustomKeyboard extends StatelessWidget {
  final Function(String) onNumberSelected;

  CustomKeyboard({required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildRow(['CLEAR', '0', 'DELETE']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => Expanded(child: _buildKey(key))).toList(),
      ),
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () {
        onNumberSelected(value);
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xff231F20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

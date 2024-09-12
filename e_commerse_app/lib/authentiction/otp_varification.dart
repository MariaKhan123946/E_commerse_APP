import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'new_password.dart'; // Ensure this import is correct

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OtpVerificationScreen({
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  final String staticOtp = '123456'; // Static OTP for testing

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Compare entered OTP with static OTP
      if (_otpController.text.trim() == staticOtp) {
        // Sign in with the provided credential
        await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: widget.verificationId,
            smsCode: staticOtp,
          ),
        );

        // Navigate to the new password screen upon successful OTP verification
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(),
        ));
      } else {
        // Show an error message if OTP is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again!')),
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            Image.asset(
              'images/Splash.png', // Keep your logo unchanged
              height: 100,
            ),
            SizedBox(height: 30),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You need to enter the 6-digit code we sent to\n your Phone number. ${widget.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Color(0xff231F20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _otpController.text.isNotEmpty && index < _otpController.text.length
                                ? _otpController.text[index]
                                : '',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
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
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't get the code yet? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle resend OTP
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Resend OTP functionality not implemented')),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomKeyboard(
                    onNumberSelected: (number) {
                      final text = _otpController.text;
                      if (number == 'DELETE') {
                        if (text.isNotEmpty) {
                          _otpController.text = text.substring(0, text.length - 1);
                          setState(() {});
                        }
                      } else if (number == 'CLEAR') {
                        _otpController.clear();
                        setState(() {});
                      } else {
                        _otpController.text = text + number;
                        setState(() {});
                      }
                    },
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildKey('1')),
                Expanded(child: _buildKey('2')),
                Expanded(child: _buildKey('3')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildKey('4')),
                Expanded(child: _buildKey('5')),
                Expanded(child: _buildKey('6')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildKey('7')),
                Expanded(child: _buildKey('8')),
                Expanded(child: _buildKey('9')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildKey('CLEAR')),
                Expanded(child: _buildKey('0')),
                Expanded(child: _buildKey('DELETE')),
              ],
            ),
          ),
        ],
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

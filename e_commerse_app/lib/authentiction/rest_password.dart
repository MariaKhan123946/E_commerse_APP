import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerse_app/authentiction/otp_varification.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureText = true;
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _isKeyboardVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _otpSent = false;
  bool _isResendEnabled = false;
  int _secondsRemaining = 35;
  String _countryCode = '+92'; // Default country code

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
        setState(() {
          _isKeyboardVisible = false; // Hide the custom keyboard
        });
      },
      child: Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Reset your Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We need your Phone number so we can send\nyou the password reset code.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _mobileNumberController,
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      onTap: () {
                        setState(() {
                          _isKeyboardVisible = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor:  Color(0xff231F20),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[850]!),
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
                        prefixText: '$_countryCode ', // Display country code
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _otpSent ? null : _sendOtp, // Disable button if OTP is already sent
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _otpSent ? 'OTP Sent' : 'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isKeyboardVisible) buildCustomKeyboard(),
                    if (_isResendEnabled)
                      TextButton(
                        onPressed: _sendOtp,
                        child: Text('Resend OTP'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    setState(() {
      _otpSent = false;
      _secondsRemaining = 35;
      _isResendEnabled = false;
      _startCountdown();
    });

    final phoneNumber = '$_countryCode${_mobileNumberController.text.trim()}';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number verified automatically!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: _mobileNumberController.text.trim(),
              verificationId: _verificationId,
            ),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Try again!')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _otpSent = true;
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent to your phone number')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: _mobileNumberController.text.trim(),
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startCountdown();
      } else {
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  Widget buildCustomKeyboard() {
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
                Expanded(child: _buildKey('C')),
                Expanded(child: _buildKey('0')),
                Expanded(child: _buildKey('+')),
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
        if (value == 'C') {
          _mobileNumberController.clear();
        } else if (value == '+') {
          _showCountryCodePicker();
        } else {
          _mobileNumberController.text += value;
        }
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

  void _showCountryCodePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Country Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('United States (+1)'),
              onTap: () {
                setState(() {
                  _countryCode = '+1';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Pakistan (+92)'),
              onTap: () {
                setState(() {
                  _countryCode = '+92';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  static const int _totalSeconds = 120; // 2 minutes in seconds
  int _secondsRemaining = _totalSeconds;
  Timer? _timer;
  bool _canResendCode =
      false; // Variable to track if resend button should be enabled

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus for the first TextField to open the keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResendCode = true; // Enable resend button when timer reaches 0
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _resendCode() {
    // Implement resend code functionality here
    // Reset timer and other related states if needed
    setState(() {
      _secondsRemaining = _totalSeconds;
      _canResendCode = false;
      _startTimer();
    });
  }

  void _onTextChanged(
      String value, FocusNode? nextFocusNode, FocusNode? previousFocusNode) {
    if (value.length == 1 && nextFocusNode != null) {
      FocusScope.of(context).requestFocus(nextFocusNode);
    } else if (value.isEmpty && previousFocusNode != null) {
      FocusScope.of(context).requestFocus(previousFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "OTP Verification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please check your email abc@gmail.com to see the verification code",
                style: TextStyle(color: Colors.grey, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "OTP Code",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOTPTextField(_focusNode1, _focusNode2, null),
                  _buildOTPTextField(_focusNode2, _focusNode3, _focusNode1),
                  _buildOTPTextField(_focusNode3, _focusNode4, _focusNode2),
                  _buildOTPTextField(_focusNode4, null, _focusNode3),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF24BAEC)),
                        onPressed: () => _startTimer(),
                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Resend code in ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                  Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: _canResendCode ? _resendCode : null,
                    child: const Text("Resend Code"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPTextField(FocusNode currentFocusNode,
      FocusNode? nextFocusNode, FocusNode? previousFocusNode) {
    return SizedBox(
      width: 80,
      child: TextField(
        focusNode: currentFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color.fromARGB(255, 237, 235, 235),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onChanged: (value) =>
            _onTextChanged(value, nextFocusNode, previousFocusNode),
      ),
    );
  }
}

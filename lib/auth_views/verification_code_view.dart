import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationCodeView extends StatefulWidget {
  final String email;
  const VerificationCodeView({super.key, required this.email});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  int _secondsRemaining = 60;
  Timer? _timer;
  String otpCode = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendCode() async {
    if (_secondsRemaining > 0) return;
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: widget.email);
      _startTimer();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification code resent')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to resend code: $e')));
    }
  }

  Future<void> _verifyCode() async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otpCode.trim(),
        type: OtpType.signup,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFF0C0C0C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 400,
              height: 409,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Success alert .png',
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Email Confirmed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You now have valid access to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Login Now",
                        onPressed: () {
                          Get.offAll(SigninView());
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 85),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) {
                otpCode = value;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 48,
                fieldWidth: 48,
                activeColor: const Color(0xFF1565FF),
                selectedColor: const Color(0xFF1565FF),
                inactiveColor: const Color(0xFF1C1C1E),
                activeFillColor: const Color(0xFF1565FF).withOpacity(0.3),
                selectedFillColor: const Color(0xFF1565FF).withOpacity(0.3),
                inactiveFillColor: const Color(0xFF1C1C1E),
              ),
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(color: Colors.white),
              enableActiveFill: true,
            ),
            const SizedBox(height: 48),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'You can resend the code in ',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  TextSpan(
                    text: '$_secondsRemaining',
                    style: const TextStyle(
                      color: Color(0xFF1565FF),
                      fontSize: 16,
                    ),
                  ),
                  const TextSpan(
                    text: ' seconds',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _resendCode,
              child: const Text(
                'Resend Code',
                style: TextStyle(color: Color(0xFF1565FF), fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: "Sign Up",
              onPressed: () {
                if (otpCode.length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter the complete code'),
                    ),
                  );
                  return;
                }
                _verifyCode();
              },
            ),
          ],
        ),
      ),
    );
  }
}

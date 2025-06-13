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
            backgroundColor: Theme.of(context).dialogBackgroundColor,
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
                    Image.asset('assets/check.png', height: 120, width: 120),
                    const SizedBox(height: 30),
                    Text(
                      'Email Confirmed',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You now have valid access to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Login Now",
                        onPressed: () {
                          Get.offAll(const SigninView());
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;
    final fillColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
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
                  inactiveColor: fillColor,
                  activeFillColor: const Color(0xFF1565FF).withOpacity(0.3),
                  selectedFillColor: const Color(0xFF1565FF).withOpacity(0.3),
                  inactiveFillColor: fillColor,
                ),
                keyboardType: TextInputType.number,
                textStyle: TextStyle(color: primaryTextColor),
                enableActiveFill: true,
              ),
              const SizedBox(height: 32),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'You can resend the code in ',
                      style: TextStyle(color: secondaryTextColor, fontSize: 16),
                    ),
                    TextSpan(
                      text: '$_secondsRemaining',
                      style: const TextStyle(
                        color: Color(0xFF1565FF),
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' seconds',
                      style: TextStyle(color: secondaryTextColor, fontSize: 16),
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
      ),
    );
  }
}

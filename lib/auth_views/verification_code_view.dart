import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

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
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SizedBox(
              width: 400.w,
              height: 409.h,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/check.png', height: 120.h, width: 120.w),
                    SizedBox(height: 30.h),
                    Text(
                      'Email Confirmed',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'You now have valid access to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Login Now",
                        onPressed: () {
                          Get.offAll(const SigninView());
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
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
final bgColor = isDark ? const Color.fromARGB(255, 0, 0, 0) : Colors.white;

    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;
    final fillColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60.h),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  otpCode = value;
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.r),
                  fieldHeight: 48.h,
                  fieldWidth: 48.w,
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
              SizedBox(height: 32.h),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'You can resend the code in ',
                      style: TextStyle(color: secondaryTextColor, fontSize: 16.sp),
                    ),
                    TextSpan(
                      text: '$_secondsRemaining',
                      style: TextStyle(
                        color: const Color(0xFF1565FF),
                        fontSize: 16.sp,
                      ),
                    ),
                    TextSpan(
                      text: ' seconds',
                      style: TextStyle(color: secondaryTextColor, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: _resendCode,
                child: Text(
                  'Resend Code',
                  style: TextStyle(color: const Color(0xFF1565FF), fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 32.h),
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

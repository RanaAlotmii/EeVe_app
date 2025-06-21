import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:eeve_app/auth_views/verification_code_view.dart';
import 'package:eeve_app/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryText = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;
    final bgColor = isDark ? const Color(0xFF000000) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70.h),
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text("Full Name", style: TextStyle(color: secondaryText, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Enter your name',
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    SizedBox(height: 16.h),
                    Text("Email", style: TextStyle(color: secondaryText, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(height: 16.h),
                    Text("Password", style: TextStyle(color: secondaryText, fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                    SizedBox(height: 32.h),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final name = nameController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || name.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        try {
                          final response = await supabase.auth.signUp(
                            email: email,
                            password: password,
                            data: {'name': name},
                          );

                          final user = response.user;
                          if (user != null) {
                            Get.to(() => VerificationCodeView(email: email));
                          } else {
                            throw Exception("User is null");
                          }
                        } catch (e) {
                          print("Sign Up Error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sign Up Error: $e")),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 32.h),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: secondaryText, fontSize: 14.sp),
                          children: const [
                            TextSpan(text: 'By registering you agree to \n'),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: Color(0xFF1565FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFF1565FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: secondaryText, fontSize: 16.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SigninView());
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: const Color(0xFF1565FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
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

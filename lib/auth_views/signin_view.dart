import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart' show Get, GetNavigation;
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/custom_button.dart';
import 'package:eeve_app/auth_views/signup_view.dart';
import 'package:eeve_app/main.dart' show supabase;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final bgColor = isDark ? const Color.fromARGB(255, 0, 0, 0) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        'Welcome Back! 👋',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 45.h),
                      Text(
                        "Email",
                        style: TextStyle(color: subTextColor, fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        hintText: 'Enter your email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Password",
                        style: TextStyle(color: subTextColor, fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        hintText: 'Enter your password',
                        obscureText: true,
                        controller: passwordController,
                      ),
                      SizedBox(height: 48.h),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: () async {
                          try {
                            final AuthResponse response = await supabase.auth
                                .signInWithPassword(
                                  password: passwordController.text,
                                  email: emailController.text,
                                );

                            final user = response.user;

                            if (user != null) {
                              final emailConfirmed =
                                  user.emailConfirmedAt != null;

                              if (emailConfirmed) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);
                                Get.offAll(() => const MainNavShell());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please confirm your email before signing in.',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          } on AuthException catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error.message == 'Invalid login credentials'
                                      ? 'Incorrect email or password, or user is not registered.'
                                      : error.message,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unexpected error occurred. Please try again.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
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
                      "Don’t have an account? ",
                      style: TextStyle(color: subTextColor, fontSize: 16.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignupView());
                      },
                      child: Text(
                        "Sign Up",
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
      ),
    );
  }
}

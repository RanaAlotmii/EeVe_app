import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:eeve_app/Account_views/profile_view.dart';
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/custom_button.dart';
import 'package:eeve_app/auth_views/signup_view.dart';
import 'package:eeve_app/main.dart';
import 'package:eeve_app/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome Back! 👋',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 82),

            const Text("Email", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
            const Text("Password", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Enter your password',
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 48),
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
                    final emailConfirmed = user.emailConfirmedAt != null;

                    if (emailConfirmed) {
                      final prefs = await SharedPreferences.getInstance();
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

            const Spacer(),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(SignupView());
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF1565FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

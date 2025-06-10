import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/Custom_Widget_/custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:eeve_app/auth_views/signup_view.dart';
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
                Image.asset(
                'assets/eeve_logo.png',
                height: 210, 
              ),
              const SizedBox(height: 20),
              const Text(
                'EeVe is ready when you are — join or log in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30), 
              CustomButton(
                text: 'Sign in with Email',
                onPressed: () => Get.to(() => SigninView()),
              ),
              const SizedBox(height: 12),
              const Text('or', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Create an account',
                onPressed: () => Get.to(() => SignupView()),
              ),
              const Spacer(flex: 2), // قللنا من المسافة الأخيرة
            ],
          ),
        ),
      ),
    );
  }
}

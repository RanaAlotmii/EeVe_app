import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/Custom_Widget_/custom_button.dart';
import 'signup_view.dart';
import 'signin_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/welcome_background.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Your next experience starts\nhere — join us or log in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'sign in',
                  onPressed: () {
                    Get.to(SigninView());
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'sign up',
                  onPressed: () {
                    Get.to(SignupView());
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

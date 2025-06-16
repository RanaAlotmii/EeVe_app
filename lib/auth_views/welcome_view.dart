import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/Custom_Widget_/custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:eeve_app/auth_views/signup_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : const Color.fromARGB(255, 226, 226, 226);
    final textColor = isDark ? Colors.white70 : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Image.asset('assets/logo_trans.png', height: 230),
              const SizedBox(height: 10),
              Text(
                'EeVe is ready when you are — join or log in.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Sign in with Email',
                onPressed: () => Get.to(() => const SigninView()),
              ),
              const SizedBox(height: 12),
              Text('or', style: TextStyle(color: textColor)),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Create an account',
                onPressed: () => Get.to(() => const SignupView()),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

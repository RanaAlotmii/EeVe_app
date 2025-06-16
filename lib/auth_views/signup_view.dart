import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:eeve_app/auth_views/verification_code_view.dart';
import 'package:eeve_app/main.dart';

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
    final primaryText = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final secondaryText = theme.textTheme.bodySmall?.color ?? Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 24,
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Text("Full Name", style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter your name',
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    Text("Email", style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    Text("Password", style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final name = nameController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || name.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        try {
                          final response = await supabase.auth.signUp(
                            email: email,
                            password: password,
                          );

                          // ✅ إضافة بيانات المستخدم إلى جدول users
                         await supabase.from('users').insert({
  'email': email,
  'name': name,
  'created_at': DateTime.now().toIso8601String(),
});


                          // ✅ الانتقال لصفحة التحقق
                          Get.to(() => VerificationCodeView(email: email));
                        } catch (e) {
                          print("Sign Up Error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sign Up Error: $e")),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: secondaryText, fontSize: 14),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: secondaryText, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SigninView());
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color(0xFF1565FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

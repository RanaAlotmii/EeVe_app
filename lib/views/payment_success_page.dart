import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey : Colors.black54;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDark ? 'assets/image2.png' : 'assets/image3.png',
              height: 220,
            ),
            const SizedBox(height: 32),
            Text(
              'Payment Completed!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your ticket has been confirmed. You can now enjoy the event and explore more!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
        child: CustomButton(
          text: 'Explore more events',
          onPressed: () {
            MainNavShell.mainTabController.jumpToTab(0);
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}

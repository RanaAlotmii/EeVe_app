import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Image.asset(
              isDark ? 'assets/image2.png' : 'assets/image3.png',
              height: 220.h,
            ),
            SizedBox(height: 60.h),
            Text(
              'Payment Completed!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your ticket has been confirmed. You can now enjoy the event and explore more!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontSize: 14.sp,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 25.h),
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

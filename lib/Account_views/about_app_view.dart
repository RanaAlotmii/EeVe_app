import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'About App',
          style: textTheme.titleMedium?.copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'EeVe App',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Version: 1.0.0',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'EeVe is your intelligent assistant for discovering and managing events with ease. Powered by AI, EeVe offers a personalized experience that helps you explore events, book tickets, and stay connected to the experiences you love—all from one place.',
              style: textTheme.bodyLarge?.copyWith(
                height: 1.5,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Whether you\'re into concerts, cultural festivals, or community gatherings, EeVe curates events based on your interests and preferences, delivering a seamless and delightful journey.',
              style: textTheme.bodyLarge?.copyWith(
                height: 1.5,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Developed with passion by\nNaba OuladYaich, Rana Al-Otami, Ruba, Ammar, and Lama 💜',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFB388FF),
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

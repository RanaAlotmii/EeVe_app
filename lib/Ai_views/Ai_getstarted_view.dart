import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eeve_app/Ai_views/Ai_onboarding_view.dart';
import 'package:get/get.dart';

class AiGetStartedView extends StatefulWidget {
  const AiGetStartedView({super.key});

  @override
  State<AiGetStartedView> createState() => _AiGetStartedViewState();
}

class _AiGetStartedViewState extends State<AiGetStartedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _navigateToOnboarding() {
    Get.to(() => const AiOnboardingView());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    final screenHeight = 1.sh;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  height: 380.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8A2BE2), Colors.transparent],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                Expanded(child: Container(color: backgroundColor)),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.20,
            child: Image.asset(
              'assets/AI206.png',
              width: 420.w,
              height: 520.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 24.w,
            right: 24.w,
            child: Text(
              "Ready to unlock unforgettable experiences with EeVe AI?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21.sp,
                color: textColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.80,
            child: GestureDetector(
              onTap: _navigateToOnboarding,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [
                          const Color.fromARGB(255, 116, 69, 191),
                          Colors.white.withOpacity(
                            0.4 + 0.6 * _controller.value,
                          ),
                          const Color(0xFFB657F5),
                        ],
                        stops: const [0.3, 0.6, 1.0],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Let’s Dive In',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.purple.withOpacity(
                              0.5 + 0.5 * sin(_controller.value * pi),
                            ),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

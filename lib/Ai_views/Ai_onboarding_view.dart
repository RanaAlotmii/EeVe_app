import 'package:eeve_app/Ai_views/ai_assitant_view.dart';
import 'package:eeve_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiOnboardingView extends StatefulWidget {
  const AiOnboardingView({super.key});

  @override
  State<AiOnboardingView> createState() => _AiOnboardingViewState();
}

class _AiOnboardingViewState extends State<AiOnboardingView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': "assets/AI13.png",
      'title': 'What can EeVe AI do?',
      'desc': 'Effortless picks. Just tell EeVe your mood',
    },
    {
      'image': 'assets/AI9.png',
      'title': 'Powered by GPT-3.5 Magic',
      'desc': 'EeVe turns your vibe into real plans — no stress, just spark-powered suggestions',
    },
  ];

  void nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    MainNavShell.mainTabController.index = 3;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AiAssistantView()),
    );

    final user = supabase.auth.currentUser;
    if (user != null) {
    await Supabase.instance.client.from("users").update({"ai_get_started_seen": true}).eq("id", user.id);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      body: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      data['image']!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 100.h,
                      left: 24.w,
                      right: 24.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            data['desc']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _finishOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: onboardingData.length,
                      effect: WormEffect(
                        dotColor: Colors.white54,
                        activeDotColor: Colors.white,
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: nextPage,
                      child: Text(
                        _currentIndex == onboardingData.length - 1
                            ? "Let’s Go"
                            : "Next",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

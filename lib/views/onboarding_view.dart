import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:eeve_app/auth_views/welcome_view.dart';


class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/onb4.png',
      'title': 'Discover Events Nearby',
      'desc':
      'Explore concerts, shows, and experiences around you. EeVe brings the world of events to your fingertips.'
    },
    {
      'image': 'assets/page2.png',
      'title': 'Make It Yours',
      'desc':
      'Explore events by your interests, get real-time updates, and personalize your event feed for a tailored experience.'
    },
    {
      'image': "assets/page3.png",
      'title': 'Discover events that match your vibe – powered by AI! ',
      'desc': ''
    }
  ];

  void nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: Navigate to Home/Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>WelcomeView()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                final isLastPage = index == 2;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      data['image']!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: isLastPage ? 100 : 0,  // ⬅️ was 60, now raised more
                        bottom: isLastPage ? 0 : 120,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment:
                        isLastPage ? MainAxisAlignment.start : MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (isLastPage) const SizedBox(height: 10),
                          Text(
                            data['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          if (!isLastPage) const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                );
              }



          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeView()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: onboardingData.length,
                    effect: const WormEffect(
                      dotColor: Colors.white54,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),

                  // Next / Let's Go
                  GestureDetector(
                    onTap: nextPage,
                    child: Text(
                      _currentIndex == onboardingData.length - 1 ? "Let’s Go" : "Next",
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
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
    );
  }
}

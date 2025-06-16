import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:eeve_app/Ai_views/ai_suggestion_view.dart';
import 'package:eeve_app/controllers/ai_onboarding_controller.dart';

final AiOnboardingController aiController = Get.put(AiOnboardingController());

class AiOnboardingView extends StatefulWidget {
  const AiOnboardingView({super.key});

  @override
  State<AiOnboardingView> createState() => _AiOnboardingViewState();
}

class _AiOnboardingViewState extends State<AiOnboardingView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final interests = [
    {"label": "Music", "icon": "assets/songicon.png"},
    {"label": "Food", "icon": "assets/foodicon.png"},
    {"label": "Culture", "icon": "assets/cultureicon.png"},
    {"label": "Games", "icon": "assets/gamesicon.png"},
  ];

  final vibes = [
    {"label": "Chill", "icon": "assets/chillicon.png"},
    {"label": "Romantic", "icon": "assets/romaticicon.png"},
    {"label": "Family", "icon": "assets/familyicon.png"},
    {"label": "Solo", "icon": "assets/soloicon.png"},
  ];

  final times = [
    {"label": "Tonight", "icon": "assets/tonighticon.png"},
    {"label": "Weekend", "icon": "assets/weekendicon.png"},
    {"label": "Plan Ahead", "icon": "assets/plan.png"},
    {"label": "Surprise Me", "icon": "assets/suprise.png"},
  ];

  void nextPage() {
    if (_currentIndex < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AiSuggestionView(),
        ),
      );

    }
  }

  Widget buildStepPage({
    required String title,
    required List<Map<String, String>> options,
    required dynamic selected,
    required void Function(String) onSelect,
    bool allowMultiple = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: options.map((item) {
                final label = item['label']!;
                final iconPath = item['icon']!;
                final isSelected = allowMultiple
                    ? aiController.selectedInterests.contains(label)
                    : selected == label;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (allowMultiple) {
                        isSelected
                            ? aiController.selectedInterests.remove(label)
                            : aiController.selectedInterests.add(label);
                      } else {
                        onSelect(label);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white24,
                        width: 1.5,
                      ),
                      gradient: isSelected
                          ? const LinearGradient(
                        colors: [Color(0xFF905FDD), Color(0xFF1B1B2F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02)
                      ]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(iconPath, width: 32, height: 32),
                        const SizedBox(height: 10),
                        Text(
                          label,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [
                buildStepPage(
                  title: "What are you into lately?",
                  options: interests,
                  selected: aiController.selectedInterests,
                  allowMultiple: true,
                  onSelect: (_) {},
                ),
                buildStepPage(
                  title: "What's your vibe today?",
                  options: vibes,
                  selected: aiController.selectedVibe.value,
                  onSelect: (item) => aiController.selectedVibe.value = item,
                ),
                buildStepPage(
                  title: "When do you wanna go out?",
                  options: times,
                  selected: aiController.selectedTime.value,
                  onSelect: (item) => aiController.selectedTime.value = item,
                ),
              ],
            ),

            // Bottom Controls
            Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AiSuggestionView(),
                        ),
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
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                      dotColor: Colors.white30,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: nextPage,
                    child: Text(
                      _currentIndex == 2 ? "Start" : "Next",
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

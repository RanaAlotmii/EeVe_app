import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:eeve_app/Ai_views/ai_assistant_view.dart';

class AiOnboardingView extends StatefulWidget {
  const AiOnboardingView({super.key});

  @override
  State<AiOnboardingView> createState() => _AiOnboardingViewState();
}

class _AiOnboardingViewState extends State<AiOnboardingView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  Set<String> selectedInterests = {};

  final List<Map<String, String>> interests = [
    {'icon': 'assets/concert.png', 'label': 'Music'},
    {'icon': "assets/room-service.png", 'label': 'Food & Drink'},
    {'icon': "assets/game-controller.png", 'label': 'Hobbies'},
    {'icon': "assets/ticket.png", 'label': "Visual Arts"},
    {'icon': 'assets/puzzle.png', 'label': 'Workshops'},
  ];

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/AI_6.png',
      'title': 'Let the AI Work Its Magic',
      'desc': 'Our smart assistant processes your input to match events tailored to your mood and style.'
    },
    {
      'image': "assets/AI_7.png",
      'title': 'Meet Your AI Assistant',
      'desc': 'Your personal AI is ready to guide you to unforgettable experiences. Just say “Find my vibe!”'
    }
  ];

  void nextPage() {
    if (_currentIndex < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AiAssistantView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: 3,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/AI_5.png',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tell Us Your Preferences',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Choose your favorite categories so our AI can tailor events for you.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 600,
                            child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.3,
                              children: interests.map((item) {
                                final isSelected = selectedInterests.contains(item['label']);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedInterests.remove(item['label']);
                                      } else {
                                        selectedInterests.add(item['label']!);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: isSelected
                                          ? const LinearGradient(
                                        colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                          : LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: isSelected ? Colors.white : Colors.white24,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          item['icon']!,
                                          height: 28,
                                          width: 28,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item['label']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                final data = onboardingData[index - 1];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      data['image']!,
                      fit: BoxFit.cover,
                    ),
                    // 👇 This section positions the text properly below the character
                    Positioned(
                      bottom: 80,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AiAssistantView()),
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
                      dotColor: Colors.white54,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: nextPage,
                    child: Text(
                      _currentIndex == 2 ? "Let’s Go" : "Next",
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

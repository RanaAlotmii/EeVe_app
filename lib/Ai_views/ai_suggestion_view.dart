import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/suggestion_card.dart';
import 'package:eeve_app/Ai_views/ai_chat_view.dart';

class AiSuggestionView extends StatelessWidget {
  const AiSuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SizedBox(height: 30),
              const Text(
                "Quick Suggestions:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    SuggestionCard(
                      title: "Weekend Picks",
                      subtitle: "What's happening this weekend?",
                      iconPath: "assets/weekend.png",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Budget-Friendly",
                      subtitle: "Find events that won’t break the bank",
                      iconPath: "assets/budgeticon.png",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Smart Random Pick",
                      subtitle: "Let EeVe find something fun for you",
                      iconPath: "assets/randomicon.png",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Trending Now",
                      subtitle: "What's popular today?",
                      iconPath: "assets/trendingicon.png",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AiChatView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A60F8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
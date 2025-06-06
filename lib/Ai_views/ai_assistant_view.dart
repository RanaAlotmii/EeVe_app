
import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/suggestion_card.dart';
import 'package:eeve_app/Ai_views/ai_chat_view.dart';


class AiAssistantView extends StatelessWidget {
  const AiAssistantView({super.key});

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

              // Quick Suggestions title
              const Text(
                "Quick Suggestions:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Grid of suggestion cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    SuggestionCard(
                      title: "Nearby events",
                      subtitle: "Discover events around you",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Budget events",
                      subtitle: "We'll match events to your budget",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Interest-Based Events",
                      subtitle: "Based on your preferences and past choices",
                      onPressed: () {},
                    ),
                    SuggestionCard(
                      title: "Let AI Decide for You",
                      subtitle: "Not sure? Let EeVe recommend an event!",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Chat button
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

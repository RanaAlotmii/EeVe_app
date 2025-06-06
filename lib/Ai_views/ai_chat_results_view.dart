import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/event_card_small.dart';
import 'package:eeve_app/Ai_views/ai_assistant_view.dart';
class AiChatResultsView extends StatelessWidget {
  const AiChatResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset('assets/eeve_logo.png', height: 50),
              const SizedBox(height: 20),
              const Text(
                "These events fit your vibe!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    CompactEventCard(
                      title: 'Dreamscape: Surreal Worlds and Experiences',
                      location: 'House of Hype, Riyadh',
                      imageAsset: 'assets/event1.jpeg',
                      price: 99.00,
                    ),
                    CompactEventCard(
                      title: 'Ferdi Riyadh: Paris Taste in the Heart of Via Riyadh',
                      location: 'Via Riyadh',
                      imageAsset: 'assets/event1.jpeg',
                      price: 50.00,
                    ),
                    CompactEventCard(
                      title: "Slava's Show – Riyadh Edition",
                      location: 'Riyadh',
                      imageAsset: 'assets/event1.jpeg',
                      price: 100.00,
                    ),
                    CompactEventCard(
                      title: 'E-Sports World Cup Riyadh 2025',
                      location: 'Riyadh',
                      imageAsset: 'assets/event1.jpeg',
                      price: 80.00,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Input bar at the bottom
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF1C1C27),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),


                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AiAssistantView(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String image,
    required String title,
    required String location,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            price,
            style: const TextStyle(
              color: Color(0xFF1A60F8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

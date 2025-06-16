import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:eeve_app/Custom_Widget_/event_card_small.dart';
import 'package:eeve_app/views/event_detail.dart';
import 'package:eeve_app/Ai_views/ai_chat_view.dart';
class AiChatResultsView extends StatelessWidget {
  final String aiReply;

  const AiChatResultsView({super.key, required this.aiReply});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventsController>();
    final allEvents = controller.getFilteredEvents();

    // Split AI reply into multiple titles
    final suggestedTitles = aiReply
        .split('|')
        .map((title) => title.trim().toLowerCase())
        .toList();

    // Match titles from Supabase events
    final matchedEvents = allEvents.where((event) {
      final eventTitle = event['title'].toString().toLowerCase();
      return suggestedTitles.any((suggested) => eventTitle.contains(suggested));
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: matchedEvents.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Sorry babe, I couldn’t find any matching events 💔",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/eeve_logo.png', height: 80)),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "These events fit your vibe!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: matchedEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final event = matchedEvents[index];
                    return CompactEventCard(
                      title: event['title'],
                      location: event['location'],
                      imageAsset: event['image_cover'],
                      price: double.tryParse(event['price'].toString()) ?? 0.0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetail(
                              eventId: event['id'] ?? 0,
                              title: event['title']?.toString() ?? '',
                              image: event['image_detail']?.toString() ?? '',
                              imageCover: event['image_cover']?.toString() ?? '',
                              location: event['location']?.toString() ?? '',
                              price: event['price']?.toString() ?? '',
                              description: event['description']?.toString() ?? '',
                              eventTime: event['time']?.toString() ?? '',
                            ),
                          ),
                        );


                      },

                    );
                  },
                ),


              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AiChatView()),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

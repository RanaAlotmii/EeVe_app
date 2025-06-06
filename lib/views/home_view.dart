import 'package:eeve_app/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/_PromoCard.dart';
import 'package:eeve_app/Custom_Widget_/home_header_widget.dart';
import 'package:eeve_app/Custom_Widget_/CategoryList.dart';
import 'package:eeve_app/custom_Widget_/_TrendingEventsList.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final EventsController controller = Get.find<EventsController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(),
              const SizedBox(height: 24),

              PromoCard(),
              const SizedBox(height: 32),

              const Text(
                "Trending Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Correct — no need for Obx here
              CategoryList(),

              const SizedBox(height: 40),

              const Text(
                "Trending in Riyadh",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Perfect — keep this
             const SizedBox(height: 16),

// ✅ Fixed — now safe!
Obx(() {
  final filteredEvents = controller.getFilteredEvents();

  if (controller.events.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  return TrendingEventsList(events: filteredEvents);
}),

            ],
          ),
        ),
      ),
    );
  }
}

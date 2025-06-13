import 'package:eeve_app/Custom_Widget_/_TrendingEventsList.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/_PromoCard.dart';
import 'package:eeve_app/Custom_Widget_/home_header_widget.dart';
import 'package:eeve_app/Custom_Widget_/CategoryList.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {

  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EventsController controller = Get.find<EventsController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

              Text(
                "Trending Categories",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              CategoryList(),
              const SizedBox(height: 40),

              Text(
                "Trending in Riyadh",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),

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

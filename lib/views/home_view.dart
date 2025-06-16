import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:eeve_app/controllers/profile_controller.dart';
import 'package:eeve_app/Custom_Widget_/home_header_widget.dart';
import 'package:eeve_app/Custom_Widget_/_PromoCard.dart';
import 'package:eeve_app/Custom_Widget_/CategoryList.dart';
import 'package:eeve_app/Custom_Widget_/_TrendingEventsList.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EventsController controller = Get.find<EventsController>();
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ProfileController>()) {
      profileController = Get.find<ProfileController>();
    } else {
      profileController = Get.put(ProfileController());
      profileController.loadProfileImage(); 
    }
  }

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

              // Obx(() {
              //   final profileImage = profileController.profileImage.value;
              //   return CircleAvatar(
              //     radius: 30,
              //     backgroundImage: profileImage.isNotEmpty
              //         ? NetworkImage(profileImage)
              //         : const AssetImage('assets/profileImage.png'),
              //   );
              // }),

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

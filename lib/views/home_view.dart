import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:eeve_app/controllers/profile_controller.dart';
import 'package:eeve_app/Custom_Widget_/home_header_widget.dart';
import 'package:eeve_app/Custom_Widget_/_PromoCard.dart';
import 'package:eeve_app/Custom_Widget_/CategoryList.dart';
import 'package:eeve_app/Custom_Widget_/_TrendingEventsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
              child: const HomeHeader(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PromoCard(),
                    SizedBox(height: 32.h),

                    Text(
                      "Trending Categories",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                     CategoryList(),
                    SizedBox(height: 20.h),

                    Text(
                      "Trending in Riyadh",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

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
          ],
        ),
      ),
    );
  }
}

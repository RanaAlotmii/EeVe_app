import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:eeve_app/Custom_Widget_/event_card_small.dart';
import 'package:eeve_app/views/event_detail.dart';
import 'package:eeve_app/Ai_views/ai_assitant_view.dart';

class AiChatResultsView extends StatelessWidget {
  final String aiReply;

  const AiChatResultsView({super.key, required this.aiReply});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventsController>();
    final allEvents = controller.getFilteredEvents();

    final suggestedTitles = aiReply
        .split('|')
        .map((title) => title.trim().toLowerCase())
        .toList();

    final matchedEvents = allEvents.where((event) {
      final title = event['title']?.toString().toLowerCase() ?? '';
      return suggestedTitles.any((suggestion) => title.contains(suggestion));
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: matchedEvents.isEmpty
            ? Center(
          child: Text(
            "No matching events found!",
            style: TextStyle(color: primaryTextColor, fontSize: 18.sp),
            textAlign: TextAlign.center,
          ),
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo_trans.png', height: 100.h)),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "These events fit your vibe!",
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.separated(
                  itemCount: matchedEvents.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
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
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Chat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
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
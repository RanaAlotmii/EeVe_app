import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/views/event_detail.dart';

class TrendingEventsList extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const TrendingEventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final event = events[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (event['id'] != null && event['title'] != null) {
                  Get.to(
                    () => EventDetail(
                      eventId: event['id'],
                      title: event['title'] ?? 'Unknown Event',
                      image: event['image_detail'] ?? '',
                      imageCover: event['image_cover'] ?? '',
                      location: event['location'] ?? 'Unknown Location',
                      price: (event['price'] ?? 0).toString(),
                      description: event['description'] ?? '',
                      eventTime: event['event_time'] ?? '',
                    ),
                    transition: Transition.cupertino,
                    fullscreenDialog: true,
                    preventDuplicates: false,
                  );
                }
              },
              child: TrendingEventCard(
                image: event['image_cover'] ?? 'https://via.placeholder.com/150',
                title: event['title'] ?? 'No Title',
                location: event['location'] ?? 'Unknown Location',
                price: double.tryParse(event['price'].toString())
                        ?.toStringAsFixed(2) ??
                    '0.00',
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrendingEventCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;

  const TrendingEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.grey[100]!;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 180,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cardColor, width: 1), // نفس لون الكونتينر
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.network(
                image,
                width: 180,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    height: 120,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white30),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$price SR',
                    style: const TextStyle(
                      color: Color(0xFF339FFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
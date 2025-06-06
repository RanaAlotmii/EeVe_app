import 'package:flutter/material.dart';
import 'package:eeve_app/views/event_detail.dart';

class TrendingEventsList extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const TrendingEventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // slightly taller container
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final event = events[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => EventDetail(
                        title: event['title'] ?? '',
                        image: event['image_detail'] ?? '',
                        imageCover:
                            event['image_cover'] ?? '', // ✅ هذا هو التعديل
                        location: event['location'] ?? '',
                        price:
                            double.tryParse(
                              event['price'].toString(),
                            )?.toStringAsFixed(2) ??
                            '0.00',
                        description: event['description'] ?? '',
                        eventTime: event['event_time'] ?? '',
                      ),
                ),
              );
            },
            child: TrendingEventCard(
              image: event['image_cover'] ?? 'https://via.placeholder.com/150',
              title: event['title'] ?? 'No Title',
              location: event['location'] ?? 'Unknown Location',
              price:
                  double.tryParse(
                    event['price'].toString(),
                  )?.toStringAsFixed(2) ??
                  '0.00',
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
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 180,
        height: 240, // slightly taller container
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF01010C), Color(0xFF594C70)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    image,
                    width: 180,
                    height: 140, // ✅ smaller image height — fits better
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        height: 120,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
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
        ),
      ),
    );
  }
}

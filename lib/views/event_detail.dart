import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:eeve_app/custom_Widget_/_TrendingEventsList.dart';
import 'package:eeve_app/custom_Widget_/image_ticket_card.dart';
import 'package:eeve_app/views/search_page.dart';
import 'package:eeve_app/views/booking_form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
class FavoriteManager {
  static final List<Map<String, dynamic>> _favorites = [];
  static final ValueNotifier<List<Map<String, dynamic>>> favoritesNotifier =
      ValueNotifier([]);

  static List<Map<String, dynamic>> get favorites => _favorites;

  static void toggleFavorite(Map<String, dynamic> event) {
    if (_favorites.any(
      (e) => e['title'] == event['title'] && e['location'] == event['location'],
    )) {
      _favorites.removeWhere(
        (e) =>
            e['title'] == event['title'] && e['location'] == event['location'],
      );
    } else {
      _favorites.add(event);
    }
    favoritesNotifier.value = List.from(_favorites);
  }

  static bool isFavorite(Map<String, dynamic> event) {
    return _favorites.any(
      (e) => e['title'] == event['title'] && e['location'] == event['location'],
    );
  }
}

class EventDetail extends StatefulWidget {
  final String title;
  final String image; // ✅ image_detail
  final String imageCover; // ✅ image_cover
  final String location;
  final String price;
  final String description;
  final String eventTime;

  const EventDetail({
    super.key,
    required this.title,
    required this.image,
    required this.imageCover,
    required this.location,
    required this.price,
    required this.description,
    required this.eventTime,
  });

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late bool isFavorite;

  List<Map<String, dynamic>> moreEvents = [];

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteManager.isFavorite({
      'title': widget.title,
      'location': widget.location,
    });

    fetchMoreEvents();
  }

  Future<void> fetchMoreEvents() async {
    final response = await Supabase.instance.client
        .from('events')
        .select()
        .neq('title', widget.title)
        .limit(5);

    setState(() {
      moreEvents = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Event Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                final eventMap = {
                  'title': widget.title,
                  'location': widget.location,
                  'image_cover': widget.imageCover,
                  'image_detail': widget.image,
                  'price': widget.price,
                  'description': widget.description,
                  'event_time': widget.eventTime,
                };
                FavoriteManager.toggleFavorite(eventMap);
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: Colors.white,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(
              context,
            ); // ✅ BEST: will go back to previous page (Home, Search, Favorites ... whatever)
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                const SizedBox(width: 6),
                Text(
                  widget.location,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 16),
                const SizedBox(width: 6),
                Text(
                  widget.eventTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    height: 200,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white30),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About this event',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'More events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            moreEvents.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : TrendingEventsList(events: moreEvents),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
        child: CustomButton(
          text: 'Buy Ticket',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BookingFormPage(
                      eventData: {
                        'title': widget.title,
                        'location': widget.location,
                        'image_cover': widget.imageCover,
                        'price': widget.price,
                        'event_date': widget.eventTime,
                      },
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}

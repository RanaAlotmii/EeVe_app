import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:eeve_app/custom_Widget_/_TrendingEventsList.dart';
import 'package:eeve_app/views/booking_form_page.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/managers/favorites_manager.dart';

class EventDetail extends StatefulWidget {
  final int eventId;
  final String title;
  final String image;
  final String imageCover;
  final String location;
  final String price;
  final String description;
  final String eventTime;
  final VoidCallback? onFavoriteChanged;

  const EventDetail({
    super.key,
    required this.eventId,
    required this.title,
    required this.image,
    required this.imageCover,
    required this.location,
    required this.price,
    required this.description,
    required this.eventTime,
    this.onFavoriteChanged,
  });

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late bool isFavorite;
  final user = Supabase.instance.client.auth.currentUser;
  bool isLoading = false;
  final FavoritesManager _favoritesManager = FavoritesManager();

  List<Map<String, dynamic>> moreEvents = [];

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    fetchMoreEvents();
    _checkIfFavorite();
  }

  Future<void> fetchMoreEvents() async {
    try {
      final response = await Supabase.instance.client
          .from('events')
          .select()
          .neq('id', widget.eventId)
          .limit(5);

      if (mounted) {
        setState(() {
          moreEvents = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('Error fetching more events: $e');
    }
  }

  // استخدام FavoritesManager للفحص
  Future<void> _checkIfFavorite() async {
    final result = await _favoritesManager.isFavorite(widget.eventId);
    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

  // استخدام FavoritesManager للتبديل
  Future<void> _toggleFavorite() async {
    final userId = user?.id;
    if (userId == null) {
      _showMessage('Please log in to add favorites', isError: true);
      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      bool success;
      
      if (isFavorite) {
        // حذف من المفضلة
        success = await _favoritesManager.removeFromFavorites(widget.eventId);
        if (success) {
          _showMessage('Removed from favorites');
        }
      } else {
        // إضافة إلى المفضلة
        final eventData = {
          'id': widget.eventId,
          'title': widget.title,
          'image_detail': widget.image,
          'image_cover': widget.imageCover,
          'location': widget.location,
          'price': double.tryParse(widget.price) ?? 0.0,
          'description': widget.description,
          'event_time': widget.eventTime,
        };
        
        success = await _favoritesManager.addToFavorites(widget.eventId, eventData);
        if (success) {
          _showMessage('Added to favorites');
        }
      }

      if (success && mounted) {
        setState(() {
          isFavorite = !isFavorite;
          isLoading = false;
        });

        // استدعاء الـ callback (إضافي للتأكد)
        widget.onFavoriteChanged?.call();
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          _showMessage('Failed to update favorites', isError: true);
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showMessage('Failed to update favorites', isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: isLoading ? null : _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isLoading ? Colors.grey : (isFavorite ? Colors.red : Colors.white),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
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
                builder: (_) => BookingFormPage(
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
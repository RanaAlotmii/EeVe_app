import 'package:eeve_app/Custom_Widget_/_TrendingEventsList.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
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

  Future<void> _checkIfFavorite() async {
    final result = await _favoritesManager.isFavorite(widget.eventId);
    if (mounted) {
      setState(() {
        isFavorite = result;
      });
    }
  }

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
        success = await _favoritesManager.removeFromFavorites(widget.eventId);
        if (success) {
          _showMessage('Removed from favorites');
        }
      } else {
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
        duration: const Duration(milliseconds: 1100),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Event Details', style: TextStyle(color: primaryTextColor)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: isLoading ? null : _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isLoading ? Colors.grey : (isFavorite ? Colors.red : primaryTextColor),
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
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: secondaryTextColor, size: 16),
                const SizedBox(width: 6),
                Text(widget.location, style: TextStyle(color: secondaryTextColor, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time, color: secondaryTextColor, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.eventTime,
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
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
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white30),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'About this event',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'More events',
              style: TextStyle(
                color: primaryTextColor,
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
                  eventId: widget.eventId,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

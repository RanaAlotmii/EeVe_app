import 'package:eeve_app/custom_Widget_/event_card_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/views/event_detail_view.dart';
import 'package:eeve_app/managers/favorites_manager.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final user = Supabase.instance.client.auth.currentUser;
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
  }

  Future<void> _initializeFavorites() async {
    if (user != null) {
      await _favoritesManager.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    if (user == null) {
      return Scaffold(
        backgroundColor: background,
        body: Center(
          child: Text(
            'Please log in to view your favorites.',
            style: TextStyle(color: textColor, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Favorites',
          style: TextStyle(color: textColor, fontSize: 21.sp, fontWeight: FontWeight.bold,),
        ),
        iconTheme: IconThemeData(color: textColor),
       
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _favoritesManager.favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading favorites',
                      style: TextStyle(color: textColor, fontSize: 14.sp)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _initializeFavorites,
                    child: Text('Retry', style: TextStyle(fontSize: 12.sp)),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Start adding events to your favorites',
                    style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _initializeFavorites,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final event = favorites[index];

                return Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Stack(
                    children: [
                      CompactEventCard(
                        title: event['title'] ?? 'Unknown Event',
                        location: event['location'] ?? 'Unknown Location',
                        imageAsset: event['image_cover'] ?? '',
                        price: ((event['price'] ?? 0) as num).toDouble(),
                        onTap: () {
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
                          );
                        },
                      ),
                      Positioned(
                        top: 55.h,
                        right: 8.w,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                          onPressed: () => _showDeleteConfirmation(event),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> event) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    final bgColor = Theme.of(context).dialogBackgroundColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            'Remove from Favorites',
            style: TextStyle(color: textColor, fontSize: 16.sp),
          ),
          content: Text(
            'Are you sure you want to remove "${event['title']}" from your favorites?',
            style: TextStyle(color: textColor?.withOpacity(0.8), fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(fontSize: 12.sp)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeFromFavorites(event['id']);
              },
              child: Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12.sp)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeFromFavorites(int eventId) async {
    try {
      final success = await _favoritesManager.removeFromFavorites(eventId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites', style: TextStyle(fontSize: 12.sp)),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1100),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove from favorites', style: TextStyle(fontSize: 12.sp)),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1100),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove from favorites', style: TextStyle(fontSize: 12.sp)),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 1100),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

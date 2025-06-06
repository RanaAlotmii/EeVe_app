import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/event_card_small.dart';
import 'package:eeve_app/views/event_detail.dart';


class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: FavoriteManager.favoritesNotifier,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final event = favorites[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetail(
                        title: event['title'],
                        image: event['image_detail'],  // ✅ Show correct detail image
                        imageCover: event['image_cover'], // ✅ we pass this too
                        location: event['location'],
                        price: event['price'],
                        description: event['description'],
                        eventTime: event['event_time'],
                      ),
                    ),
                  );
                },
                child: CompactEventCard(
                  title: event['title'],
                  location: event['location'],
                  imageAsset: event['image_cover'],  // ✅ Show only cover in small cards
                  price: double.tryParse(event['price'].toString()) ?? 0.0,
                ),
              );
            },
          );
        },
      ),
    );
  }
}


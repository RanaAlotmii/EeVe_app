import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final StreamController<List<Map<String, dynamic>>> _favoritesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get favoritesStream =>
      _favoritesController.stream;

  List<Map<String, dynamic>> _currentFavorites = [];

  User? get currentUser => Supabase.instance.client.auth.currentUser;

  Future<void> initialize() async {
    if (currentUser == null) return;

    await _loadFavorites();
    _startRealtimeListener();
  }

  Future<void> _loadFavorites() async {
    if (currentUser == null) return;

    try {
      final favoritesResponse = await Supabase.instance.client
          .from('user_favorites')
          .select('event_id')
          .eq('user_id', currentUser!.id);

      final eventIds =
          favoritesResponse
              .map<int>((item) => item['event_id'] as int)
              .toList();

      if (eventIds.isEmpty) {
        _currentFavorites = [];
        _favoritesController.add(_currentFavorites);
        return;
      }

      final eventsResponse = await Supabase.instance.client
          .from('events')
          .select()
          .in_('id', eventIds);

      _currentFavorites = List<Map<String, dynamic>>.from(eventsResponse);
      _favoritesController.add(_currentFavorites);
    } catch (e) {
      print('Error loading favorites: $e');
      _favoritesController.addError(e);
    }
  }

  void _startRealtimeListener() {
    if (currentUser == null) return;

    Supabase.instance.client
        .from('user_favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUser!.id)
        .listen((data) {
          _loadFavorites();
        });
  }

  Future<bool> addToFavorites(
    int eventId,
    Map<String, dynamic> eventData,
  ) async {
    if (currentUser == null) return false;

    try {
      final existing =
          await Supabase.instance.client
              .from('user_favorites')
              .select('id')
              .eq('user_id', currentUser!.id)
              .eq('event_id', eventId)
              .maybeSingle();

      if (existing != null) {
        print('Already in favorites');
        return true;
      }

      await Supabase.instance.client.from('user_favorites').insert({
        'event_id': eventId,
        'added_at': DateTime.now().toIso8601String(),
        'user_id': currentUser!.id,
      });

      _currentFavorites.add(eventData);
      _favoritesController.add(_currentFavorites);

      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites(int eventId) async {
    if (currentUser == null) return false;

    try {
      final response =
          await Supabase.instance.client
              .from('user_favorites')
              .select('id')
              .eq('user_id', currentUser!.id)
              .eq('event_id', eventId)
              .maybeSingle();

      if (response != null) {
        await Supabase.instance.client
            .from('user_favorites')
            .delete()
            .eq('id', response['id']);

        _currentFavorites.removeWhere((event) => event['id'] == eventId);
        _favoritesController.add(_currentFavorites);

        return true;
      }
      return false;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  Future<bool> isFavorite(int eventId) async {
    if (currentUser == null) return false;

    try {
      final response =
          await Supabase.instance.client
              .from('user_favorites')
              .select('id')
              .eq('user_id', currentUser!.id)
              .eq('event_id', eventId)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> get currentFavorites => _currentFavorites;

  void dispose() {
    _favoritesController.close();
  }
}

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsController extends GetxController {
  RxList events = [].obs;
  RxList categories = [].obs;
  RxList<int> selectedCategories = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await fetchCategories();
    await fetchEvents();
  }

  Future<void> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('categories')
        .select();

    print('[DEBUG] Categories from Supabase: $response');
    categories.value = response;
  }

  Future<void> fetchEvents() async {
    var query = Supabase.instance.client
        .from('events')
        .select();

    if (selectedCategories.isNotEmpty) {
      query = query.in_('category_id', selectedCategories);
    }

    final response = await query;
    print('[DEBUG] Events from Supabase: $response');
    events.value = response;
  }

  void toggleCategory(int categoryId) {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }

    fetchEvents();
  }

  void clearCategories() {
    selectedCategories.clear();
    fetchEvents();
  }

  List<Map<String, dynamic>> getFilteredEvents() {
    return events.cast<Map<String, dynamic>>();
  }

Future<void> refreshEvents() async {
  try {
    await fetchEvents(); 
    update(); 
  } catch (e) {
    print('Error refreshing events: $e');
  }
}

}
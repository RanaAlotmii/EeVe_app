import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/event_card_small.dart';
import 'package:eeve_app/views/event_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];

  bool isLoading = true; // ✅ لمعرفة هل الصفحة تحمل البيانات

  @override
  void initState() {
    super.initState();
    fetchEvents();
    _searchController.addListener(_filterEvents);
  }

  Future<void> fetchEvents() async {
    final response = await Supabase.instance.client
        .from('events')
        .select();

    setState(() {
      allEvents = List<Map<String, dynamic>>.from(response);
      filteredEvents = allEvents;
      isLoading = false; // ✅ الانتهاء من التحميل
    });
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredEvents = allEvents.where((event) {
        final title = event['title'].toString().toLowerCase();
        final location = event['location'].toString().toLowerCase();
        return title.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Search Events',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for events...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // ⏳ أثناء التحميل
                : filteredEvents.isEmpty
                    ? const Center(
                        child: Text(
                          'No events found.\nPlease try a different search.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ) // ✅ لا يوجد نتائج
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredEvents.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetail(
                                    title: event['title'] ?? '',
                                    location: event['location'] ?? '',
                                    image: event['image_detail'] ?? '',
                                    imageCover: event['image_cover'] ?? '',
                                    price: double.tryParse(event['price'].toString())?.toStringAsFixed(2) ?? '0.00',
                                    description: event['description'] ?? '',
                                    eventTime: event['event_time'] ?? '',
                                  ),
                                ),
                              );
                            },
                            child: CompactEventCard(
                              title: event['title'] ?? '',
                              location: event['location'] ?? '',
                              imageAsset: event['image_cover'] ?? '',
                              price: double.tryParse(event['price'].toString()) ?? 0.0,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

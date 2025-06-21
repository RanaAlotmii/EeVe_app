import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/compact_event_card.dart';
import 'package:eeve_app/views/event_detail_view.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
    _searchController.addListener(_filterEvents);
  }

  Future<void> fetchEvents() async {
    final response = await Supabase.instance.client.from('events').select();
    setState(() {
      allEvents = List<Map<String, dynamic>>.from(response);
      filteredEvents = allEvents;
      isLoading = false;
    });
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredEvents =
          allEvents.where((event) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final fieldColor = isDark ? const Color(0xFF1C1C1E) : Colors.grey[200];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Search Events', style: TextStyle( fontSize: 21.sp, fontWeight: FontWeight.bold,)),
     
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for events...',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: hintColor),
                filled: true,
                fillColor: fieldColor,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
          ),

          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredEvents.isEmpty
                    ? Center(
                      child: Text(
                        'No events found.\nPlease try a different search.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: hintColor, fontSize: 16.sp),
                      ),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: filteredEvents.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => EventDetail(
                                eventId: event['id'],
                                title: event['title'] ?? 'Unknown Event',
                                image: event['image_detail'] ?? '',
                                imageCover: event['image_cover'] ?? '',
                                location:
                                    event['location'] ?? 'Unknown Location',
                                price: (event['price'] ?? 0).toString(),
                                description: event['description'] ?? '',
                                eventTime: event['event_time'] ?? '',
                              ),
                            );
                          },
                          child: CompactEventCard(
                            title: event['title'] ?? '',
                            location: event['location'] ?? '',
                            imageAsset: event['image_cover'] ?? '',
                            price:
                                double.tryParse(event['price'].toString()) ??
                                0.0,
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

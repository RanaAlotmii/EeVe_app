import 'package:flutter/material.dart';
import 'package:eeve_app/views/event_detail.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoCard extends StatefulWidget {
  const PromoCard({super.key});

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  Map<String, dynamic>? promoEvent;

  @override
  void initState() {
    super.initState();
    fetchPromoEvent();
  }

  Future<void> fetchPromoEvent() async {
    final response = await Supabase.instance.client
        .from('events')
        .select()
        .eq('title', 'Angham Live Concert in Riyadh')
        .limit(1);

    if (response.isNotEmpty && mounted) {
      setState(() {
        promoEvent = response.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> gradientColors =
        isDark
            ? [const Color(0xFF0F0F10), const Color(0xFF8B57E6)]
            : [
              const Color.fromARGB(255, 165, 159, 182),
              const Color.fromARGB(255, 110, 81, 159),
            ];

    final double imageWidth = MediaQuery.of(context).size.width * 0.42;
    final double imageHeight = imageWidth * (160 / 170);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Something Exciting',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Don't miss out on this special experience",
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed:
                      promoEvent == null
                          ? null
                          : () {
                            Get.to(
                              () => EventDetail(
                                eventId: promoEvent!['id'],
                                title: promoEvent!['title'] ?? '',
                                image: promoEvent!['image_detail'] ?? '',
                                imageCover: promoEvent!['image_cover'] ?? '',
                                location: promoEvent!['location'] ?? '',
                                price:
                                    double.tryParse(
                                      promoEvent!['price'].toString(),
                                    )?.toStringAsFixed(2) ??
                                    '0.00',
                                description: promoEvent!['description'] ?? '',
                                eventTime: promoEvent!['event_time'] ?? '',
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    promoEvent == null ? 'Loading...' : 'Get Ticket Now',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child:
                promoEvent == null
                    ? Container(
                      width: imageWidth,
                      height: imageHeight,
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator()),
                    )
                    : Image.network(
                      promoEvent!['image_cover'] ?? '',
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: imageWidth,
                          height: imageHeight,
                          color: Colors.grey[800],
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
        ],
      ),
    );
  }
}

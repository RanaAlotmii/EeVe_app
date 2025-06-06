import 'package:flutter/material.dart';
import 'package:eeve_app/views/event_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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

  // ✅ نجيب Event معين: Angham Live Concert
  Future<void> fetchPromoEvent() async {
    final response = await Supabase.instance.client
        .from('events')
        .select()
        .eq('title', 'Angham Live Concert in Riyadh') 
        .limit(1);

    if (response.isNotEmpty) {
      setState(() {
        promoEvent = response.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F0F10), Color(0xFF8B57E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Step Into the Spotlight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'From Stage to Screen:\nFeel the Magic',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      promoEvent == null
                          ? null
                          : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EventDetail(
                                      title: promoEvent!['title'] ?? '',
                                      image:
                                          promoEvent!['image_detail'] ??
                                          '', 
                                      imageCover:
                                          promoEvent!['image_cover'] ??
                                          '',
                                      location: promoEvent!['location'] ?? '',
                                      price:
                                          double.tryParse(
                                            promoEvent!['price'].toString(),
                                          )?.toStringAsFixed(2) ??
                                          '0.00',
                                      description:
                                          promoEvent!['description'] ?? '',
                                      eventTime:
                                          promoEvent!['event_time'] ?? '',
                                    ),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    promoEvent == null ? 'Loading...' : 'Get Ticket Now',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                promoEvent == null
                    ? Container(
                      width: 170,
                      height: 160,
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator()),
                    )
                    : Image.network(
                      promoEvent!['image_cover'] ?? '',
                      width: 170,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 170,
                          height: 160,
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

import 'package:eeve_app/custom_Widget_/event_card_small.dart';
//import 'package:eeve_app/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';

class DetailOrderPage extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final int ticketAmount;

  const DetailOrderPage({
    super.key,
    required this.eventData,
    required this.ticketAmount,
  });

  @override
  Widget build(BuildContext context) {
    final String title = eventData['title'] ?? '';
    final String location = eventData['location'] ?? '';
    final String imageCover = eventData['image_cover'] ?? '';
    final double ticketPrice =
        double.tryParse(eventData['price'].toString()) ?? 0.0;
    final String eventDate = eventData['event_date'] ?? ''; // ✅ date added here

    final double totalPrice = ticketAmount * ticketPrice;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Order',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompactEventCard(
              title: title,
              location: location,
              imageAsset: imageCover,
              price: ticketPrice,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1565FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1565FF)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF1565FF), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your booking is protected by EeVe.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ticket',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '$ticketAmount ticket',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dates', style: TextStyle(color: Colors.grey)),
                      Text(
                        eventDate,
                        style: const TextStyle(color: Colors.white),
                      ), // ✅ show the event date here!
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Price Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price', style: TextStyle(color: Colors.grey)),
                      Text(
                        '$ticketAmount x ${ticketPrice.toStringAsFixed(2)} SR',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} SR',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Payment Method',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/visa.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Card',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
        child: CustomButton(
          text: 'Pay Now',
          onPressed: () {
            // Navigator.push(
            // context,
            //  MaterialPageRoute(
            // builder: (_) => PaymentPage(totalPrice: totalPrice),
            //),
            // );
          },
        ),
      ),
    );
  }
}

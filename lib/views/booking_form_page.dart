import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/views/detail_order_page.dart';

class BookingFormPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  BookingFormPage({super.key, required this.eventData});

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Booking', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many tickets would you like to book?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: 'Enter number of tickets',
              controller: amountController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const Spacer(),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                final ticketAmount = int.tryParse(amountController.text) ?? 0;

                if (ticketAmount <= 0) {
                  // Show error if invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid ticket amount.'),
                    ),
                  );
                  return;
                }

                // ✅ Pass also event_date!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailOrderPage(
                          eventData: {
                            'title': eventData['title'],
                            'location': eventData['location'],
                            'image_cover': eventData['image_cover'],
                            'price': eventData['price'],
                            'event_date': eventData['event_date'], // ✅ CORRECT
                          },
                          ticketAmount: ticketAmount,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


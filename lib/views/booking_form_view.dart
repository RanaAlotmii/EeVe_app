import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:eeve_app/views/order_detail_view.dart';

class BookingFormPage extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final int eventId;

  BookingFormPage({super.key, required this.eventData, required this.eventId});

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Booking',
          style: TextStyle(
            color: textColor,
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'How many tickets would you like to book?',
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid ticket amount.'),
                    ),
                  );
                  return;
                }

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
                            'event_date': eventData['event_date'],
                          },
                          ticketAmount: ticketAmount,
                          eventId: eventId,
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

import 'package:eeve_app/custom_Widget_/event_card_small.dart';
import 'package:eeve_app/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailOrderPage extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final int ticketAmount;
  final int eventId;

  const DetailOrderPage({
    super.key,
    required this.eventData,
    required this.ticketAmount,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Color(0xFFE0E0E0);

    final String title = eventData['title'] ?? '';
    final String location = eventData['location'] ?? '';
    final String imageCover = eventData['image_cover'] ?? '';
    final double ticketPrice = double.tryParse(eventData['price'].toString()) ?? 0.0;
    final String eventDate = eventData['event_date'] ?? '';
    final double totalPrice = ticketAmount * ticketPrice;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Detail Order', style: TextStyle(color: primaryTextColor, fontSize: 21.sp, fontWeight: FontWeight.bold,)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompactEventCard(
              title: title,
              location: location,
              imageAsset: imageCover,
              price: ticketPrice,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1565FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF1565FF)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: const Color(0xFF1565FF), size: 18.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Your booking is protected by EeVe.',
                      style: TextStyle(color: primaryTextColor, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Events',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      )),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ticket', style: TextStyle(color: secondaryTextColor, fontSize: 14.sp)),
                      Text('$ticketAmount ticket', style: TextStyle(color: primaryTextColor, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dates', style: TextStyle(color: secondaryTextColor, fontSize: 14.sp)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          eventDate,
                          style: TextStyle(color: primaryTextColor, fontSize: 14.sp),
                          textAlign: TextAlign.right,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text('Price Details',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      )),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price', style: TextStyle(color: secondaryTextColor, fontSize: 14.sp)),
                      Text('$ticketAmount x ${ticketPrice.toStringAsFixed(2)} SR',
                          style: TextStyle(color: primaryTextColor, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price', style: TextStyle(color: secondaryTextColor, fontSize: 14.sp)),
                      Text('${totalPrice.toStringAsFixed(2)} SR',
                          style: TextStyle(color: primaryTextColor, fontSize: 14.sp)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Payment Method',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/visa.png',
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text('Card', style: TextStyle(color: primaryTextColor, fontSize: 14.sp)),
                ],
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 25.h),
        child: CustomButton(
          text: 'Pay Now',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentPage(
                  totalPrice: totalPrice,
                  eventId: eventId,
                  ticketAmount: ticketAmount,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

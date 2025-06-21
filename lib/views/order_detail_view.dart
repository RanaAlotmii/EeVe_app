import 'package:eeve_app/custom_Widget_/compact_event_card.dart';
import 'package:eeve_app/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eeve_app/views/saved_cards_view.dart';

enum PaymentOption { newCard, savedCard }

class DetailOrderPage extends StatefulWidget {
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
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Color(0xFFE0E0E0);

    final String title = widget.eventData['title'] ?? '';
    final String location = widget.eventData['location'] ?? '';
    final String imageCover = widget.eventData['image_cover'] ?? '';
    final double ticketPrice =
        double.tryParse(widget.eventData['price'].toString()) ?? 0.0;
    final String eventDate = widget.eventData['event_date'] ?? '';
    final double totalPrice = widget.ticketAmount * ticketPrice;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Order Detail',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF1565FF),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Your booking is protected by EeVe.',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14.sp,
                      ),
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
                  Text(
                    'Your Events',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${widget.ticketAmount} ticket',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dates',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          eventDate,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.right,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Price Details',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${widget.ticketAmount} x ${ticketPrice.toStringAsFixed(2)} SR',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} SR',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
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

            _buildPaymentOption(
              PaymentOption.savedCard,
              'Use Saved Card',
              'Choose from your saved cards',
              Icons.credit_card,
              cardColor,
              primaryTextColor,
              secondaryTextColor,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              PaymentOption.newCard,
              'Add New Card',
              'Enter new card details',
              Icons.add_card,
              cardColor,
              primaryTextColor,
              secondaryTextColor,
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
            _handlePaymentNavigation(context, totalPrice);
          },
        ),
      ),
    );
  }

  PaymentOption selectedPaymentOption = PaymentOption.newCard;

  Widget _buildPaymentOption(
    PaymentOption option,
    String title,
    String subtitle,
    IconData icon,
    Color cardColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    final isSelected = selectedPaymentOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7A4EB0) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF7A4EB0).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF7A4EB0) : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF7A4EB0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentNavigation(BuildContext context, double totalPrice) {
    switch (selectedPaymentOption) {
      case PaymentOption.newCard:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => PaymentPage(
                  totalPrice: totalPrice,
                  eventId: widget.eventId,
                  ticketAmount: widget.ticketAmount,
                ),
          ),
        );
        break;
      case PaymentOption.savedCard:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => SavedCardsPage(
                  totalPrice: totalPrice,
                  eventId: widget.eventId,
                  ticketAmount: widget.ticketAmount,
                ),
          ),
        );
        break;
    }
  }
}

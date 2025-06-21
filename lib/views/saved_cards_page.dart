import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:eeve_app/views/payment_page.dart';
import 'package:eeve_app/views/payment_success_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedCardsPage extends StatefulWidget {
  final double totalPrice;
  final int eventId;
  final int ticketAmount;

  const SavedCardsPage({
    super.key,
    required this.totalPrice,
    required this.eventId,
    required this.ticketAmount,
  });

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  List<Map<String, dynamic>> savedCards = [];
  Map<String, dynamic>? selectedCard;
  bool isLoading = true;
  bool isPaying = false;
  String cvvCode = '';
  final TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedCards();
  }

  @override
  void dispose() {
    cvvController.dispose();
    super.dispose();
  }

  Future<void> loadSavedCards() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('user_card')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        setState(() {
          savedCards = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading saved cards: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cards: $e')),
      );
    }
  }

  String _formatExpiryDate(dynamic expiryMonth) {
    if (expiryMonth == null) return 'XX/XX';

    String value = expiryMonth.toString().padLeft(4, '0');

    if (value.length != 4) return 'XX/XX';

    String month = value.substring(0, 2);
    String year = value.substring(2, 4);

    return '$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Saved Cards',
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7A4EB0)),
            )
          : savedCards.isEmpty
              ? _buildEmptyState(textColor)
              : _buildCardsList(textColor, cardColor),
      bottomNavigationBar: selectedCard != null
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 25.h),
                child: CustomButton(
                  text: isPaying
                      ? 'Processing...'
                      : 'Pay ${widget.totalPrice.toStringAsFixed(2)} SR',
                  onPressed: isPaying ? null : _handlePayment,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off,
            size: 80.sp,
            color: textColor.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Saved Cards',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a card to make payments faster',
            style: TextStyle(
              fontSize: 16.sp,
              color: textColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentPage(
                    totalPrice: widget.totalPrice,
                    eventId: widget.eventId,
                    ticketAmount: widget.ticketAmount,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A4EB0),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Add New Card',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList(Color textColor, Color cardColor) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: savedCards.length,
            itemBuilder: (context, index) {
              final card = savedCards[index];
              final isSelected = selectedCard?['id'] == card['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCard = card;
                    cvvCode = '';
                    cvvController.clear();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1565FF) : Colors.transparent,
                      width: 4.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF7A4EB0),
                            const Color(0xFF7A4EB0).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'VISA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  card['card_number'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CARD HOLDER',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          card['card_name'] ?? 'Card Holder',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'EXPIRES',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          _formatExpiryDate(card['expiry_date']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: const Color(0xFF7A4EB0),
                                  size: 16.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (selectedCard != null) ...[
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter CVV to complete payment',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFF7A4EB0)),
                      ),
                      suffixIcon: Icon(
                        Icons.security,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    style: TextStyle(color: textColor, fontSize: 16.sp),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        cvvCode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _handlePayment() async {
    if (selectedCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a card')),
      );
      return;
    }
    if (cvvCode.isEmpty || cvvCode.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid CVV')),
      );
      return;
    }
    if (cvvCode != selectedCard!["cvv"].toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CVV isn\'t corrcet ')),
      );
      return;
    }

    setState(() {
      isPaying = true;
    });

    try {
      final expiryMonth = selectedCard!['expiry_date'].toString();
      final month = int.parse(expiryMonth.substring(0, 2));
      final year = int.parse("20${expiryMonth.substring(2, 4)}");

      final url = Uri.parse('https://api.moyasar.com/v1/payments');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('sk_test_MKvC2oeFkZf8dN2TeS7AQbVYNkBrZekZQrCxfPQU'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "source": {
            "type": "creditcard",
            "name": selectedCard!["card_name"],
            "number": selectedCard!["card_number"].toString(),
            "month": month,
            "year": year,
            "cvc": cvvCode,
          },
          "amount": (widget.totalPrice * 100).toInt(),
          "currency": "SAR",
          "description": "Ticket Purchase",
          "callback_url": "https://example.com/callback",
        }),
      );

      if (response.statusCode == 201) {
        await Supabase.instance.client.from('tickets').insert({
          'event_id': widget.eventId,
          'quantity': widget.ticketAmount,
          'user_id': Supabase.instance.client.auth.currentUser!.id,
          'booking_date': DateTime.now().toIso8601String(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isPaying = false;
      });
    }
  }
}

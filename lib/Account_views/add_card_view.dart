import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Custom_Widget_/Custom_button.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void dispose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in')));
      return;
    }

    final cardName = cardNameController.text.trim();
    final cardNumber = cardNumberController.text.trim();
    final expiry = expiryDateController.text.trim();
    final cvv = cvvController.text.trim();

    if (cardName == "" || cardNumber == "" || expiry == "" || cvv == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be completed')),
      );
      return;
    }

    if (RegExp(r'^\d+$').hasMatch(cardName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card name cannot be only numbers')),
      );
      return;
    }

    if (cardNumber.length > 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card number must be 16 digits or less')),
      );
      return;
    }

    if (expiry.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expiry date must be in MM/YY format')),
      );
      return;
    }

    if (cvv.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CVV must be 4 digits or 3')),
      );
      return;
    }

    final month = int.parse(expiry.substring(0, 2));
    final year = int.parse('20${expiry.substring(3)}');
    final final_expiry = "${expiry.substring(0, 2)}${expiry.substring(3)}";

    if (month < 1 || month > 12) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid expiry month')));
      return;
    }

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0);
    if (expiryDate.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expiry date is in the past')),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('user_card').insert({
        'card_name': cardName,
        'card_number': int.tryParse(cardNumber) ?? 0,
        'expiry_date': int.tryParse(final_expiry) ?? 0,
        'cvv': int.tryParse(cvv) ?? 0,
        'user_id': user.id,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Add Card',
          style: TextStyle(
            color: textColor,
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: cardNameController,
              style: TextStyle(color: textColor, fontSize: 15.sp),
              decoration: InputDecoration(
                labelText: 'Card Name',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor, fontSize: 15.sp),
              decoration: InputDecoration(
                labelText: 'Card Number',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDark ? Colors.white12 : Colors.black12,
                counterText: "",
              ),
              maxLength: 16,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryDateController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor, fontSize: 15.sp),
                    inputFormatters: [ExpiryDateInputFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      labelStyle: TextStyle(color: textColor),
                      filled: true,
                      fillColor: isDark ? Colors.white12 : Colors.black12,
                      counterText: '',
                    ),
                    maxLength: 5,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor, fontSize: 15.sp),
                    decoration: InputDecoration(
                      labelText: 'CVC / CVV',
                      labelStyle: TextStyle(color: textColor),
                      filled: true,
                      fillColor: isDark ? Colors.white12 : Colors.black12,
                      counterText: '',
                    ),
                    maxLength: 4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            CustomButton(text: 'Add Card', onPressed: _addCard),
          ],
        ),
      ),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.length >= 2) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

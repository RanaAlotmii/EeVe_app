import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:eeve_app/custom_Widget_/CustomTextField.dart';
import 'package:eeve_app/views/payment_success_page.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expiryController.addListener(formatExpiryDate);
  }

  void formatExpiryDate() {
    final text = expiryController.text;
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length <= 2) {
      expiryController.value = TextEditingValue(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    } else {
      final formatted = '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, digitsOnly.length > 4 ? 4 : digitsOnly.length)}';
      expiryController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void dispose() {
    expiryController.removeListener(formatExpiryDate);
    expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Add card', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Card Name', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              hintText: 'Enter cardholder name',
              controller: cardNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Card Number', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              hintText: 'Card Number (16 digits)',
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expiry Date', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: 'MM/YY',
                        controller: expiryController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CVC / CVV', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: '3 digits',
                        controller: cvcController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              text: 'Pay Now',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

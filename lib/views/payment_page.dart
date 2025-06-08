import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter/services.dart';
import 'package:eeve_app/custom_Widget_/Custom_button.dart';
import 'package:eeve_app/views/payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  const PaymentPage({super.key, required this.totalPrice});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isPaying = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Add Card', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                cardBgColor: const Color(0xFF7A4EB0),
                isHolderNameVisible: true,
                obscureCardNumber: false,
                obscureCardCvv: false,
                onCreditCardWidgetChange: (brand) {
                  print('Card brand: $brand');
                },
              ),
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
                ),
                child: CreditCardForm(
                  formKey: formKey,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
          child: CustomButton(
            text: 'Pay ${widget.totalPrice.toStringAsFixed(2)} SR',
            onPressed: handlePayPressed,
          ),
        ),
      ),
    );
  }

  void handlePayPressed() {
    if (isPaying) return;
    handlePay();
  }

  void onCreditCardModelChange(CreditCardModel model) {
    setState(() {
      cardNumber = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

  Future<void> handlePay() async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form correctly')),
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(cardHolderName.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Card Holder Name (letters only)'),
        ),
      );
      return;
    }

    setState(() {
      isPaying = true;
    });

    try {
      final parts = expiryDate.split('/');
      final month = int.parse(parts[0]);
      final year = int.parse('20${parts[1]}');

      final url = Uri.parse('https://api.moyasar.com/v1/payments');
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('sk_test_MKvC2oeFkZf8dN2TeS7AQbVYNkBrZekZQrCxfPQU'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "source": {
            "type": "creditcard",
            "name": cardHolderName,
            "number": cardNumber.replaceAll(' ', ''),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isPaying = false;
      });
    }
  }
}

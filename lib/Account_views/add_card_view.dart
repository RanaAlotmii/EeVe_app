import 'package:flutter/material.dart';
import '../Custom_Widget_/Custom_button.dart'; // ✅ Import your custom button

class AddCardView extends StatelessWidget {
  const AddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Add Card',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Card Name',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVC / CVV',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            /// ✅ Use your custom button here
            CustomButton(
              text: 'Add Card',
              onPressed: () {
                // TODO: Save the card logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

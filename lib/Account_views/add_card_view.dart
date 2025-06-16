import 'package:flutter/material.dart';
import '../Custom_Widget_/Custom_button.dart'; // ✅ Import your custom button

class AddCardView extends StatelessWidget {
  const AddCardView({super.key});

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
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Card Name',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: textColor),
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      labelStyle: TextStyle(color: textColor),
                      filled: true,
                      fillColor: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: textColor),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVC / CVV',
                      labelStyle: TextStyle(color: textColor),
                      filled: true,
                      fillColor: isDark ? Colors.white12 : Colors.black12,
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

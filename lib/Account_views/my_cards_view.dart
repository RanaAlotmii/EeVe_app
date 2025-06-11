import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/credit_card_widget.dart';
import '../Custom_Widget_/Custom_button.dart';
import 'add_card_view.dart';

class MyCardsView extends StatelessWidget {
  const MyCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardBackground = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text('My Cards', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0), // فقط من الأعلى
        child: Column(
          children: [
            CustomCreditCard(
              backgroundColor: cardBackground,
            ),
            const Spacer(),
          ],
        ),
      ),

      /// ✅ هنا زر الإضافة في الأسفل
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
        child: CustomButton(
          text: "Add New Card",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCardView()),
            );
          },
        ),
      ),
    );
  }
}

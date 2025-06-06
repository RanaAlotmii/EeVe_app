import 'package:flutter/material.dart';
import 'package:eeve_app/Custom_Widget_/credit_card_widget.dart';
import '../Custom_Widget_/Custom_button.dart';
import 'add_card_view.dart';

class MyCardsView extends StatelessWidget {
  const MyCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Cards', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40), //  lifted bottom
        child: Column(
          children: [
            const CustomCreditCard(),
            const Spacer(),
            CustomButton(
              text: "Add New Card",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCardView()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

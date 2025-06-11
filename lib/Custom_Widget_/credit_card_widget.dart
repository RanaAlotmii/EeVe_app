import 'package:flutter/material.dart';

class CustomCreditCard extends StatelessWidget {
  final Color backgroundColor;

  const CustomCreditCard({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final isDarkCard = ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark;
    final contentColor = isDarkCard ? Colors.white : Colors.black;
    final labelColor = isDarkCard ? Colors.white70 : Colors.grey[800];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + VISA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card, color: contentColor, size: 32),
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Card Number
          Text(
            '**** **** **** 7421',
            style: TextStyle(
              color: contentColor,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Bottom Row: Cardholder & Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARDHOLDER',
                    style: TextStyle(color: labelColor, fontSize: 12),
                  ),
                  Text(
                    'Naba AlHarbi',
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(color: labelColor, fontSize: 12),
                  ),
                  Text(
                    '12/26',
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

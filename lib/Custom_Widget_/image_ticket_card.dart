import 'package:flutter/material.dart';

class ImageTicketCard extends StatelessWidget {
  final String imageAsset;

  const ImageTicketCard({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        imageAsset,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }
}


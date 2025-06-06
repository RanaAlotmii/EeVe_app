import 'package:flutter/material.dart';
import 'package:eeve_app/views/search_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        const SizedBox(width: 12),

        // Text & Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hi, Ahmed 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Riyadh, SA',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ),

        // Settings Icon with onTap
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}


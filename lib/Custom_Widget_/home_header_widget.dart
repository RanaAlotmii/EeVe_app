import 'package:flutter/material.dart';
import 'package:eeve_app/views/search_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final user = Supabase.instance.client.auth.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final response =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', user?.id)
              .maybeSingle();

      setState(() {
        userData = response;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'User';
    final profileImage = userData?['profile_image'];

    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 24,
          backgroundImage:
              profileImage != null && profileImage.isNotEmpty
                  ? NetworkImage(profileImage)
                  : const AssetImage('assets/profileImage.png')
                      as ImageProvider,
        ),
        const SizedBox(width: 12),

        // Text & Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Riyadh, SA',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
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

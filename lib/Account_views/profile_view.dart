import 'package:flutter/material.dart';
import 'package:eeve_app/Account_views/about_app_view.dart';
import 'package:eeve_app/Account_views/edit_profile_view.dart';
import 'package:eeve_app/Account_views/my_cards_view.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/route_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isDarkMode = true;
  bool isNotificationsOn = false;

  final _supabase = Supabase.instance.client;

  String name = '';
  String email = '';
  String gender = '-';
  String dob = '';
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response =
          await _supabase
              .from('users')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (response != null) {
        setState(() {
          name = response['name'] ?? 'User Name';
          email = response['email'] ?? 'user@example.com';
          gender = response['gender'] ?? '-';
          dob = response['date_of_birth'] ?? '';
          final img = response['profile_image'];
          profileImage =
              (img != null && img.toString().trim().isNotEmpty) ? img : '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImageWidget;

    if (profileImage.startsWith('http')) {
      profileImageWidget = NetworkImage(profileImage);
    } else {
      profileImageWidget = const AssetImage('assets/profileImage.png');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Account', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Info
              Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: profileImageWidget),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Text(
                'Personal Info',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.white),
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileView(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.white),
                title: const Text(
                  'My Cards',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCardsView(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.confirmation_number,
                  color: Colors.white,
                ),
                title: const Text(
                  'Tickets',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCardsView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              const Text('Settings', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 16),

              // Dark Mode Switch
              SwitchListTile(
                value: isDarkMode,
                onChanged: (val) {
                  setState(() {
                    isDarkMode = val;
                  });
                },
                title: const Text(
                  'Dark mode',
                  style: TextStyle(color: Colors.white),
                ),
                secondary: const Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.white,
                ),
                activeColor: const Color(0xFF8B57E6),
              ),

              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'About App',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAppView(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  Get.offAll(() => const SigninView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

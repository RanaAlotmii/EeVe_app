import 'package:flutter/material.dart';
import 'package:eeve_app/Account_views/about_app_view.dart';
import 'package:eeve_app/Account_views/edit_profile_view.dart';
import 'package:eeve_app/Account_views/my_cards_view.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
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

  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user?.userMetadata); // 👈 هذا السطر

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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        user?.userMetadata?['profile_image'] != null &&
                                user!.userMetadata!['profile_image']
                                    .toString()
                                    .isNotEmpty
                            ? NetworkImage(user?.userMetadata!['profile_image'])
                            : const AssetImage('assets/profileImage.png')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.userMetadata?['name'] ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user?.email ?? 'user@example.com',
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
                    MaterialPageRoute(builder: (context) => const MyCardsView()),
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
                    MaterialPageRoute(builder: (context) => const MyCardsView()),
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

              // Notification Switch
              SwitchListTile(
                value: isNotificationsOn,
                onChanged: (val) {
                  setState(() {
                    isNotificationsOn = val;
                  });
                },
                title: const Text(
                  'Notification',
                  style: TextStyle(color: Colors.white),
                ),
                secondary: const Icon(
                  Icons.notifications_none,
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
                    MaterialPageRoute(builder: (context) => const AboutAppView()),
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


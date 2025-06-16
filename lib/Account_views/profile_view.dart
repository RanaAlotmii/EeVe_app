import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:eeve_app/views/home_view.dart';
import 'package:eeve_app/views/my_ticket_view.dart';
import 'package:eeve_app/views/my_ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/Account_views/about_app_view.dart';
import 'package:eeve_app/Account_views/edit_profile_view.dart';
import 'package:eeve_app/Account_views/my_cards_view.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart'
    as app_provider; // ✅ هنا استخدمنا prefix
import 'package:eeve_app/managers/theme_service.dart';

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

  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeService = app_provider.Provider.of<ThemeService>(
      context,
      listen: false,
    );
    isDarkMode = _themeService.themeMode == ThemeMode.dark;
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
      print('Error loading user data: \$e');
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
      appBar: AppBar(title: const Text('My Account'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: profileImageWidget),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.bodyLarge),
                      Text(email, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Personal Info',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                onTap: () {
                  Get.to(
                    () => const EditProfileView(),
                    //const EditProfileView(),
                    // HomeView()
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('My Cards'),
                onTap: () {
                  Get.to(
                    () => const MyCardsView(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: const Text('Tickets'),
                onTap: () {
                  MainNavShell.mainTabController.jumpToTab(
                    2,
                  ); 
                },
              ),
              const SizedBox(height: 24),
              Text('Settings', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              SwitchListTile(
                value: isDarkMode,
                onChanged: (val) {
                  setState(() {
                    isDarkMode = val;
                    _themeService.toggleTheme(val);
                  });
                },
                title: const Text('Dark mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
                activeColor: const Color(0xFF8B57E6),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About App'),
                onTap: () {
                  Get.to(
                    () => const AboutAppView(),
                    );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
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

import 'package:eeve_app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:eeve_app/auth_views/signup_view.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bzlbrgttqaoeqdvotjmy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6bGJyZ3R0cWFvZXFkdm90am15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzQ4NDAsImV4cCI6MjA2MjYxMDg0MH0.gY4XIN9gpcoQ-eEPll4cPOjbTZn1VmLw8dN3tQHWZOI',
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EEVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'PlusJakartaSans'),

      home:SplashView(),
    );
  }
}

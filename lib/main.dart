import 'package:eeve_app/Account_views/profile_view.dart';
import 'package:eeve_app/auth_views/welcome_view.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:eeve_app/views/home_view.dart';
import 'package:eeve_app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // ✅ إضافة
import 'package:eeve_app/managers/theme_service.dart'; // ✅ إضافة

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Ai_views/Ai_getstarted.dart';
// import 'package:eeve_app/api/openai_config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeOpenAI();

  await Supabase.initialize(
    url: 'https://bzlbrgttqaoeqdvotjmy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6bGJyZ3R0cWFvZXFkdm90am15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzQ4NDAsImV4cCI6MjA2MjYxMDg0MH0.gY4XIN9gpcoQ-eEPll4cPOjbTZn1VmLw8dN3tQHWZOI',
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return GetMaterialApp(
          title: 'EEVE',
          debugShowCheckedModeBanner: false,

          // ✅ Light Theme
          theme: ThemeData(
            fontFamily: 'PlusJakartaSans',
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF8B57E6),
              unselectedItemColor: Colors.black45,
            ),
          ),

          // ✅ Dark Theme
          darkTheme: ThemeData(
            fontFamily: 'PlusJakartaSans',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF121212),
              selectedItemColor: Color(0xFF8B57E6),
              unselectedItemColor: Colors.white54,
            ),
          ),

          themeMode: themeService.themeMode, // ✅ استخدام الوضع حسب المستخدم
          home: WelcomeView(),
        );
      },
    );
  }
}
    
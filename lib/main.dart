import 'package:eeve_app/views/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/auth_views/signin_view.dart';
import 'package:eeve_app/auth_views/verification_code_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/splash_view.dart';
import 'Ai_views/Ai_getstarted.dart';
import 'Ai_views/ai_chat_view.dart';
import 'Ai_views/ai_chat_results_view.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'Ai_views/Ai_onboarding_view.dart';
import 'package:get/get.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://bzlbrgttqaoeqdvotjmy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6bGJyZ3R0cWFvZXFkdm90am15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzQ4NDAsImV4cCI6MjA2MjYxMDg0MH0.gY4XIN9gpcoQ-eEPll4cPOjbTZn1VmLw8dN3tQHWZOI',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EEVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'PlusJakartaSans'),

      home: SplashView(),
    );
  }
}

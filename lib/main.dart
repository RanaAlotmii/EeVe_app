import 'package:eeve_app/services/theme_service.dart';
import 'package:eeve_app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:eeve_app/api/openai_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initializeOpenAI();
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
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              title: 'EEVE',
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                final mediaQuery = MediaQuery.of(context);
                return MediaQuery(
                  data: mediaQuery.copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
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
              themeMode: themeService.themeMode,
              home: SplashView(),
            );
          },
        );
      },
    );
  }
}

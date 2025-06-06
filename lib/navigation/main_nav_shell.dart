import 'package:eeve_app/Account_views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:eeve_app/views/my_ticket_view2.dart';

import '../views/home_view.dart';
import '../views/favorites_view.dart';
import '../views/my_ticket_view.dart';
import '../Ai_views/Ai_getstarted.dart';


class MainNavShell extends StatefulWidget {
  const MainNavShell({super.key});

  // ✅ Global controller — we will use this from anywhere (example: PaymentSuccessPage)
  static final PersistentTabController mainTabController = PersistentTabController(initialIndex: 0);

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  @override
  void initState() {
    super.initState();
    // ✅ Put EventsController once when MainNavShell is created
    Get.put(EventsController());
  }

  List<Widget> _buildScreens() {
    return [
      HomeView(),
      FavoritesView(key: UniqueKey()),
      const Myticket(),
      const AiGetStartedView(),
      const ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: const Color(0xFF8B57E6),
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite_border),
        title: ("Favorites"),
        activeColorPrimary: const Color(0xFF8B57E6),
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.confirmation_number, color: Colors.white),
        title: ("My Ticket"),
        activeColorPrimary: const Color(0xFF8B57E6),
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.auto_awesome),
        title: ("EveAI"),
        activeColorPrimary: const Color(0xFF8B57E6),
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title: ("Profile"),
        activeColorPrimary: const Color(0xFF8B57E6),
        inactiveColorPrimary: Colors.white70,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: MainNavShell.mainTabController, // ✅ use global controller
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: const Color(0xFF121212),
      navBarHeight: 60,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(12.0),
        colorBehindNavBar: Colors.black,
      ),
      navBarStyle: NavBarStyle.style15,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eeve_app/views/search_page.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/controllers/profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final user = Supabase.instance.client.auth.currentUser;
  Map<String, dynamic>? userData;
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    getUserData();
    profileController = Get.find<ProfileController>();
  }

  Future<void> getUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user?.id)
          .maybeSingle();

      setState(() {
        userData = response;
      });
      profileController.updateProfileImage(userData?['profile_image'] ?? '');
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'User';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Row(
      children: [
        Obx(() {
          final profileImage = profileController.profileImage.value;
          return CircleAvatar(
            radius: 24.r,
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : const AssetImage('assets/profileImage.png') as ImageProvider,
          );
        }),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name 👋',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.location_on, color: subTextColor, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    'Riyadh, SA',
                    style: TextStyle(color: subTextColor, fontSize: 13.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const SearchPage(),
                fullscreenDialog: true, transition: Transition.cupertino);
          },
          child: Container(
            height: 38.h,
            width: 38.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.black12,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.search, color: textColor, size: 20.sp),
          ),
        ),
      ],
    );
  }
}

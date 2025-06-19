import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryList extends StatelessWidget {
  final EventsController controller = Get.find<EventsController>();
  CategoryList({super.key});

  static const Map<int, String> iconMap = {
    1: 'assets/concert.png',
    2: 'assets/room-service.png',
    3: 'assets/game-controller.png',
    4: 'assets/ticket.png',
    5: 'assets/puzzle.png',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconBackground = isDark ? const Color(0xFF1E1E2C) : Colors.grey[200]!;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color selectedTextColor = isDark ? Colors.white : const Color(0xFF8B57E6);

    return SizedBox(
      height: 110.h,
      child: Obx(() {
        final categories = controller.categories;
        final selected = controller.selectedCategories;

        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final int categoryId = category['id'];
            final bool isSelected = selected.contains(categoryId);
            final String iconPath = iconMap[categoryId] ?? 'assets/default.png';

            return Obx(() {
              final isSelected = controller.selectedCategories.contains(categoryId);

              return InkWell(
                borderRadius: BorderRadius.circular(100.r),
                onTap: () {
                  controller.toggleCategory(categoryId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 68.w,
                            height: 68.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFF8B57E6), Color(0xFFB57CE6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: isDark
                                          ? [const Color(0xFF2A2A3A), const Color(0xFF3A3A4A)]
                                          : [Colors.grey[300]!, Colors.grey[200]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF8B57E6).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? (isDark ? const Color(0xff151515) : Colors.white.withOpacity(0.95))
                                      : iconBackground,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    iconPath,
                                    height: 28.h,
                                    width: 28.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isSelected ? selectedTextColor : textColor,
                          fontSize: 12.5.sp,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        child: Text(category['name'] ?? ''),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }
}

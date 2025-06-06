import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/events_controller.dart';

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
    return SizedBox(
      height: 110,
      child: Obx(() {
        final categories = controller.categories;

        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            final int categoryId = category['id'];
            final bool isSelected = controller.selectedCategories.contains(categoryId);

            final String iconPath = iconMap[categoryId] ?? 'assets/default.png';

            return InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                controller.toggleCategory(categoryId);
              },
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF8B57E6), Color(0xFF8B57E6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF0F0F10), Color(0xFF8B57E6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1E1E2C),
                        ),
                        child: Center(
                          child: Image.asset(
                            iconPath,
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:dotted_line/dotted_line.dart';
import 'package:eeve_app/main.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Ticketdetails extends StatelessWidget {
  final String name;
  final String time;
  final String id;
  final String image_url;
  final String quantity;

  const Ticketdetails({
    super.key,
    required this.name,
    required this.time,
    required this.id,
    required this.image_url,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: theme.iconTheme.color,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
              offset: Offset(-17.w, 40.h),
              onSelected: (value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Delete Ticket'),
                          content: const Text(
                            'Are you sure you want to delete this ticket?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await supabase
                                    .from("tickets")
                                    .delete()
                                    .eq('id', id);
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, _, __) =>
                                            const MainNavShell(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: SizedBox(width: 120, child: Text('Delete')),
                    ),
                  ],
            ),
          ),
        ],
        title: Text(
          'Ticket Detail',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              height: 566.h,
              width: 340.w,
              decoration: BoxDecoration(
                gradient:
                    isDark
                        ? const LinearGradient(
                          colors: [Color(0xFF2B1B4D), Color(0xFF1A1C33)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 196, 191, 209),
                            Color.fromARGB(255, 122, 109, 143),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 17.h),
                  Center(
                    child: Container(
                      width: 279.w,
                      height: 152.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: NetworkImage(image_url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 31.w),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 31.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Quantity:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          quantity,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 85.h,
                          left: 20.w,
                          right: 15.w,
                          child: DottedLine(
                            lineLength: 300.w,
                            dashLength: 6.w,
                            dashColor: secondaryTextColor,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 70.h,
                          child: Container(
                            width: 15.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70.h,
                          right: 0,
                          child: Container(
                            width: 15.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.r),
                                topLeft: Radius.circular(20.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      '#$id',
                      style: TextStyle(
                        fontSize: 43.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
            SizedBox(height: 49.h),
          ],
        ),
      ),
    );
  }
}

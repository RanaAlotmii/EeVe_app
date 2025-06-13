import 'package:dotted_line/dotted_line.dart';
import 'package:eeve_app/main.dart';
import 'package:eeve_app/navigation/main_nav_shell.dart';
import 'package:eeve_app/views/my_ticket_view.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
              offset: const Offset(-17, 40),
              onSelected: (value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Ticket'),
                      content: const Text('Are you sure you want to delete this ticket?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await supabase.from("tickets").delete().eq('id', id);
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(pageBuilder: (context, _, __) => const MainNavShell()),
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: SizedBox(width: 120, child: Text('Delete')),
                ),
              ],
            ),
          ),
        ],
        title: Text('Ticket Detail', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              height: 566,
              width: 340,
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF2B1B4D), Color(0xFF1A1C33)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color.fromARGB(255, 196, 191, 209), Color.fromARGB(255, 122, 109, 143)],
                        //   colors: [Color.fromARGB(255, 165, 159, 182),  Color.fromARGB(255, 110, 81, 159)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 17),
                  Center(
                    child: Container(
                      width: 279,
                      height: 152,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(image_url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Quantity:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          quantity,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
                          top: 85,
                          left: 20,
                          right: 15,
                          child: DottedLine(
                            lineLength: 300,
                            dashLength: 6,
                            dashColor: secondaryTextColor,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 70,
                          child: Container(
                            width: 15,
                            height: 30,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          right: 0,
                          child: Container(
                            width: 15,
                            height: 30,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
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
                        fontSize: 43,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 49),
          ],
        ),
      ),
    );
  }
}

import 'package:dotted_line/dotted_line.dart';
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
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(Icons.more_vert, color: theme.iconTheme.color),
          ),
        ],
        title: Text('Ticket Detail', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),

            // TicketDetailsCard(),
            Container(
              height: 536,
              width: 340,
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF2B1B4D), Color(0xFF1A1C33)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isDark ? null : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 17),

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

                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
                    child: Text(
                      // 'E-Sports World Cup Riyadh 2025',
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          // '5:00 PM – 10:00 PM',
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'Quantity:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          // '5:00 PM – 10:00 PM',
                          quantity,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 0),

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
                            dashColor: theme.textTheme.bodyMedium?.color ?? Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 70,
                          // right: 0,
                          child: Container(
                            width: 15,
                            height: 30,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          // left: 100,
                          top: 70,
                          right: 0,
                          child: Container(
                            width: 15,
                            height: 30,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
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
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            SizedBox(height: 49),
          ],
        ),
      ),
    );
  }
}

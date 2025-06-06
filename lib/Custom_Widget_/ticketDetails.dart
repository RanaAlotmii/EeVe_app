import 'package:dotted_line/dotted_line.dart';
// import 'package:eeve_app/custom_Widget_/appColors.dart' as appColors;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Ticketdetails extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String id;
  final String image_url;
  const Ticketdetails({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    required this.id,
    required this.image_url,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF121212),

        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
          title: Text('Ticket Detail', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xFF121212),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2B1B4D), Color(0xFF1A1C33)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                            image: AssetImage(image_url),
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
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 31.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                // 'September 14, 2024',
                                date,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                // '5:00 PM – 10:00 PM',
                                time,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 115,
                            left: 20,
                            right: 15,
                            child: DottedLine(
                              lineLength: 300,
                              dashLength: 6,
                              dashColor: Colors.white,
                              // dashColor: Color(0Xff272835),
                              // direction: Axis.vertical,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 100,
                            // right: 0,
                            child: Container(
                              width: 15,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xFF121212),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            // left: 100,
                            top: 100,
                            right: 0,
                            child: Container(
                              width: 15,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xFF121212),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              SizedBox(height: 49),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1565ff),
                  minimumSize: Size(327, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Explore more events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

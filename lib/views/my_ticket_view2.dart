// import 'package:eeve_app/custom_Widget_/appColors.dart' as appColors;
// import 'package:eeve_app/myTicket/ticketDetails.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart'; //flutter pub add dotted_line
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:eeve_app/Custom_Widget_/ticketDetails.dart';

class Myticket extends StatefulWidget {
  const Myticket({super.key});

  @override
  State<Myticket> createState() => _MyticketState();
}

class _MyticketState extends State<Myticket> {
  bool isUpcoming = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: appColors.background1,
        backgroundColor: Color(0xFF121212),

        appBar: AppBar(
          title: Text(
            'My Ticket',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF121212),
        ),

        body: Center(
          child: Column(
            children: [
              SizedBox(height: 32),

              Container(
                width: 327,
                height: 57,
                decoration: BoxDecoration(
                  color: Color(0xFF1A1B25),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isUpcoming = true;
                          });
                        },
                        child: Container(
                          width: 151.5,
                          height: 41,
                          decoration: BoxDecoration(
                            color:
                                isUpcoming
                                    ? Color(0xff1565ff)
                                    : Color(0xFF1A1B25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Upcoming',
                              style: TextStyle(
                                color:
                                    isUpcoming
                                        ? Colors.white
                                        : Color(0xff818898),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isUpcoming = false;
                          });
                        },
                        child: Container(
                          width: 151.5,
                          height: 41,
                          decoration: BoxDecoration(
                            color:
                                isUpcoming
                                    ? Color(0xFF1A1B25)
                                    : Color(0xff1565ff),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Past Tikect',
                              style: TextStyle(
                                color:
                                    isUpcoming
                                        ? Color(0xff818898)
                                        : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32),

              isUpcoming
                  ? viewTicketCard()
                  : Text(
                    'test',
                    style: TextStyle(color: Colors.white, fontSize: 27),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class viewTicketCard extends StatelessWidget {
  const viewTicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicketCard(
          eventName: 'E-Sports World Cup Riyadh 2025',
          time: '6:30 PM',
          date: 'Fri, 14 September',
          ticketNumber: '126548',
          image_url: 'assets/event2.png'
          
        ),

        SizedBox(height: 32),

        TicketCard(
          eventName: 'E-Sports World Cup Riyadh 2025',
          time: '6:30 PM',
          date: 'Fri, 14 September',
          ticketNumber: '126548',
          image_url:  'assets/event2.png'

        ),
      ],
    );
  }
}

class TicketCard extends StatelessWidget {
  final String eventName;
  final String time;
  final String date;
  final String ticketNumber;
  final String image_url;

  const TicketCard({
    Key? key,
    required this.eventName,
    required this.time,
    required this.date,
    required this.ticketNumber,
    required this.image_url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(
        //   Ticketdetails(
        //   name: eventName,
        //   time: time,
        //   date: date,
        //   id: ticketNumber,
        //   image_url: image_url,
        //   ),
        // );
        
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => 
          Ticketdetails(
          name: eventName,
          time: time,
          date: date,
          id: ticketNumber,
          image_url: image_url,
          ),
        )
      );

      },
      child: Container(
        width: 327,
        height: 144,
        decoration: BoxDecoration(
          // color: Colors.red,
          gradient: const LinearGradient(
            colors: [Color(0xFF2B1B4D), Color(0xFF1A1C33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Date',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        width: 30,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Color(0xFF121212),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 13,
                      top: 15,
                      bottom: 15,
                      child: DottedLine(
                        lineLength: 100,
                        // dashLength: 9,
                        // dashColor: Color(0Xff272835),
                        dashColor: Colors.white,
                        direction: Axis.vertical,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 15,
                        decoration: BoxDecoration(
                          color:Color(0xFF121212),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '#$ticketNumber',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Custom_Widget_/ticketDetails.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ مضاف
import 'dart:async';

class Myticket extends StatefulWidget {
  const Myticket({super.key});
  @override
  State<Myticket> createState() => MyticketState();
}

class MyticketState extends State<Myticket> with RouteAware {
  bool isUpcoming = true;
  List<dynamic> tickets = [];
  bool isLoading = true;
  late StreamSubscription _ticketsSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToTickets();
  }

  @override
  void dispose() {
    _ticketsSubscription.cancel();
    super.dispose();
  }

  void _subscribeToTickets() {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      _ticketsSubscription = Supabase.instance.client
          .from('tickets')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('booking_date', ascending: false)
          .listen(
            (data) async {
              await _handleTicketsUpdate(data);
            },
            onError: (error) {
              print('Stream error: $error');
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          );
    } catch (e) {
      print('Error setting up stream: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleTicketsUpdate(List<dynamic> streamData) async {
    if (!mounted) return;

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final completeData = await Supabase.instance.client
          .from('tickets')
          .select('''
            id, 
            booking_date, 
            quantity, 
            event_id,
            events!inner(
              id,
              title,
              event_time,
              image_cover
            )
          ''')
          .eq('user_id', userId)
          .order('booking_date', ascending: false);

      final formattedData =
          completeData.map((ticket) {
            return {...ticket, 'event_id': ticket['events']};
          }).toList();

      if (mounted) {
        setState(() {
          tickets = formattedData;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error handling tickets update: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshTickets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final data = await Supabase.instance.client
          .from('tickets')
          .select('''
            id, 
            booking_date, 
            quantity, 
            event_id,
            events!inner(
              id,
              title,
              event_time,
              image_cover
            )
          ''')
          .eq('user_id', userId)
          .order('booking_date', ascending: false);

      final formattedData =
          data.map((ticket) {
            return {...ticket, 'event_id': ticket['events']};
          }).toList();

      setState(() {
        tickets = formattedData;
        isLoading = false;
      });
    } catch (e) {
      print('Error refreshing tickets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'My Ticket',
            style: TextStyle(
              color: textColor,
              fontSize: 21.sp, fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: textColor),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: textColor),
              onPressed: _refreshTickets,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshTickets,
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tickets.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Tickets',
                          style: TextStyle(color: textColor, fontSize: 20.sp),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: _refreshTickets,
                          child: Text(
                            'Refresh',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      final event = ticket['event_id'];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: TicketCard(
                          eventName: event['title'] ?? 'No title',
                          time: event['event_time'] ?? '',
                          date: 'null',
                          ticketNumber: ticket['id'].toString(),
                          image_url:
                              event['image_cover'] ?? 'assets/default.png',
                          quantity: ticket['quantity'].toString(),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String eventName;
  final String time;
  final String date;
  final String ticketNumber;
  final String image_url;
  final String quantity;

  const TicketCard({
    Key? key,
    required this.eventName,
    required this.time,
    required this.date,
    required this.ticketNumber,
    required this.image_url,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => Ticketdetails(
            name: eventName,
            time: time,
            id: ticketNumber,
            image_url: image_url,
            quantity: quantity,
          ),
        );
      },
      child: Container(
        width: 327.w,
        height: 144.h,
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
                      Color.fromARGB(255, 213, 209, 221),
                      Color.fromARGB(255, 156, 136, 191),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            color:
                                isDark ? Colors.grey.shade400 : Colors.black54,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        width: 30.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13.w,
                      top: 15.h,
                      bottom: 15.h,
                      child: DottedLine(
                        lineLength: 100.h,
                        dashColor: Colors.white,
                        direction: Axis.vertical,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 30.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity: $quantity',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '#$ticketNumber',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

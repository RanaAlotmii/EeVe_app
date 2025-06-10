import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Custom_Widget_/ticketDetails.dart';
import 'package:dotted_line/dotted_line.dart';

class Myticket extends StatefulWidget {
  const Myticket({super.key});
  @override
  State<Myticket> createState() => MyticketState();
}

class MyticketState extends State<Myticket> with RouteAware {
  bool isUpcoming = true;
  List<dynamic> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    fetchTickets(); 
  }

  Future<void> fetchTickets() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final data = await Supabase.instance.client
          .from('tickets')
          .select(
            'id, booking_date, quantity, event_id, event_id(title, event_time, image_cover)',
          )
          .eq('user_id', userId)
          .order('booking_date', ascending: false);
      
      setState(() {
        tickets = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching tickets: $e');
    }
  }

  Future<void> _refreshTickets() async {
    await fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          title: Text(
            'My Ticket',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF121212),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshTickets,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshTickets,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Tickets',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _refreshTickets,
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    final event = ticket['event_id'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TicketCard(
                        eventName: event['title'] ?? 'No title',
                        time: event['event_time'] ?? '',
                        date: 'null',
                        ticketNumber: ticket['id'].toString(),
                        image_url: event['image_cover'] ?? 'assets/default.png',
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ticketdetails(
              name: eventName,
              time: time,
              id: ticketNumber,
              image_url: image_url,
              quantity: quantity,
            ),
          ),
        );
      },
      child: Container(
        width: 327,
        height: 144,
        decoration: BoxDecoration(
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
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 4 ,
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
                          color: Color(0xFF121212),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity: $quantity',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '#$ticketNumber',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
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
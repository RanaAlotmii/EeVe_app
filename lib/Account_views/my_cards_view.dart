import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Custom_Widget_/credit_card_widget.dart';
import '../Custom_Widget_/Custom_button.dart';
import 'add_card_view.dart';

class MyCardsView extends StatefulWidget {
  const MyCardsView({super.key});

  @override
  State<MyCardsView> createState() => _MyCardsViewState();
}

class _MyCardsViewState extends State<MyCardsView> {
  List<Map<String, dynamic>> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('user_card')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    setState(() {
      cards = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  Future<void> deleteCard(int cardId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_card')
          .delete()
          .eq('id', cardId);

      fetchCards();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while deleting the card: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardBackground = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text('My Cards', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cards.isEmpty
                ? Center(
                    child: Text(
                      'No cards added yet.',
                      style: TextStyle(color: textColor),
                    ),
                  )
                : ListView.separated(
                    itemCount: cards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Dismissible(
                        key: Key(card['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                                title: Text(
                                  'Delete card',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete the card ${card['card_name'] ?? 'null'}?',
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'cancel',
                                      style: TextStyle(
                                        color: isDark ? Colors.white70 : Colors.black54,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          deleteCard(card['id']);
                        },
                        child: CustomCreditCard(
                          backgroundColor: cardBackground,
                          card_name: card['card_name'] ?? '',
                          card_number: card['card_number']?.toString().padLeft(16, '*') ?? '',
                          expiry_date: card['expiry_date']?.toString() ?? '',
                        ),
                      );
                    },
                  ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
        child: CustomButton(
          text: "Add New Card",
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCardView()),
            );
            fetchCards(); 
          },
        ),
      ),
    );
  }
}
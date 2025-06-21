import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eeve_app/Ai_views/ai_chat_results_view.dart';
import 'package:eeve_app/api/openai_service.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({super.key});

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Smart context tracking
  String? _currentMood;
  String? _budgetPreference;
  String? _timePreference;
  List<String> _previousEvents = [];
  Map<String, dynamic>? _lastMoodAnalysis;

  // Quick mood buttons state
  bool _showMoodButtons = false;
  final List<Map<String, dynamic>> _moodOptions = [
    {'label': '😌 Chill', 'mood': 'chill', 'color': Colors.blue},
    {'label': '🔥 Excited', 'mood': 'excited', 'color': Colors.orange},
    {'label': '👥 Social', 'mood': 'social', 'color': Colors.green},
    {'label': '🎨 Creative', 'mood': 'creative', 'color': Colors.purple},
    {'label': '🌟 Adventurous', 'mood': 'adventurous', 'color': Colors.red},
    {'label': '😰 Stressed', 'mood': 'stressed', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize EventsController if not already initialized
    try {
      Get.find<EventsController>();
    } catch (e) {
      Get.put(EventsController());
    }

    // Only add welcome message if messages list is empty
    if (_messages.isEmpty) {
      _addWelcomeMessage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good morning! ☀️ Ready to discover some amazing morning events in Riyadh?";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon! 🌤️ What's your vibe for today's events?";
    } else if (hour >= 17 && hour < 21) {
      return "Good evening! 🌅 Let's find something perfect for tonight!";
    } else {
      return "Good evening! 🌙 Looking for some late-night fun in Riyadh?";
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'role': 'ai',
        'content':
            '${_getTimeBasedGreeting()}\n\nI\'m EeVe, your intelligent event assistant! I can help you find perfect events based on your mood, budget, and preferences. What\'s your vibe today?',
      });
      _showMoodButtons = true;
    });
  }

  void _extractContextFromMessage(String message) {
    final lowerMessage = message.toLowerCase();

    // Extract budget info
    final budgetRegex = RegExp(r'(\d+)\s*(sr|riyal|sar)');
    final budgetMatch = budgetRegex.firstMatch(lowerMessage);
    if (budgetMatch != null) {
      _budgetPreference = budgetMatch.group(1);
    }

    // Extract time preferences
    final timeKeywords = {
      'morning': ['morning', 'breakfast', 'am'],
      'afternoon': ['afternoon', 'lunch', 'pm'],
      'evening': ['evening', 'dinner', 'sunset'],
      'night': ['night', 'late', 'midnight'],
      'weekend': ['weekend', 'friday', 'saturday'],
    };

    timeKeywords.forEach((time, keywords) {
      if (keywords.any((keyword) => lowerMessage.contains(keyword))) {
        _timePreference = time;
      }
    });
  }

  Future<void> _handleSend(String inputText, {String? selectedMood}) async {
    if (inputText.trim().isEmpty && selectedMood == null) return;

    final messageText =
        selectedMood != null
            ? "I'm feeling ${selectedMood.toLowerCase()}"
            : inputText.trim();

    setState(() {
      _messages.add({'role': 'user', 'content': messageText});
      _isLoading = true;
      _showMoodButtons = false;
    });

    _controller.clear();

    try {
      // First, analyze the mood if we don't have recent analysis
      if (_lastMoodAnalysis == null || selectedMood != null) {
        final moodAnalysis = await analyzeUserMood(messageText);
        _lastMoodAnalysis = moodAnalysis;

        // Update context based on mood analysis
        if (selectedMood != null) {
          _currentMood = selectedMood;
        }
      }

      // Get AI response with enhanced context
      final aiReply = await getEventSuggestionsFromAI(
        messageText,
        currentMood: _currentMood,
        budget: _budgetPreference,
        location: 'Riyadh', 
        timePreference: _timePreference,
        previousEvents: _previousEvents,
      );

      // Extract any context updates from the conversation
      _extractContextFromMessage(messageText);

      setState(() {
        _messages.add({'role': 'ai', 'content': aiReply});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'content':
              'Sorry, I encountered an issue. Let me try to help you another way! 😊',
        });
        _isLoading = false;
      });
    }

    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  bool _replyHasShowEventsMarker(String reply) {
    return reply.contains('[SHOW_EVENTS]');
  }

  Widget _buildMoodButton(Map<String, dynamic> mood) {
    return GestureDetector(
      onTap: () => _handleSend('', selectedMood: mood['mood']),
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: mood['color'].withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mood['color'].withOpacity(0.5)),
        ),
        child: Text(
          mood['label'],
          style: TextStyle(
            color: mood['color'],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContextChips() {
    if (_currentMood == null && _budgetPreference == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          if (_currentMood != null)
            _buildContextChip('Mood: $_currentMood', Colors.purple, () {
              setState(() => _currentMood = null);
            }),
          if (_budgetPreference != null)
            _buildContextChip(
              'Budget: $_budgetPreference SR',
              Colors.green,
              () {
                setState(() => _budgetPreference = null);
              },
            ),
          if (_timePreference != null)
            _buildContextChip('Time: $_timePreference', Colors.orange, () {
              setState(() => _timePreference = null);
            }),
        ],
      ),
    );
  }

  Widget _buildContextChip(String label, Color color, VoidCallback onClear) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 14, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0E131C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Hi, I'm EeVe.",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            "Your intelligent event assistant for Riyadh 🇸🇦",
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                _buildContextChips(),

                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_showMoodButtons ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_showMoodButtons && index == _messages.length) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quick mood selection:",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                children:
                                    _moodOptions.map(_buildMoodButton).toList(),
                              ),
                            ],
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message['role'] == 'user';
                      final content = message['content']!;
                      final hasMarker = _replyHasShowEventsMarker(content);

                      if (isUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7D39EB), Color(0xFF9B59FF)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7D39EB,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              content,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else if (hasMarker) {
                        final parts = content.split('[SHOW_EVENTS]');
                        final replyText = parts[0].trim();
                        final eventTitles =
                            parts.length > 1 ? parts[1].trim() : '';

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: textColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: textColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  replyText,
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              if (eventTitles.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    // Add to previous events for context
                                    final events =
                                        eventTitles
                                            .split('|')
                                            .map((e) => e.trim())
                                            .toList();
                                    _previousEvents.addAll(events);

                                    await PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: AiChatResultsView(
                                        aiReply: eventTitles,
                                      ),
                                      withNavBar: false,
                                    );
                                    // Ensure we rebuild to maintain state
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.purpleAccent,
                                          Colors.purple,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '✨ Show me these events!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: textColor.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              content,
                              style: TextStyle(
                                color: textColor.withOpacity(0.9),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMoodButtons = !_showMoodButtons;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: textColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: textColor.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.mood,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: textColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: textColor.withOpacity(0.2),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextField(
                                controller: _controller,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText:
                                      'Tell me your mood or what you want...',
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.5),
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (text) => _handleSend(text),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap:
                            _isLoading
                                ? null
                                : () => _handleSend(_controller.text.trim()),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7D39EB), Color(0xFF9B59FF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7D39EB).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child:
                              _isLoading
                                  ? const Center(
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eeve_app/Ai_views/ai_chat_results_view.dart';
import 'package:eeve_app/api/openai_service.dart';
import 'package:eeve_app/Custom_Widget_/suggestion_card.dart';
import 'package:blur/blur.dart';
import 'dart:ui';

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({super.key});

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSend(String inputText) async {
    if (inputText.trim().isEmpty) return;
    setState(() => _isLoading = true);
    final aiReply = await getEventSuggestionsFromAI(inputText);
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiChatResultsView(aiReply: aiReply),
      ),
    );
  }

  Future<void> _handleSuggestionTap(String tagPrompt) async {
    setState(() => _isLoading = true);
    final aiReply = await getEventsByTagFromAI(tagPrompt);
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiChatResultsView(aiReply: aiReply),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E131C),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3D1E70),
                      Color(0xFF100D1E),
                      Color(0xFF01010C),
                      Color(0xFF0E131C),
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.auto_awesome, size: 40, color: Colors.white70),
                const SizedBox(height: 12),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFC9C2D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    "Hi, I’m EeVe.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("How can I help you today?", style: TextStyle(color: Colors.white60)),
                const Spacer(),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      SuggestionCard(
                        title: "Weekend Picks",
                        subtitle: "What's happening?",
                        iconPath: "assets/weekend.png",
                        onTap: () => _handleSuggestionTap("weekend events"),
                      ),
                      SuggestionCard(
                        title: "Budget-Friendly",
                        subtitle: "Under 100 SAR",
                        iconPath: "assets/budgeticon.png",
                        onTap: () => _handleSuggestionTap("budget friendly events"),
                      ),
                      SuggestionCard(
                        title: "Smart Random Pick",
                        subtitle: "Surprise me!",
                        iconPath: "assets/randomicon.png",
                        onTap: () => _handleSuggestionTap("random event"),
                      ),
                      SuggestionCard(
                        title: "Trending Now",
                        subtitle: "Hot picks!",
                        iconPath: "assets/trendingicon.png",
                        onTap: () => _handleSuggestionTap("trending events"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Message EeVe...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _isLoading ? null : () => _handleSend(_controller.text.trim()),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7D39EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _isLoading
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


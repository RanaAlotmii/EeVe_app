import 'package:eeve_app/Custom_Widget_/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:eeve_app/Ai_views/ai_chat_results_view.dart';
import 'package:eeve_app/api/openai_service.dart';
import 'package:eeve_app/Custom_Widget_/suggestion_card.dart';
import 'package:blur/blur.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0E131C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.black54;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8A2BE2),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Icon(Icons.auto_awesome, size: 40.sp, color: subtitleColor),
                  SizedBox(height: 12.h),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isDark
                          ? [Colors.white, const Color(0xFFC9C2D8)]
                          : [Colors.black87, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      "Hi, I’m EeVe.",
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text("How can I help you today?",
                      style: TextStyle(color: subtitleColor, fontSize: 14.sp)),
                  const Spacer(),
                  SizedBox(
                    height: 120.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Message EeVe...',
                            controller: _controller,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: _isLoading ? null : () => _handleSend(_controller.text.trim()),
                          child: Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7D39EB),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: _isLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 18.h,
                                      width: 18.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : Icon(Icons.send, color: Colors.white, size: 22.sp),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

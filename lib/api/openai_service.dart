import 'package:dart_openai/dart_openai.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:get/get.dart';

/// Enhanced AI service for EeVe event recommendations
Future<String> getEventSuggestionsFromAI(
  String userInput, {
  String? currentMood,
  String? budget,
  String? location,
  String? timePreference,
  List<String>? previousEvents,
}) async {
  try {
    final controller = Get.find<EventsController>();
    final events = controller.getFilteredEvents();

    // Enhanced event formatting with more context
    final formattedEvents = events
        .map((event) {
          return '''
Event: ${event["title"]}
Location: ${event["location"]}
Price: ${event["price"]} SR
Category: ${event["category"] ?? "General"}
Date: ${event["date"] ?? "TBD"}
Time: ${event["time"] ?? "TBD"}
Description: ${event["description"] ?? "No description available"}
---''';
        })
        .join('\n');

    // Context building
    String contextInfo = "";
    if (currentMood != null) contextInfo += "Current mood: $currentMood\n";
    if (budget != null) contextInfo += "Budget preference: $budget SR\n";
    if (location != null) contextInfo += "Preferred location: $location\n";
    if (timePreference != null)
      contextInfo += "Time preference: $timePreference\n";
    if (previousEvents != null && previousEvents.isNotEmpty) {
      contextInfo += "Previously attended: ${previousEvents.join(', ')}\n";
    }

    final prompt = """
You are EeVe, an intelligent AI event concierge for Saudi Arabia. You understand mood, personality, and cultural context to make perfect event recommendations.

PERSONALITY & TONE:
- Warm, enthusiastic, and culturally aware
- Use Saudi cultural references naturally
- Be conversational but professional
- Show genuine excitement about events

USER CONTEXT:
$contextInfo

USER MESSAGE: "$userInput"

AVAILABLE EVENTS:
$formattedEvents

RESPONSE GUIDELINES:

1. GREETING/CASUAL CHAT:
   If user says hi/hello/casual talk, respond warmly and ask about their mood or what they're looking for.

2. CAPABILITY QUESTIONS:
   Explain you help find events based on mood, budget, location, and preferences in Saudi Arabia.

3. EVENT RECOMMENDATIONS:
   When user asks for events OR expresses any mood/preference, you MUST:
   
   a) MOOD ANALYSIS: Analyze their mood/energy level from their message
   - Chill/relaxed → cafés, art galleries, quiet venues
   - Excited/energetic → concerts, festivals, sports events
   - Social → group activities, networking events
   - Creative → workshops, cultural events
   - Adventurous → outdoor activities, new experiences
   
   b) BUDGET CONSIDERATION: Factor in their budget constraints
   - Under 50 SR: free/cheap events
   - 50-200 SR: mid-range options
   - 200+ SR: premium experiences
   
   c) CULTURAL CONTEXT: Consider Saudi preferences and timing
   - Family-friendly options
   - Appropriate timing (not during prayer times if known)
   - Gender-appropriate venues when relevant
   
   d) PERSONALIZATION: Reference their specific words/preferences
   
   e) RESPONSE FORMAT - THIS IS CRITICAL:
   - Start with understanding their vibe (1-2 sentences max)
   - IMMEDIATELY add [SHOW_EVENTS] on a new line
   - List ONLY event titles separated by | like: Event Title | Event Title | Event Title
   - NEVER list events with numbers, descriptions, or prices in the response
   - Keep the response before [SHOW_EVENTS] very short
   
   IMPORTANT: ALWAYS include [SHOW_EVENTS] and event recommendations unless the user is just greeting or asking what you can do.

4. NO MATCHES:
   If no events match their criteria, say: "I don't have perfect matches right now, but let me show you some similar options!"
   Then STILL include [SHOW_EVENTS] with the closest available events.

5. FOLLOW-UP:
   Only ask follow-up questions if the user explicitly asks for more help AFTER seeing events.

EXAMPLES - FOLLOW THESE EXACTLY:

User: "I'm feeling really stressed from work, need something chill"
Response: "I totally get that work stress! You need something peaceful to recharge.
[SHOW_EVENTS]
Quiet Coffee Corner | Art Gallery Opening | Meditation Workshop | Jazz Lounge Evening"

User: "Want something fun with friends this weekend, budget around 100 SR"
Response: "Weekend fun with friends sounds perfect! Here are some great group activities within your budget.
[SHOW_EVENTS]  
Bowling Night | Food Truck Festival | Mini Golf Tournament | Board Game Café"

CRITICAL RULES:
- NEVER include event details, prices, or descriptions in your response
- ALWAYS use [SHOW_EVENTS] format when user expresses any mood, preference, or asks for events
- Keep text before [SHOW_EVENTS] to 1-2 sentences maximum
- Only list event TITLES separated by |
- NEVER respond with just supportive text - ALWAYS show events unless it's a greeting
- If user says "I'm feeling [mood]" - ALWAYS show events for that mood

Remember: Your job is to show events, not just chat! Always include [SHOW_EVENTS] and event recommendations!

Remember: Be specific, be cultural, be personal, and always match their energy level!
""";

    final chat = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are EeVe, an intelligent AI event concierge for Saudi Arabia. You excel at understanding mood, cultural context, and personal preferences to make perfect event recommendations.",
            ),
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
          ],
        ),
      ],
      maxTokens: 500, 
      temperature: 0.7, 
    );

    final reply = chat.choices.first.message.content?.first.text;
    return reply ?? "Sorry, I couldn't generate a response.";
  } catch (e) {
    return "Something went wrong: $e";
  }
}

/// Enhanced mood detection function
Future<Map<String, dynamic>> analyzeUserMood(String userInput) async {
  try {
    final moodPrompt = """
Analyze this user message for mood and preferences: "$userInput"

Return ONLY a valid JSON object with these exact keys:
{
  "mood": "excited|chill|social|creative|adventurous|stressed|romantic|cultural",
  "energy_level": "high|medium|low",
  "social_preference": "alone|small_group|large_group|any",
  "budget_indication": "low|medium|high|not_specified",
  "time_preference": "morning|afternoon|evening|night|weekend|any",
  "keywords": ["keyword1", "keyword2"],
  "confidence": 0.8
}
""";

    final chat = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(moodPrompt),
          ],
        ),
      ],
      maxTokens: 200,
      temperature: 0.3, 
    );

    final reply = chat.choices.first.message.content?.first.text ?? "{}";
    return {"raw_analysis": reply};
  } catch (e) {
    return {"error": e.toString()};
  }
}

/// Smart event filtering based on mood analysis
List<Map<String, dynamic>> filterEventsByMood(
  List<Map<String, dynamic>> events,
  Map<String, dynamic> moodAnalysis,
) {
  // Implement intelligent filtering logic based on mood analysis
  // This is where you'd apply the mood-to-event category mapping
  return events; // Placeholder - implement your filtering logic
}

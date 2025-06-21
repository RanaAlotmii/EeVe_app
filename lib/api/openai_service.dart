import 'package:dart_openai/dart_openai.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:get/get.dart';

Future<String> getEventSuggestionsFromAI(
  String userInput, {
  String? currentMood,
  String? budget,
  String? location,
  String? timePreference,
  List<String>? previousEvents,
}) async {
  try {
    List<Map<String, dynamic>> events = [];
    try {
      final controller = Get.find<EventsController>();
      events = controller.getFilteredEvents();
    } catch (e) {
      events = [
        {
          "title": "Coffee & Art Workshop",
          "location": "Riyadh Gallery",
          "price": "45",
          "category": "Creative",
        },
        {
          "title": "Evening Food Market",
          "location": "King Fahd Road",
          "price": "25",
          "category": "Food",
        },
        {
          "title": "Live Jazz Music",
          "location": "Diplomatic Quarter",
          "price": "85",
          "category": "Music",
        },
        {
          "title": "Pottery Class",
          "location": "Al Malaz",
          "price": "120",
          "category": "Creative",
        },
        {
          "title": "Outdoor Cinema",
          "location": "King Abdullah Park",
          "price": "35",
          "category": "Entertainment",
        },
      ];
      print("Using fallback events due to controller issue: $e");
    }

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
      maxTokens: 500, // Increased for more detailed responses
      temperature: 0.7, // Slightly lower for more consistent quality
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
  if (moodAnalysis.isEmpty || !moodAnalysis.containsKey("raw_analysis")) {
    return events;
  }

  try {
    final rawAnalysis = moodAnalysis["raw_analysis"].toString().toLowerCase();
    String detectedMood = "any";

    if (rawAnalysis.contains('"mood"')) {
      if (rawAnalysis.contains('chill') || rawAnalysis.contains('relaxed')) {
        detectedMood = "chill";
      } else if (rawAnalysis.contains('excited') ||
          rawAnalysis.contains('energetic')) {
        detectedMood = "excited";
      } else if (rawAnalysis.contains('social')) {
        detectedMood = "social";
      } else if (rawAnalysis.contains('creative')) {
        detectedMood = "creative";
      } else if (rawAnalysis.contains('adventurous')) {
        detectedMood = "adventurous";
      } else if (rawAnalysis.contains('stressed')) {
        detectedMood = "stressed";
      } else if (rawAnalysis.contains('romantic')) {
        detectedMood = "romantic";
      } else if (rawAnalysis.contains('cultural')) {
        detectedMood = "cultural";
      }
    }

    // Filter events based on detected mood
    List<Map<String, dynamic>> filteredEvents = [];

    for (var event in events) {
      final title = event["title"]?.toString().toLowerCase() ?? "";
      final category = event["category"]?.toString().toLowerCase() ?? "";
      final description = event["description"]?.toString().toLowerCase() ?? "";
      final price = double.tryParse(event["price"]?.toString() ?? "0") ?? 0;

      bool shouldInclude = false;

      switch (detectedMood) {
        case "chill":
        case "stressed":
          // Calm, relaxing activities
          shouldInclude =
              title.contains("coffee") ||
              title.contains("café") ||
              title.contains("art") ||
              title.contains("gallery") ||
              title.contains("meditation") ||
              title.contains("spa") ||
              title.contains("quiet") ||
              title.contains("reading") ||
              title.contains("yoga") ||
              category.contains("cafe") ||
              category.contains("art") ||
              category.contains("wellness") ||
              category.contains("relaxation") ||
              description.contains("peaceful") ||
              description.contains("calm") ||
              description.contains("relaxing");
          break;

        case "excited":
          // High-energy, fun activities
          shouldInclude =
              title.contains("concert") ||
              title.contains("festival") ||
              title.contains("party") ||
              title.contains("dance") ||
              title.contains("club") ||
              title.contains("live") ||
              title.contains("music") ||
              title.contains("sports") ||
              title.contains("game") ||
              category.contains("music") ||
              category.contains("entertainment") ||
              category.contains("sports") ||
              category.contains("nightlife") ||
              description.contains("energetic") ||
              description.contains("exciting") ||
              description.contains("fun");
          break;

        case "social":
          // Group activities and networking
          shouldInclude =
              title.contains("networking") ||
              title.contains("meetup") ||
              title.contains("group") ||
              title.contains("community") ||
              title.contains("social") ||
              title.contains("gathering") ||
              title.contains("party") ||
              title.contains("festival") ||
              category.contains("social") ||
              category.contains("networking") ||
              category.contains("community") ||
              description.contains("meet") ||
              description.contains("social") ||
              description.contains("group");
          break;

        case "creative":
          // Arts, crafts, workshops
          shouldInclude =
              title.contains("workshop") ||
              title.contains("art") ||
              title.contains("craft") ||
              title.contains("creative") ||
              title.contains("painting") ||
              title.contains("pottery") ||
              title.contains("design") ||
              title.contains("photography") ||
              title.contains("writing") ||
              category.contains("art") ||
              category.contains("creative") ||
              category.contains("workshop") ||
              description.contains("creative") ||
              description.contains("artistic") ||
              description.contains("craft");
          break;

        case "adventurous":
          // Outdoor and adventure activities
          shouldInclude =
              title.contains("outdoor") ||
              title.contains("adventure") ||
              title.contains("hiking") ||
              title.contains("exploration") ||
              title.contains("discovery") ||
              title.contains("new") ||
              title.contains("experience") ||
              title.contains("unique") ||
              category.contains("outdoor") ||
              category.contains("adventure") ||
              category.contains("sports") ||
              description.contains("adventure") ||
              description.contains("explore") ||
              description.contains("discover");
          break;

        case "romantic":
          // Romantic, intimate activities
          shouldInclude =
              title.contains("romantic") ||
              title.contains("dinner") ||
              title.contains("intimate") ||
              title.contains("couple") ||
              title.contains("sunset") ||
              title.contains("candlelight") ||
              title.contains("wine") ||
              category.contains("dining") ||
              category.contains("romantic") ||
              description.contains("romantic") ||
              description.contains("intimate") ||
              description.contains("couple") ||
              (price > 100);
          break;

        case "cultural":
          // Cultural and educational activities
          shouldInclude =
              title.contains("museum") ||
              title.contains("cultural") ||
              title.contains("heritage") ||
              title.contains("traditional") ||
              title.contains("history") ||
              title.contains("exhibition") ||
              title.contains("saudi") ||
              title.contains("arabic") ||
              category.contains("cultural") ||
              category.contains("museum") ||
              category.contains("heritage") ||
              description.contains("cultural") ||
              description.contains("traditional") ||
              description.contains("heritage");
          break;

        default:
          shouldInclude = true; // Include all if mood not recognized
      }

      if (shouldInclude) {
        filteredEvents.add(event);
      }
    }

    // If no events match the mood, return some general popular events
    if (filteredEvents.isEmpty) {
      // Return first 5 events as fallback
      return events.take(5).toList();
    }

    // Limit to maximum 5 events
    return filteredEvents.take(5).toList();
  } catch (e) {
    // If filtering fails, return all events
    print("Error in mood filtering: $e");
    return events;
  }
}

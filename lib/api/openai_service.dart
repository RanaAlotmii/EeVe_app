import 'package:dart_openai/dart_openai.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:get/get.dart';

Future<String> getEventSuggestionsFromAI(String userInput) async {
  try {
    // 1. Access events from Supabase
    final controller = Get.find<EventsController>();
    final events = controller.getFilteredEvents();

    // 2. Format events into a readable list for the AI
    final formattedEvents = events.map((event) {
      return '${event["title"]} in ${event["location"]} - ${event["price"]} SR';
    }).join('\n');

    // 3. Compose the prompt to get multiple suggestions
    final prompt = '''
User is looking for this: "$userInput"

Here is a list of available real events:
$formattedEvents

Pick the top 4 or 5 events that match the user’s vibe and ONLY reply with their exact titles, separated by this symbol: |

Example format: Title 1 | Title 2 | Title 3 | Title 4 | Title 5
''';

    // 4. Request OpenAI
    final chat = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
          ],
        ),
      ],
      maxTokens: 150,
      temperature: 0.75,
    );

    // 5. Return response text
    final reply = chat.choices.first.message.content?.first.text;
    return reply ?? "Sorry, I couldn't find any matches.";
  } catch (e) {
    return "Something went wrong: $e";
  }
}

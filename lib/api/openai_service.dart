import 'package:dart_openai/dart_openai.dart';
import 'package:eeve_app/controllers/events_controller.dart';
import 'package:get/get.dart';

/// Free-form user input (chat)
Future<String> getEventSuggestionsFromAI(String userInput) async {
  try {
    final controller = Get.find<EventsController>();
    final events = controller.getFilteredEvents();

    final formattedEvents = events.map((event) {
      return '${event["title"]} in ${event["location"]} - ${event["price"]} SR';
    }).join('\n');

    final prompt = '''
User is looking for this: "$userInput"

Here is a list of available real events:
$formattedEvents

Pick the top 4 or 5 events that match the user’s vibe and ONLY reply with their exact titles, separated by this symbol: |

Example format: Title 1 | Title 2 | Title 3 | Title 4 | Title 5
''';

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

    final reply = chat.choices.first.message.content?.first.text;
    return reply ?? "Sorry, I couldn't find any matches.";
  } catch (e) {
    return "Something went wrong: $e";
  }
}

/// Tag-based suggestions (for SuggestionView)
Future<String> getEventsByTagFromAI(String tagKeyword) async {
  try {
    final controller = Get.find<EventsController>();
    final events = controller.getFilteredEvents();

    final formattedEvents = events.map((event) {
      return '${event["title"]} in ${event["location"]} - ${event["price"]} SR';
    }).join('\n');

    final prompt = '''
User is asking for: "$tagKeyword"

Here’s a list of available real events:
$formattedEvents

Based on the keyword, select the best 4 or 5 matching events and ONLY return their titles separated by |.

Example: Event A | Event B | Event C | Event D | Event E
''';

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
      temperature: 0.7,
    );

    final reply = chat.choices.first.message.content?.first.text;
    return reply ?? "Sorry, couldn’t get suggestions.";
  } catch (e) {
    return "Error: $e";
  }
}

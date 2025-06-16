import 'package:get/get.dart';

class AiOnboardingController extends GetxController {
  var selectedInterests = <String>{}.obs;
  var selectedVibe = ''.obs;
  var selectedTime = ''.obs;

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void setVibe(String vibe) {
    selectedVibe.value = vibe;
  }

  void setTime(String time) {
    selectedTime.value = time;
  }

  void printSelections() {
    print("✅ Interests: $selectedInterests");
    print("✅ Vibe: ${selectedVibe.value}");
    print("✅ Time: ${selectedTime.value}");
  }
}
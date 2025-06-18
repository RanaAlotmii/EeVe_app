import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  var profileImage = ''.obs;   //image 1

  final _supabase = Supabase.instance.client;

  void loadProfileImage() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final response = await _supabase
          .from('users')
          .select('profile_image')
          .eq('id', user.id)
          .maybeSingle();
      if (response != null) {
        profileImage.value = response['profile_image'] ?? '';
      }
    }
  }

  String updateProfileImage(String newImageUrl) {
    profileImage.value = newImageUrl;

    return profileImage.value;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class LoginStorageService {
  static const _savedIdKey = 'saved_login_id';

  Future<String?> getSavedLoginId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_savedIdKey);
    if (savedId == null || savedId.isEmpty) {
      return null;
    }
    return savedId;
  }

  Future<void> persistLoginId({
    required bool rememberId,
    required String loginId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberId) {
      await prefs.setString(_savedIdKey, loginId.trim());
      return;
    }
    await prefs.remove(_savedIdKey);
  }
}

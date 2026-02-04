import 'package:shared_preferences/shared_preferences.dart';

class TasbeehProgressService {
  static String _key(String category, int zekrId) {
    return '${category}_zekr_${zekrId}_progress';
  }

  static Future<int> getProgress(String category, int zekrId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(category, zekrId)) ?? 0;
  }

  static Future<void> saveProgress(
    String category,
    int zekrId,
    int value,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key(category, zekrId), value);
  }

  static Future<void> resetProgress(
    String category,
    int zekrId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(category, zekrId));
  }
}
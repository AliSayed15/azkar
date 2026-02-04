import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tasbeeh_app/features/azkar/models/detailed_zekr_model.dart';
class AzkarService {
  static Map<String, List<DetailedZekr>>? _cachedAzkar;

  // تحميل الأذكار من JSON
  static Future<List<DetailedZekr>> getAzkarByCategory(String category) async {
    // لو الداتا موجودة في الكاش، ارجعها
    if (_cachedAzkar != null && _cachedAzkar!.containsKey(category)) {
      return _cachedAzkar![category]!;
    }

    // تحميل الملف من assets
    final String jsonString = await rootBundle.loadString('assets/data/azkar_detailed.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    // حفظ كل الأذكار في الكاش
    _cachedAzkar = {};
    jsonData.forEach((key, value) {
      _cachedAzkar![key] = (value as List)
          .map((item) => DetailedZekr.fromJson(item))
          .toList();
    });

    return _cachedAzkar![category] ?? [];
  }

  // حفظ التقدم لذكر معين
  static Future<void> saveProgress(String category, int zekrId, int currentCount) async {
    final box = Hive.box('tasbeehBox');
    final key = '${category}_zekr_${zekrId}_progress';
    await box.put(key, currentCount);

    // حفظ في إحصائيات اليوم
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final dailyKey = '${today}_${category}_total';
    int dailyTotal = box.get(dailyKey, defaultValue: 0);
    await box.put(dailyKey, dailyTotal + 1);
  }

  // جلب التقدم لذكر معين
  static int getProgress(String category, int zekrId) {
    final box = Hive.box('tasbeehBox');
    final key = '${category}_zekr_${zekrId}_progress';
    return box.get(key, defaultValue: 0);
  }

  // إعادة تعيين التقدم لذكر معين
  static Future<void> resetProgress(String category, int zekrId) async {
    final box = Hive.box('tasbeehBox');
    final key = '${category}_zekr_${zekrId}_progress';
    await box.put(key, 0);
  }

  // إعادة تعيين كل أذكار قسم معين
  static Future<void> resetCategoryProgress(String category) async {
    final azkar = await getAzkarByCategory(category);
    final box = Hive.box('tasbeehBox');
    
    for (var zekr in azkar) {
      final key = '${category}_zekr_${zekr.id}_progress';
      await box.put(key, 0);
    }
  }

  // حساب التقدم الكلي لقسم معين
  static Future<Map<String, int>> getCategoryProgress(String category) async {
    final azkar = await getAzkarByCategory(category);
    int totalRequired = 0;
    int totalCompleted = 0;

    for (var zekr in azkar) {
      totalRequired += zekr.count;
      int completed = getProgress(category, zekr.id);
      totalCompleted += completed > zekr.count ? zekr.count : completed;
    }

    return {
      'total': totalRequired,
      'completed': totalCompleted,
      'percentage': totalRequired > 0 ? ((totalCompleted / totalRequired) * 100).round() : 0,
    };
  }

  // التحقق إذا كان الذكر مكتمل
  static bool isZekrCompleted(String category, int zekrId, int targetCount) {
    return getProgress(category, zekrId) >= targetCount;
  }
}
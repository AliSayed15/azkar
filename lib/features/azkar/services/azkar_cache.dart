import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/zekr_model.dart';

class AzkarCache {
  static const String _boxName = 'azkar_cache';
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static Future<void> saveAzkar(String category, List<ZekrItem> azkar) async {
    if (_box == null) return;

    final jsonList = azkar.map((item) => item.toJson()).toList();
    await _box!.put(category, jsonEncode(jsonList));
    print('✅ تم حفظ $category في الـ cache');
  }

  static List<ZekrItem>? getAzkar(String category) {
    if (_box == null) return null;

    final String? jsonString = _box!.get(category);
    if (jsonString == null) {
      print('❌ لا توجد بيانات محفوظة لـ $category');
      return null;
    }

    try {
      final List jsonList = jsonDecode(jsonString);
      print('✅ تم جلب $category من الـ cache');
      return jsonList.map((item) => ZekrItem.fromJson(item)).toList();
    } catch (e) {
      print('❌ خطأ في قراءة الـ cache: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    if (_box == null) return;
    await _box!.clear();
  }
}
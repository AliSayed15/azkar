import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/zekr_model.dart';

class AzkarApi {
  static const String url =
      'https://raw.githubusercontent.com/nawafalqari/azkar-api/56df51279ab6eb86dc2f6202c7de26c8948331c1/azkar.json';

  Future<List<ZekrItem>> fetchAzkar(String category) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('فشل تحميل الأذكار');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data[category] ?? [];

      return list
          .where((e) => e['count'] != 'stop')
          .map<ZekrItem>((e) => ZekrItem.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ خطأ في API: $e');
      rethrow;
    }
  }
}
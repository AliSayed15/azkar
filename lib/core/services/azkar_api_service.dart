import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/azkar_section.dart';

class AzkarApiService {
  static const String url =
      'https://raw.githubusercontent.com/nawafalqari/azkar-api/56df51279ab6eb86dc2f6202c7de26c8948331c1/azkar.json';

  static Future<List<AzkarSection>> fetchAllSections() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList
          .map((item) => AzkarSection.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load azkar JSON');
    }
  }
}
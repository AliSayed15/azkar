import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  Future<List<dynamic>> loadAzkar() async {
    final data = await rootBundle.loadString('assets/data/azkar.json');
    return json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Azkar')),
      body: FutureBuilder(
        future: loadAzkar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final azkar = snapshot.data as List;

          return ListView.builder(
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(azkar[index]['text']),
                trailing: Text('x${azkar[index]['count']}'),
              );
            },
          );
        },
      ),
    );
  }
}
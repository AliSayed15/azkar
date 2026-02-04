import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('tasbeehBox');
    final keys = box.keys.where((k) => k.toString().contains('-')).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(keys[index].toString()),
            trailing: Text(box.get(keys[index]).toString()),
          );
        },
      ),
    );
  }
}
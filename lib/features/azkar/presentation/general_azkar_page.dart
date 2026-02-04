import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../../data/adhkar_data.dart';
import '../../../models/dhikr.dart';
import '../../../core/services/tasbeeh_progress_service.dart';

class GeneralAzkarPage extends StatefulWidget {
  const GeneralAzkarPage({super.key});

  @override
  State<GeneralAzkarPage> createState() => _GeneralAzkarPageState();
}

class _GeneralAzkarPageState extends State<GeneralAzkarPage> {
  final Map<String, int> counters = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  Future<void> _loadCounters() async {
    for (final dhikr in generalAdhkar) {
      final value = await TasbeehProgressService.getProgress(
        'general',
        dhikr.key,
      );
      counters[dhikr.id] = value;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _increment(Dhikr dhikr) async {
    final current = counters[dhikr.id] ?? 0;

    if (current >= dhikr.targetCount) return;

    final newValue = current + 1;

    await TasbeehProgressService.saveProgress(
      'general',
      dhikr.id,
      newValue,
    );

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30);
    }

    setState(() {
      counters[dhikr.id] = newValue;
    });

    if (newValue == dhikr.targetCount && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Great job! You completed ${dhikr.title}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _reset(String dhikrId) async {
    await TasbeehProgressService.saveProgress(
      'general',
      dhikrId,
      0,
    );

    setState(() {
      counters[dhikrId] = 0;
    });
  }

  Future<void> _resetAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Reset all counters?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (final dhikr in generalAdhkar) {
        await TasbeehProgressService.saveProgress(
          'general',
          dhikr.id,
          0,
        );
        counters[dhikr.id] = 0;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('General Azkar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAll,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: generalAdhkar.length,
        itemBuilder: (context, index) {
          final dhikr = generalAdhkar[index];
          final count = counters[dhikr.id] ?? 0;
          final progress = count / dhikr.targetCount;
          final isCompleted = count >= dhikr.targetCount;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dhikr.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dhikr.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text('$count / ${dhikr.targetCount}'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isCompleted ? null : () => _increment(dhikr),
                          child: Text(isCompleted ? 'Completed' : 'Tasbeeh'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => _reset(dhikr.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

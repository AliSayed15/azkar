import 'package:flutter/material.dart';

import '../../core/services/tasbeeh_progress_service.dart';
import '../../data/adhkar_data.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isLoading = true;

  final List<_StatItem> stats = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    stats.clear();

    for (final dhikr in generalAdhkar) {
      final value = await TasbeehProgressService.getProgress(
        'general',
        dhikr.id,
      );

      if (value > 0) {
        stats.add(
          _StatItem(
            title: dhikr.title,
            count: value,
            target: dhikr.targetCount,
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stats.isEmpty
              ? const Center(
                  child: Text(
                    'No statistics yet',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final item = stats[index];
                    final progress =
                        (item.count / item.target).clamp(0.0, 1.0);

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
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                            ),
                            const SizedBox(height: 8),
                            Text('${item.count} / ${item.target}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _StatItem {
  final String title;
  final int count;
  final int target;

  _StatItem({
    required this.title,
    required this.count,
    required this.target,
  });
}

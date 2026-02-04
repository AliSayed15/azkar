import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'package:tasbeeh_app/features/azkar/models/detailed_zekr_model.dart';
import '../../../core/services/azkar_service.dart';
import '../../../core/services/tasbeeh_progress_service.dart';

class CategoryAzkarPage extends StatefulWidget {
  final String category;
  final String title;
  final IconData icon;
  final Color color;

  const CategoryAzkarPage({
    super.key,
    required this.category,
    required this.title,
    required this.icon,
    this.color = Colors.green,
  });

  @override
  State<CategoryAzkarPage> createState() => _CategoryAzkarPageState();
}

class _CategoryAzkarPageState extends State<CategoryAzkarPage> {
  List<DetailedZekr> azkar = [];
  Map<int, int> progress = {};
  bool isLoading = true;
  int totalProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadAzkar();
  }

  Future<void> _loadAzkar() async {
    try {
      final data = await AzkarService.getAzkarByCategory(widget.category);
      azkar = data;

      // load progress for each zekr
      for (final zekr in azkar) {
        progress[zekr.id] = await TasbeehProgressService.getProgress(
          widget.category,
          zekr.id,
        );
      }

      isLoading = false;
      _calculateTotalProgress();
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading azkar: $e')),
        );
      }
    }
  }

  void _calculateTotalProgress() {
    if (azkar.isEmpty) {
      totalProgress = 0;
      return;
    }

    int completed = 0;
    int total = 0;

    for (final zekr in azkar) {
      final current = progress[zekr.id] ?? 0;
      completed += current;
      total += zekr.count;
    }

    totalProgress = total == 0 ? 0 : ((completed / total) * 100).round();
  }

  Future<void> _incrementProgress(DetailedZekr zekr) async {
    final current = progress[zekr.id] ?? 0;

    if (current >= zekr.count) return;

    final newValue = current + 1;

    setState(() {
      progress[zekr.id] = newValue;
      _calculateTotalProgress();
    });

    await TasbeehProgressService.saveProgress(
      widget.category,
      zekr.id,
      newValue,
    );

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30);
    }

    if (newValue == zekr.count && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ You completed zekr #${zekr.order}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _resetProgress(int zekrId) async {
    await TasbeehProgressService.resetProgress(widget.category, zekrId);

    setState(() {
      progress[zekrId] = 0;
      _calculateTotalProgress();
    });
  }

  Future<void> _resetAllProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: Text('Reset all azkar for ${widget.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (final zekr in azkar) {
        await TasbeehProgressService.resetProgress(
          widget.category,
          zekr.id,
        );
        progress[zekr.id] = 0;
      }

      setState(() {
        _calculateTotalProgress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 24),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: totalProgress == 100 ? Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$totalProgress%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAllProgress,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : azkar.isEmpty
              ? const Center(child: Text('No azkar available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: azkar.length,
                  itemBuilder: (context, index) {
                    final zekr = azkar[index];
                    return _buildZekrCard(
                      zekr,
                      progress[zekr.id] ?? 0,
                    );
                  },
                ),
    );
  }

  Widget _buildZekrCard(DetailedZekr zekr, int completed) {
    final isDone = completed >= zekr.count;
    final percent = (completed / zekr.count).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              zekr.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, height: 1.8),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: percent),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isDone ? null : () => _incrementProgress(zekr),
                    child: Text(isDone ? 'Completed' : 'Tasbeeh'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _resetProgress(zekr.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

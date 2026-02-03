import 'package:flutter/material.dart';
import '../data/adhkar_data.dart';
import '../models/dhikr.dart';
import 'tasbeeh_screen.dart';

/// Types of Azkar
enum AzkarType { general, morning, evening }

class AzkarListScreen extends StatefulWidget {
  final AzkarType type;

  const AzkarListScreen({
    super.key,
    required this.type,
  });

  @override
  State<AzkarListScreen> createState() => _AzkarListScreenState();
}

class _AzkarListScreenState extends State<AzkarListScreen> {
  final Map<String, int> counters = {};
  late final List<Dhikr> currentAdhkar;

  @override
  void initState() {
    super.initState();

    /// Select the correct adhkar list based on type
    switch (widget.type) {
      case AzkarType.general:
        currentAdhkar = generalAdhkar;
        break;
      case AzkarType.morning:
        currentAdhkar = morningAdhkar;
        break;
      case AzkarType.evening:
        currentAdhkar = eveningAdhkar;
        break;
    }

    /// Initialize counters (keep logic exactly as before)
    for (var dhikr in currentAdhkar) {
      counters.putIfAbsent(dhikr.id, () => 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getScreenTitle()),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: currentAdhkar.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final Dhikr dhikr = currentAdhkar[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              final updatedCount = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => TasbeehScreen(
                    dhikr: dhikr,
                    initialCount: counters[dhikr.id] ?? 0,
                  ),
                ),
              );

              if (updatedCount != null) {
                setState(() {
                  counters[dhikr.id] = updatedCount;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dhikr.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${counters[dhikr.id] ?? 0}/${dhikr.targetCount}',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Screen title based on Azkar type
  String _getScreenTitle() {
    switch (widget.type) {
      case AzkarType.general:
        return 'الأذكار';
      case AzkarType.morning:
        return 'أذكار الصباح';
      case AzkarType.evening:
        return 'أذكار المساء';
    }
  }
}
import 'package:flutter/material.dart';
import '../models/azkar_section.dart';
import '../models/dhikr.dart';
import 'tasbeeh_screen.dart';

class AzkarListScreen extends StatefulWidget {
  final AzkarSection apiSection;

  const AzkarListScreen({
    super.key,
    required this.apiSection,
  });

  @override
  State<AzkarListScreen> createState() => _AzkarListScreenState();
}

class _AzkarListScreenState extends State<AzkarListScreen> {
  final Map<String, int> counters = {};

  @override
  void initState() {
    super.initState();

    /// Initialize counters using zekr text as key (since API items don't have ID)
    for (var item in widget.apiSection.items) {
      counters.putIfAbsent(item.zekr, () => 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.apiSection.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.apiSection.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = widget.apiSection.items[index];

          /// Convert DhikrApiItem to Dhikr for TasbeehScreen compatibility
          final dhikr = Dhikr(
            id: item.zekr, // Using zekr text as unique identifier
            title: item.zekr,
            text: item.zekr,
            targetCount: item.repeat,
          );

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              final updatedCount = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => TasbeehScreen(
                    dhikr: dhikr,
                    initialCount: counters[item.zekr] ?? 0,
                  ),
                ),
              );

              if (updatedCount != null) {
                setState(() {
                  counters[item.zekr] = updatedCount;
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
                      item.zekr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${counters[item.zekr] ?? 0}/${item.repeat}',
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
}
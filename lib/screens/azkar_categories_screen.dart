import 'package:flutter/material.dart';
import 'azkar_list_screen.dart';
import '../data/adhkar_data.dart';
import '../models/azkar_section.dart';

class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({super.key});

  /// Convert local Dhikr list to AzkarSection
  AzkarSection _convertToAzkarSection(List<dynamic> dhikrList, String title) {
    final items = dhikrList.map((dhikr) {
      return DhikrApiItem(
        zekr: dhikr.text,
        repeat: dhikr.targetCount,
      );
    }).toList();

    return AzkarSection(
      title: title,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CategoryCard(
              title: 'الأذكار العامة',
              icon: Icons.auto_stories,
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AzkarListScreen(
                      apiSection: _convertToAzkarSection(
                        generalAdhkar,
                        'الأذكار العامة',
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _CategoryCard(
              title: 'أذكار الصباح',
              icon: Icons.wb_sunny_outlined,
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AzkarListScreen(
                      apiSection: _convertToAzkarSection(
                        morningAdhkar,
                        'أذكار الصباح',
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _CategoryCard(
              title: 'أذكار المساء',
              icon: Icons.nights_stay_outlined,
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AzkarListScreen(
                      apiSection: _convertToAzkarSection(
                        eveningAdhkar,
                        'أذكار المساء',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
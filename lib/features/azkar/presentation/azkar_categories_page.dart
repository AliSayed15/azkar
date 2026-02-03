import 'package:flutter/material.dart';
import 'azkar_detail_page.dart';

class AzkarCategoriesPage extends StatelessWidget {
  const AzkarCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'أذكار الصباح', 'category': 'أذكار الصباح', 'icon': Icons.wb_sunny},
      {'title': 'أذكار المساء', 'category': 'أذكار المساء', 'icon': Icons.nights_stay},
      {'title': 'أذكار النوم', 'category': 'أذكار النوم', 'icon': Icons.bedtime},
      {'title': 'أذكار الاستيقاظ', 'category': 'أذكار الاستيقاظ من النوم', 'icon': Icons.wb_twilight},
      {'title': 'أذكار بعد الصلاة', 'category': 'أذكار بعد السلام من الصلاة المفروضة', 'icon': Icons.mosque},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AzkarDetailPage(
                    title: cat['title'] as String,
                    category: cat['category'] as String,
                  ),
                ),
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 48,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
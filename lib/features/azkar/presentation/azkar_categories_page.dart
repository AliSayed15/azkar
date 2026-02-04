import 'package:flutter/material.dart';
import 'azkar_detail_page.dart';
import 'general_azkar_page.dart';  // ← السطر الجديد

class AzkarCategoriesPage extends StatelessWidget {
  const AzkarCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      // ← السطر الجديد - الأذكار العامة في الأول
      {'title': 'الأذكار العامة', 'type': 'general', 'icon': Icons.auto_awesome},
      
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
              // ← التعديل الرئيسي هنا في onTap
              onTap: () {
                if (cat['type'] == 'general') {
                  // لو الأذكار العامة، روح للصفحة الخاصة بيها
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GeneralAzkarPage(),
                    ),
                  );
                } else {
                  // لو أي أذكار تانية، روح للصفحة العادية
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AzkarDetailPage(
                        title: cat['title'] as String,
                        category: cat['category'] as String,
                      ),
                    ),
                  );
                }
              },
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
                      // ← التعديل في اللون - لو الأذكار العامة يبقى لونها amber (ذهبي)
                      color: cat['type'] == 'general' ? Colors.amber : Colors.green,
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
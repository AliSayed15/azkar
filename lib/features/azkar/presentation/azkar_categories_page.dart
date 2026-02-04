import 'package:flutter/material.dart';
import 'azkar_detail_page.dart';
import 'general_azkar_page.dart';
import 'category_azkar_page.dart';

class AzkarCategoriesPage extends StatelessWidget {
  const AzkarCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. الأذكار العامة
          _buildCategoryCard(
            context: context,
            title: 'الأذكار العامة',
            icon: Icons.auto_awesome,
            color: Colors.amber,
            isNew: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GeneralAzkarPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 2. أذكار الصباح
          _buildCategoryCard(
            context: context,
            title: 'أذكار الصباح',
            icon: Icons.wb_sunny,
            color: Colors.orange,
            isNew: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CategoryAzkarPage(
                    category: 'morning',
                    title: 'أذكار الصباح',
                    icon: Icons.wb_sunny,
                    color: Colors.orange,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 3. أذكار المساء
          _buildCategoryCard(
            context: context,
            title: 'أذكار المساء',
            icon: Icons.nights_stay,
            color: Colors.indigo,
            isNew: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CategoryAzkarPage(
                    category: 'evening',
                    title: 'أذكار المساء',
                    icon: Icons.nights_stay,
                    color: Colors.indigo,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 4. أذكار النوم
          _buildCategoryCard(
            context: context,
            title: 'أذكار النوم',
            icon: Icons.bedtime,
            color: Colors.deepPurple,
            isNew: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AzkarDetailPage(
                    title: 'أذكار النوم',
                    category: 'أذكار النوم',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 5. أذكار الاستيقاظ
          _buildCategoryCard(
            context: context,
            title: 'أذكار الاستيقاظ',
            icon: Icons.wb_twilight,
            color: Colors.pink,
            isNew: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AzkarDetailPage(
                    title: 'أذكار الاستيقاظ',
                    category: 'أذكار الاستيقاظ من النوم',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 6. أذكار بعد الصلاة
          _buildCategoryCard(
            context: context,
            title: 'أذكار بعد الصلاة',
            icon: Icons.mosque,
            color: Colors.teal,
            isNew: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AzkarDetailPage(
                    title: 'أذكار بعد الصلاة',
                    category: 'أذكار بعد السلام من الصلاة المفروضة',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required bool isNew,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // الأيقونة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            // العنوان
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // علامة "جديد"
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'جديد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(width: 8),

            // السهم
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

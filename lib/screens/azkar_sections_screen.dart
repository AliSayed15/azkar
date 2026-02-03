import 'package:flutter/material.dart';
import '../core/services/azkar_api_service.dart';
import '../models/azkar_section.dart';
import 'azkar_list_screen.dart';

class AzkarSectionsScreen extends StatefulWidget {
  const AzkarSectionsScreen({super.key});

  @override
  State<AzkarSectionsScreen> createState() => _AzkarSectionsScreenState();
}

class _AzkarSectionsScreenState extends State<AzkarSectionsScreen> {
  late Future<List<AzkarSection>> sectionsFuture;

  @override
  void initState() {
    super.initState();
    sectionsFuture = AzkarApiService.fetchAllSections();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('أقسام الأذكار')),
      body: FutureBuilder<List<AzkarSection>>(
        future: sectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading sections'));
          }
          final sections = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final section = sections[index];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AzkarListScreen(
                        apiSection: section,
                      ),
                    ),
                  );
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
                          section.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
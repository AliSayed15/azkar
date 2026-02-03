import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/azkar_cubit.dart';
import '../services/azkar_api.dart';
import '../models/zekr_model.dart';

class AzkarDetailPage extends StatelessWidget {
  final String title;
  final String category;

  const AzkarDetailPage({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCubit(AzkarApi())..loadAzkar(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: [
            BlocBuilder<AzkarCubit, List<ZekrItem>>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'تحديث',
                  onPressed: () {
                    context.read<AzkarCubit>().forceRefresh(category);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري التحديث...')),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AzkarCubit, List<ZekrItem>>(
          builder: (context, state) {
            final cubit = context.read<AzkarCubit>();

            if (cubit.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cubit.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      cubit.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => cubit.loadAzkar(category),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state.isEmpty) {
              return const Center(child: Text('لا توجد أذكار حالياً'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final zekr = state[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => cubit.decrease(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  zekr.content,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.8,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: zekr.currentCount == 0
                                    ? Colors.green
                                    : Colors.blue,
                                child: Text(
                                  zekr.currentCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (zekr.description.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                zekr.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
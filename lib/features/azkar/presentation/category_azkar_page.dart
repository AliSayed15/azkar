import 'package:flutter/material.dart';
import 'package:tasbeeh_app/features/azkar/models/detailed_zekr_model.dart';
import 'package:vibration/vibration.dart';
import '../../../core/services/azkar_service.dart';

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
      setState(() {
        azkar = data;
        // تحميل التقدم لكل ذكر
        for (var zekr in azkar) {
          progress[zekr.id] = AzkarService.getProgress(widget.category, zekr.id);
        }
        isLoading = false;
      });
      _calculateTotalProgress();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل الأذكار: $e')),
        );
      }
    }
  }

  void _calculateTotalProgress() async {
    final progressData = await AzkarService.getCategoryProgress(widget.category);
    setState(() {
      totalProgress = progressData['percentage'] ?? 0;
    });
  }

  Future<void> _incrementProgress(DetailedZekr zekr) async {
    final currentProgress = progress[zekr.id] ?? 0;
    
    if (currentProgress < zekr.count) {
      setState(() {
        progress[zekr.id] = currentProgress + 1;
      });

      await AzkarService.saveProgress(widget.category, zekr.id, progress[zekr.id]!);
      _calculateTotalProgress();

      // اهتزاز
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 30);
      }

      // إشعار عند الإكمال
      if (progress[zekr.id] == zekr.count) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ بارك الله فيك! أتممت الذكر رقم ${zekr.order}'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  Future<void> _resetProgress(int zekrId) async {
    await AzkarService.resetProgress(widget.category, zekrId);
    setState(() {
      progress[zekrId] = 0;
    });
    _calculateTotalProgress();
  }

  Future<void> _resetAllProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد'),
        content: Text('هل تريد إعادة تعيين جميع أذكار ${widget.title}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('نعم'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AzkarService.resetCategoryProgress(widget.category);
      setState(() {
        for (var zekr in azkar) {
          progress[zekr.id] = 0;
        }
      });
      _calculateTotalProgress();
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
          // عرض النسبة المئوية
          Center(
            child: Container(
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
                  fontSize: 14,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة تعيين الكل',
            onPressed: _resetAllProgress,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : azkar.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد أذكار متاحة حالياً',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: azkar.length,
                  itemBuilder: (context, index) {
                    final zekr = azkar[index];
                    final completed = progress[zekr.id] ?? 0;
                    return _buildZekrCard(zekr, completed);
                  },
                ),
    );
  }

  Widget _buildZekrCard(DetailedZekr zekr, int completed) {
    final isFullyCompleted = completed >= zekr.count;
    final progressPercentage = (completed / zekr.count).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isFullyCompleted ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رقم الذكر والحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${zekr.order}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ),
                if (isFullyCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'مكتمل',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // نص الذكر
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                zekr.text,
                style: const TextStyle(
                  fontSize: 20,
                  height: 2,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // العداد بالدوائر
            if (zekr.count <= 10)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(zekr.count, (i) {
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < completed ? Colors.green : Colors.grey.shade300,
                      border: Border.all(
                        color: i < completed ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: i < completed
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                }),
              )
            else
              // شريط التقدم للأعداد الكبيرة
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completed / ${zekr.count}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFullyCompleted ? Colors.green : Colors.black87,
                        ),
                      ),
                      Text(
                        '${(progressPercentage * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isFullyCompleted ? Colors.green : widget.color,
                      ),
                    ),
                  ),
                ],
              ),

            // الفضل (إن وجد)
            if (zekr.benefit != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الفضل:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            zekr.benefit!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // المرجع (إن وجد)
            if (zekr.reference != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.menu_book, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    'المرجع: ${zekr.reference}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // الأزرار
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: isFullyCompleted ? null : () => _incrementProgress(zekr),
                    icon: Icon(isFullyCompleted ? Icons.check : Icons.touch_app),
                    label: Text(isFullyCompleted ? 'مكتمل' : 'سبّح'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFullyCompleted ? Colors.grey : widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'إعادة تعيين',
                    onPressed: () => _resetProgress(zekr.id),
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
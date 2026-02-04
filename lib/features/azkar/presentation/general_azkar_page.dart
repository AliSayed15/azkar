import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';
import '../../../data/adhkar_data.dart';
import '../../../models/dhikr.dart';

class GeneralAzkarPage extends StatefulWidget {
  const GeneralAzkarPage({super.key});

  @override
  State<GeneralAzkarPage> createState() => _GeneralAzkarPageState();
}

class _GeneralAzkarPageState extends State<GeneralAzkarPage> {
  final Box box = Hive.box('tasbeehBox');
  Map<String, int> counters = {};

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  // تحميل العدادات من التخزين
  void _loadCounters() {
    for (var dhikr in generalAdhkar) {
      counters[dhikr.id] = box.get('general_${dhikr.id}', defaultValue: 0);
    }
  }

  // زيادة العداد
  Future<void> _increment(Dhikr dhikr) async {
    if (counters[dhikr.id]! < dhikr.targetCount) {
      setState(() {
        counters[dhikr.id] = counters[dhikr.id]! + 1;
      });

      // اهتزاز بسيط
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 30);
      }

      // حفظ في التخزين
      await box.put('general_${dhikr.id}', counters[dhikr.id]);

      // حفظ الإحصائيات اليومية
      final today = DateTime.now().toIso8601String().substring(0, 10);
      int todayCount = box.get('${today}_general', defaultValue: 0);
      todayCount++;
      await box.put('${today}_general', todayCount);

      // رسالة عند الإنتهاء
      if (counters[dhikr.id] == dhikr.targetCount) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ أحسنت! أتممت ${dhikr.title}'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  // إعادة تعيين عداد واحد
  Future<void> _reset(String dhikrId) async {
    setState(() {
      counters[dhikrId] = 0;
    });
    await box.put('general_$dhikrId', 0);
  }

  // إعادة تعيين كل العدادات
  Future<void> _resetAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد'),
        content: const Text('هل تريد إعادة تعيين جميع العدادات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('نعم'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (var dhikr in generalAdhkar) {
        setState(() {
          counters[dhikr.id] = 0;
        });
        await box.put('general_${dhikr.id}', 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار العامة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة تعيين الكل',
            onPressed: _resetAll,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: generalAdhkar.length,
        itemBuilder: (context, index) {
          final dhikr = generalAdhkar[index];
          final count = counters[dhikr.id] ?? 0;
          final progress = count / dhikr.targetCount;
          final isCompleted = count >= dhikr.targetCount;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dhikr.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // نص الذكر
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dhikr.text,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // العداد والتقدم
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$count / ${dhikr.targetCount}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted ? Colors.green : Colors.black87,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
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
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted ? Colors.green : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // زر الإعادة
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'إعادة تعيين',
                        onPressed: () => _reset(dhikr.id),
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // زر العد
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isCompleted ? null : () => _increment(dhikr),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: isCompleted ? Colors.grey : Colors.green,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: Text(
                        isCompleted ? 'مكتمل ✓' : 'سبح',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
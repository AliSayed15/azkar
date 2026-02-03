import 'package:flutter/material.dart';
import 'package:tasbeeh_app/features/tasbeeh/logic/tasbeehController.dart';
import 'package:tasbeeh_app/core/services/notification_service.dart';


class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  final TasbeehController controller = TasbeehController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Tasbeeh Counter'),
  centerTitle: true,
  actions: [
    // زرار اختبار الإشعارات
    IconButton(
      icon: const Icon(Icons.notifications_active),
      onPressed: () async {
       /* await NotificationService.showNotification(
          title: 'تطبيق التسبيح 📿',
          body: 'لا تنسى أذكارك اليوم!',
        );
        */
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم إرسال الإشعار!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      tooltip: 'اختبر الإشعار',
    ),
  ],
),
      
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '${controller.count} / ${controller.target}',
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 20),

      LinearProgressIndicator(
        value: controller.count / controller.target,
        minHeight: 10,
      ),

      const SizedBox(height: 40),

      GestureDetector(
        onTap: () async {
          await controller.increment();
          setState(() {});
        },
        child: Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: const Center(
            child: Text(
              'TAP',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 30),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [33, 100, 1000].map((value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () async {
                await controller.changeTarget(value);
                setState(() {});
              },
              child: Text(value.toString()),
            ),
          );
        }).toList(),
      ),

      TextButton(
        onPressed: () async {
          await controller.reset();
          setState(() {});
        },
        child: const Text('Reset'),
      ),
    ],
  ),
) ,
    );
  }
}